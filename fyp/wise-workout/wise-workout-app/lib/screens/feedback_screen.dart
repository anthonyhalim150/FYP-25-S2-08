import 'package:flutter/material.dart';
import 'give_feedback.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({Key? key}) : super(key: key);
  static const double rating = 4.44;
  static const int ratingCount = 53;
  static final List<String> pros = ["UI/UX", "AI Integrated Support"];
  static final List<String> cons = ["Slow Loading"];
  static final List<Map<String, dynamic>> reviews = [
    {
      "author": "Anthony Halim (Lvl. 51)",
      "date": "3 days ago",
      "rating": 4,
      "comment":
      "This app really helped me stay consistent with my workouts. The daily reminders and progress tracking keep me on track!"
    },
    {
      "author": "Anthony Halim (Lvl. 51)",
      "date": "3 days ago",
      "rating": 4,
      "comment":
      "This app really helped me stay consistent with my workouts. The daily reminders and progress tracking keep me on track!"
    },
  ];
  static final List<double> stats = [
    0.8, // 5 Stars
    0.65, // 4 Stars
    0.1, // 3 Stars
    0.0, // 2 Stars
    0.0, // 1 Star
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // back Arrow
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 24, color: colorScheme.onBackground),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  "Feedback",
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              // Rating number
              Center(
                child: Text(
                  rating.toStringAsFixed(2),
                  style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 8),
              // Stars
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                        (i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(
                        i < rating.floor()
                            ? Icons.star
                            : i < rating
                            ? Icons.star_half
                            : Icons.star_border,
                        color: const Color(0xFFF5C542), // star-yellow
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              // number of ratings
              Center(
                child: Text(
                  "Based on $ratingCount ratings",
                  style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 18),
              // Bar chart
              _buildRatingBars(context),
              const SizedBox(height: 18),
              // What customers like
              Text(
                "What Customers Like",
                style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: pros
                    .map((pro) => Chip(
                  label: Text(pro,
                      style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface)),
                  side: BorderSide(color: colorScheme.primary),
                  backgroundColor: Colors.transparent,
                ))
                    .toList(),
              ),
              const SizedBox(height: 18),
              // what to improve
              Text(
                "FitQuest in Development",
                style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: cons
                    .map((con) => Chip(
                  label:
                  Text(con, style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface)),
                  side: BorderSide(color: colorScheme.primary),
                  backgroundColor: Colors.transparent,
                ))
                    .toList(),
              ),
              const SizedBox(height: 14),
              // reviews + give feedback button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reviews ($ratingCount)",
                    style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GiveFeedbackScreen()),
                      );
                    },
                    child: Text("+ Give Feedback",
                        style: textTheme.labelLarge?.copyWith(color: colorScheme.onSecondary)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // reviews list
              Expanded(
                child: ListView.separated(
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final review = reviews[i];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                review["author"],
                                style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface),
                              ),
                              const Spacer(),
                              Text(
                                review["date"],
                                style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(
                              5,
                                  (star) => Icon(
                                star < review["rating"]
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color(0xFFF5C542),
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            review["comment"],
                            style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBars(BuildContext context) {
    final labels = ['5 Stars', '4 Stars', '3 Stars', '2 Stars', '1 Star'];
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: List.generate(5, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5),
          child: Row(
            children: [
              SizedBox(
                width: 68,
                child: Text(labels[i],
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    )),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 11,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: colorScheme.outline.withOpacity(0.18),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: stats[i],
                      child: Container(
                        height: 11,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}