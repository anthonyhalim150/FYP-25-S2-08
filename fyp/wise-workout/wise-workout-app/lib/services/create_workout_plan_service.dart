import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Models
class WorkoutPlan {
  final int planId;
  final String planTitle;
  final DateTime? createdAt; // backend returns TIMESTAMP; we parse if present
  final int? itemsCount;     // not required by your endpoints; kept for future

  WorkoutPlan({
    required this.planId,
    required this.planTitle,
    this.createdAt,
    this.itemsCount,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    // Accept snake_case (DB alias) or camelCase (future)
    final id = json['plan_id'] ?? json['planId'];
    final title = json['plan_title'] ?? json['planTitle'];
    final created = json['created_at'] ?? json['createdAt'];
    final items = json['items_count'] ?? json['itemsCount'];

    return WorkoutPlan(
      planId: id is int ? id : int.tryParse(id.toString()) ?? 0,
      planTitle: title?.toString() ?? '',
      createdAt: (created == null || created.toString().isEmpty)
          ? null
          : DateTime.tryParse(created.toString()),
      itemsCount: items == null ? null : (items is int ? items : int.tryParse(items.toString())),
    );
  }
}

class WorkoutPlanItem {
  final String exerciseName;
  final int? exerciseReps;
  final int? exerciseSets;
  final int? exerciseDuration;

  WorkoutPlanItem({
    required this.exerciseName,
    this.exerciseReps,
    this.exerciseSets,
    this.exerciseDuration,
  });

  factory WorkoutPlanItem.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanItem(
      exerciseName: (json['exercise_name'] ?? json['exerciseName'] ?? '').toString(),
      exerciseReps: _toIntOrNull(json['exercise_reps'] ?? json['exerciseReps']),
      exerciseSets: _toIntOrNull(json['exercise_sets'] ?? json['exerciseSets']),
      exerciseDuration: _toIntOrNull(json['exercise_duration'] ?? json['exerciseDuration']),
    );
  }

  Map<String, dynamic> toJson() => {
    'exercise_name': exerciseName,
    if (exerciseReps != null) 'exercise_reps': exerciseReps,
    if (exerciseSets != null) 'exercise_sets': exerciseSets,
    if (exerciseDuration != null) 'exercise_duration': exerciseDuration,
  };

  static int? _toIntOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}

class CreateWorkoutPlanService {
  /// Update this to your API base (emulator localhost for Android)
  final String baseUrl;

  /// Where your app stores the JWT. Many of your files use 'jwt_cookie'.
  /// We will send it as Cookie: session=<token> to satisfy your authMiddleware.
  final FlutterSecureStorage _storage;

  CreateWorkoutPlanService({
    this.baseUrl = 'http://10.0.2.2:3000',
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  // --------------------- Public API ---------------------

  /// 1) Fetch ALL plans for the current user
  Future<List<WorkoutPlan>> getMyPlans() async {
    final res = await _get('/user-workout-plans');
    final data = _decodeJson(res);
    if (data is List) {
      return data.map((e) => WorkoutPlan.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    throw Exception('Unexpected response format when fetching plans.');
  }

  /// 2) Create a plan (no user_id needed)
  Future<WorkoutPlan> createPlan({required String planTitle}) async {
    final res = await _post('/user-workout-plans', body: {
      'plan_title': planTitle,
    });
    final data = _decodeJson(res);
    // backend returns { plan_id, plan_title }
    final planId = (data['plan_id'] as int?) ??
        int.tryParse(data['plan_id']?.toString() ?? '');
    if (planId == null) {
      throw Exception('Plan created but no plan_id returned');
    }
    return WorkoutPlan(
      planId: planId,
      planTitle: (data['plan_title'] ?? planTitle).toString(),
    );
  }

  /// 3) Get items for a plan by planId
  Future<List<WorkoutPlanItem>> getPlanItems(int planId) async {
    final res = await _get('/user-workout-plans/$planId/items');
    final data = _decodeJson(res);
    if (data is List) {
      return data
          .map((e) => WorkoutPlanItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    throw Exception('Unexpected response format when fetching items.');
  }

  /// 4) Delete a plan
  Future<void> deletePlan(int planId) async {
    final res = await _delete('/user-workout-plans/$planId');
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to delete plan (${res.statusCode})');
    }
  }

  // ----- Optional: for plus-to-add flow if/when you enable it on backend -----

  /// Add one item to a plan (if your backend exposes POST /:planId/item)
  Future<int> addOneItem({
    required int planId,
    required WorkoutPlanItem item,
  }) async {
    final res = await _post('/user-workout-plans/$planId/item', body: item.toJson());
    final data = _decodeJson(res);
    final itemId = data['item_id'] ?? data['id'];
    if (itemId == null) throw Exception('Item add returned no item_id');
    return (itemId is int) ? itemId : int.parse(itemId.toString());
  }

  /// Add multiple items to a plan (if your backend exposes POST /:planId/items)
  Future<int> addItemsBulk({
    required int planId,
    required List<WorkoutPlanItem> items,
  }) async {
    final body = {'items': items.map((e) => e.toJson()).toList()};
    final res = await _post('/user-workout-plans/$planId/items', body: body);
    final data = _decodeJson(res);
    final inserted = data['inserted_count'] ?? data['affectedRows'];
    return inserted is int ? inserted : int.tryParse(inserted.toString()) ?? 0;
  }

  // --------------------- HTTP helpers ---------------------

  Future<String?> _getStoredToken() async {
    // Many of your services read 'jwt_cookie'. Adjust if your key name differs.
    return _storage.read(key: 'jwt_cookie');
  }

  Map<String, String> _headersWithCookie(String? token) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Cookie'] = 'session=$token';
    }
    return headers;
  }

  Uri _u(String path) => Uri.parse('$baseUrl$path');

  Future<http.Response> _get(String path) async {
    final t = await _getStoredToken();
    final res = await http.get(_u(path), headers: _headersWithCookie(t));
    _throwIfNotOk(res);
    return res;
  }

  Future<http.Response> _post(String path, {Map<String, dynamic>? body}) async {
    final t = await _getStoredToken();
    final res = await http.post(_u(path),
        headers: _headersWithCookie(t), body: jsonEncode(body ?? {}));
    _throwIfNotOk(res);
    return res;
  }

  Future<http.Response> _delete(String path) async {
    final t = await _getStoredToken();
    final res = await http.delete(_u(path), headers: _headersWithCookie(t));
    _throwIfNotOk(res);
    return res;
  }

  dynamic _decodeJson(http.Response res) {
    return res.body.isEmpty ? {} : jsonDecode(res.body);
  }

  void _throwIfNotOk(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }
}
