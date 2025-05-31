import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/screens/search/views/components/search_form.dart';

import 'components/expansion_category.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:shop/services/lesson_service.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: SearchForm(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Text(
                "Learning Paths",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            // Replace the categories with lesson paths
            const Expanded(
              child: Categories(),
            ),
          ],
        ),
      ),
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          // Finance Foundations - Active path
          LessonPathCard(
            title: "Finance Foundations",
            subtitle: "Master the basics of personal finance",
            icon: "assets/icons/Cash.svg",
            isActive: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LessonsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: defaultPadding),

          // Investment Basics - Placeholder
          LessonPathCard(
            title: "Investment Basics",
            subtitle: "Learn how to grow your wealth 🌱",
            icon: "assets/icons/saving.svg",
            isActive: false,
            onTap: () {
              _showComingSoonDialog(context, "Investment Basics");
            },
          ),

          const SizedBox(height: defaultPadding),

          // Debt Management - Placeholder
          LessonPathCard(
            title: "Debt Management",
            subtitle: "Strategies to eliminate debt 💪",
            icon: "assets/icons/debt.svg",
            isActive: false,
            onTap: () {
              _showComingSoonDialog(context, "Debt Management");
            },
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String pathName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Text('🚀 '),
            Expanded(child: Text(pathName)),
          ],
        ),
        content: const Text(
            "This amazing lesson path is coming super soon! We're working hard to make it perfect for you! 🎉✨"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Can\'t wait! 😍'),
          ),
        ],
      ),
    );
  }
}

class LessonPathCard extends StatelessWidget {
  const LessonPathCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActive
                ? [
                    primaryColor.withOpacity(0.1),
                    primaryColor.withOpacity(0.05)
                  ]
                : [
                    Colors.pink.withOpacity(0.1),
                    Colors.purple.withOpacity(0.1),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? primaryColor : Colors.pink.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (isActive ? primaryColor : Colors.pink).withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isActive
                      ? [primaryColor, primaryColor.withOpacity(0.8)]
                      : [Colors.pink, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (isActive ? primaryColor : Colors.pink)
                        .withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  height: 30,
                  width: 30,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            const SizedBox(width: defaultPadding),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? Theme.of(context).textTheme.titleLarge?.color
                          : Colors.purple[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isActive
                          ? Theme.of(context).textTheme.bodyMedium?.color
                          : Colors.pink[600],
                    ),
                  ),
                ],
              ),
            ),

            // Sparkle or arrow icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isActive ? primaryColor : Colors.pink).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isActive ? Icons.arrow_forward_ios : Icons.auto_awesome,
                color: isActive ? primaryColor : Colors.pink,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Lessons Screen
class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = FinanceLessonsService.getFinanceFoundationsLessons();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Foundations'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(defaultPadding),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: primaryColor,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                lesson.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  lesson.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.play_circle_outline,
                color: primaryColor,
                size: 28,
              ),
              onTap: () {
                _openLesson(context, lesson.id);
              },
            ),
          );
        },
      ),
    );
  }

  void _openLesson(BuildContext context, String lessonId) {
    final lesson = FinanceLessonsService.getLessonById(lessonId);
    if (lesson != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(lesson.title),
          content: SingleChildScrollView(
            child: Text(lesson.description),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Here you would navigate to the actual lesson content
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Start Lesson'),
            ),
          ],
        ),
      );
    }
  }
}
