import 'package:cloud_firestore/cloud_firestore.dart';
import 'lesson_models.dart'; // Make sure this import exists

class LessonCategory {
  final String id;
  final String title;
  final String description;
  final String image;
  final int lessonCount;
  final int completedLessons;
  final double progressPercentage;
  final List<Lesson> lessons;

  LessonCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.lessonCount,
    required this.completedLessons,
    required this.progressPercentage,
    required this.lessons,
  });

  // Fixed factory method to match your UserProgress pattern
  factory LessonCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LessonCategory(
      id: doc.id, // Use document ID
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      lessonCount: (data['lessonCount'] as num?)?.toInt() ?? 0,
      completedLessons: (data['completedLessons'] as num?)?.toInt() ?? 0,
      progressPercentage:
          (data['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      lessons: (data['lessons'] as List<dynamic>? ?? [])
          .map((lessonData) =>
              Lesson.fromJson(lessonData as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'lessonCount': lessonCount,
      'completedLessons': completedLessons,
      'progressPercentage': progressPercentage,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}
