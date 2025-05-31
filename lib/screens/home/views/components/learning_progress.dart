import 'package:flutter/material.dart';

const double defaultPadding = 16.0;

class LearningProgress extends StatelessWidget {
  //const LearningProgress({Key? key}) : super(key: key);
  const LearningProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // defaultPadding value
      margin: const EdgeInsets.symmetric(
        horizontal: 16, // defaultPadding value
        vertical: 8, // defaultPadding / 2
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Learning Progress",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("View All"),
              ),
            ],
          ),
          const SizedBox(height: 16), // defaultPadding value
          const ProgressCategory(
            title: "Investing Basics",
            progress: 0.75,
            progressText: "75% Complete",
            lessonsCompleted: "3/4 Lessons",
            color: Color(0xFF4CAF50),
          ),
          const SizedBox(height: 8), // defaultPadding / 2
          const ProgressCategory(
            title: "Budgeting",
            progress: 0.5,
            progressText: "50% Complete",
            lessonsCompleted: "2/4 Lessons",
            color: Color(0xFF2196F3),
          ),
          const SizedBox(height: defaultPadding / 2),
          const ProgressCategory(
            title: "Debt Management",
            progress: 0.25,
            progressText: "25% Complete",
            lessonsCompleted: "1/4 Lessons",
            color: Color(0xFFFFC107),
          ),
          const SizedBox(height: defaultPadding / 2),
          const ProgressCategory(
            title: "Retirement Planning",
            progress: 0.0,
            progressText: "Not Started",
            lessonsCompleted: "0/4 Lessons",
            color: Color(0xFFE91E63),
          ),
        ],
      ),
    );
  }
}

class ProgressCategory extends StatelessWidget {
  final String title;
  final double progress;
  final String progressText;
  final String lessonsCompleted;
  final Color color;

  const ProgressCategory({
    Key? key,
    required this.title,
    required this.progress,
    required this.progressText,
    required this.lessonsCompleted,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), // defaultPadding / 2
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                progressText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            lessonsCompleted,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                ),
          ),
        ],
      ),
    );
  }
}
