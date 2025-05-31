import 'package:flutter/material.dart';

import '../../models/lesson_models.dart';
import '../../services/lesson_service.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get all lessons using your existing service
    final lessons = FinanceLessonsService.getFinanceFoundationsLessons();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Lessons'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(lesson.title),
              subtitle: Text(lesson.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to lesson detail or start lesson
                _openLesson(context, lesson.id);
              },
            ),
          );
        },
      ),
    );
  }

  void _openLesson(BuildContext context, String lessonId) {
    // Use your existing service to get the lesson
    final lesson = FinanceLessonsService.getLessonById(lessonId);
    if (lesson != null) {
      // Navigate to lesson detail screen
      // Navigator.push(context, MaterialPageRoute(
      //   builder: (context) => LessonDetailScreen(lesson: lesson),
      // ));
      print('Opening lesson: ${lesson.title}');
    }
  }
}
