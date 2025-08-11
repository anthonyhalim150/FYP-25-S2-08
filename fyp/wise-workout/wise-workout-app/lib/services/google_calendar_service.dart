import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:http/http.dart' as http;

/// A lightweight HTTP client that injects Google auth headers into requests.
class _AuthedClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  _AuthedClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}

/// Service responsible for pushing workout plan days to Google Calendar.
/// Designed to be used from Controllers/Views without leaking auth/HTTP details.
class GoogleCalendarService {
  /// You can pass your own GoogleSignIn instance (from AuthService)
  /// or let this service create one (it includes the Calendar scope).
  GoogleCalendarService({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ??
      GoogleSignIn(
        scopes: const [
          'email',
          'profile',
          'https://www.googleapis.com/auth/calendar', // Calendar scope
        ],
      );

  final GoogleSignIn _googleSignIn;

  /// Attempts a silent sign-in, then interactive if needed.
  /// Ensures Calendar scope is granted.
  Future<Map<String, String>> _getAuthHeaders() async {
    GoogleSignInAccount? account = await _googleSignIn.signInSilently();
    account ??= await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign-in was cancelled.');
    }
    // Ensure we have calendar scope (in case your app previously signed-in without it).
    final granted = await _googleSignIn.requestScopes(
      ['https://www.googleapis.com/auth/calendar'],
    );
    if (granted != true) {
      throw Exception('Calendar permission was not granted.');
    }
    final headers = await account.authHeaders;
    return headers;
  }

  /// Adds a single workout event.
  ///
  /// [summary] - event title (e.g. "Day 5: Upper Body")
  /// [start]   - start DateTime (local)
  /// [durationMinutes] - duration length in minutes
  /// [timeZone] - IANA TZ (defaults to Asia/Singapore)
  /// [description] - optional extra details (e.g. sets/reps breakdown)
  Future<gcal.Event> addEvent({
    required String summary,
    required DateTime start,
    int durationMinutes = 45,
    String timeZone = 'Asia/Singapore',
    String? description,
    List<String>? attendeesEmails, // optional
    String calendarId = 'primary',
  }) async {
    final headers = await _getAuthHeaders();
    final api = gcal.CalendarApi(_AuthedClient(headers));

    final end = start.add(Duration(minutes: durationMinutes));

    final event = gcal.Event(
      summary: summary,
      description: description,
      start: gcal.EventDateTime(dateTime: start, timeZone: timeZone),
      end: gcal.EventDateTime(dateTime: end, timeZone: timeZone),
      // Optional: add attendees if you want to invite someone
      attendees: attendeesEmails
          ?.map((e) => gcal.EventAttendee(email: e))
          .toList(),
      reminders: gcal.EventReminders(
        useDefault: false,
        overrides: [
          gcal.EventReminder(method: 'popup', minutes: 10),
        ],
      ),
    );

    final inserted = await api.events.insert(event, calendarId);
    return inserted;
  }

  /// Adds ALL days from a plan list to the user's calendar.
  ///
  /// Expects your day objects to contain:
  /// - 'calendar_date': DateTime
  /// - 'rest': bool
  /// - 'exercises': List (each exercise can have 'name', 'sets', 'reps')
  ///
  /// [defaultStartHour]/[defaultStartMinute] set the time for each day.
  /// Return value is a list of created Events (skips rest/null days).
  Future<List<gcal.Event>> addWholePlan({
    required List<dynamic> planDays,
    int defaultStartHour = 7,
    int defaultStartMinute = 0,
    int durationMinutesPerDay = 45,
    String timeZone = 'Asia/Singapore',
    String calendarId = 'primary',
  }) async {
    final headers = await _getAuthHeaders();
    final api = gcal.CalendarApi(_AuthedClient(headers));

    final created = <gcal.Event>[];

    for (int i = 0; i < planDays.length; i++) {
      final day = planDays[i];

      final date = day['calendar_date'];
      final isRest = (day['rest'] == true);
      if (date == null || date is! DateTime || isRest) {
        // Skip invalid or rest days
        continue;
      }

      // Build title and description from exercises
      final idx = i + 1;
      final summary = _buildEventTitle(day, defaultTitle: 'Workout Day $idx');

      final description = _buildDescription(day);

      final start = DateTime(
        date.year,
        date.month,
        date.day,
        defaultStartHour,
        defaultStartMinute,
      );

      final event = gcal.Event(
        summary: summary,
        description: description,
        start: gcal.EventDateTime(dateTime: start, timeZone: timeZone),
        end: gcal.EventDateTime(
          dateTime: start.add(Duration(minutes: durationMinutesPerDay)),
          timeZone: timeZone,
        ),
        reminders: gcal.EventReminders(
          useDefault: false,
          overrides: [
            gcal.EventReminder(method: 'popup', minutes: 10),
          ],
        ),
      );

      final inserted = await api.events.insert(event, calendarId);
      created.add(inserted);
    }

    return created;
  }

  /// Adds only the days that fall within [visibleMonth] (month/year).
  /// Use this if you want a button like "Sync This Month" from your Calendar page.
  Future<List<gcal.Event>> addVisibleMonth({
    required List<dynamic> planDays,
    required DateTime visibleMonth,
    int defaultStartHour = 7,
    int defaultStartMinute = 0,
    int durationMinutesPerDay = 45,
    String timeZone = 'Asia/Singapore',
    String calendarId = 'primary',
  }) async {
    final month = DateTime(visibleMonth.year, visibleMonth.month);
    final nextMonth = DateTime(visibleMonth.year, visibleMonth.month + 1);

    final subset = planDays.where((d) {
      final dt = d['calendar_date'];
      return (dt is DateTime) && !d['rest'] == true && dt.isAfter(month.subtract(const Duration(seconds: 1))) && dt.isBefore(nextMonth);
    }).toList();

    return addWholePlan(
      planDays: subset,
      defaultStartHour: defaultStartHour,
      defaultStartMinute: defaultStartMinute,
      durationMinutesPerDay: durationMinutesPerDay,
      timeZone: timeZone,
      calendarId: calendarId,
    );
  }

  /// Helper to build a neat title from a day object.
  String _buildEventTitle(Map<String, dynamic> day, {required String defaultTitle}) {
    // If the day has a label/notes, use it, otherwise derive from first exercise.
    final exs = (day['exercises'] as List?) ?? const [];
    if (exs.isNotEmpty) {
      final first = exs.first;
      final exName = (first['name'] ?? first['exerciseName'])?.toString();
      if (exName != null && exName.trim().isNotEmpty) {
        return 'Workout: $exName';
      }
    }
    // Fallback
    return defaultTitle;
  }

  /// Helper to build a readable description from exercises/notes.
  String _buildDescription(Map<String, dynamic> day) {
    final buffer = StringBuffer();
    final exs = (day['exercises'] as List?) ?? const [];
    if (exs.isNotEmpty) {
      buffer.writeln('Exercises:');
      for (final ex in exs) {
        final name = (ex['name'] ?? ex['exerciseName'])?.toString() ?? 'Exercise';
        final sets = (ex['sets'] ?? ex['exerciseSets'])?.toString() ?? '-';
        final reps = (ex['reps'] ?? ex['exerciseReps'])?.toString() ?? '-';
        buffer.writeln('• $name — ${sets}×${reps}');
      }
    }
    final notes = day['notes']?.toString();
    if (notes != null && notes.trim().isNotEmpty) {
      if (buffer.isNotEmpty) buffer.writeln();
      buffer.writeln('Notes: $notes');
    }
    return buffer.toString().trim();
  }
}
