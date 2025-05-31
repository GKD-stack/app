import 'package:cloud_firestore/cloud_firestore.dart';

class UserProgress {
  final String userId;
  final double totalXP;
  final int currentLevel;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastLessonDate;
  final Map<String, bool> completedLessons;
  final List<String> achievements;

  UserProgress({
    required this.userId,
    this.totalXP = 0,
    this.currentLevel = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastLessonDate,
    this.completedLessons = const {},
    this.achievements = const [],
  });

  factory UserProgress.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProgress(
      userId: doc.id,
      totalXP: data['totalXP']?.toDouble() ?? 0,
      currentLevel: data['currentLevel'] ?? 1,
      currentStreak: data['currentStreak'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      lastLessonDate: data['lastLessonDate']?.toDate(),
      completedLessons: Map<String, bool>.from(data['completedLessons'] ?? {}),
      achievements: List<String>.from(data['achievements'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalXP': totalXP,
      'currentLevel': currentLevel,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastLessonDate':
          lastLessonDate != null ? Timestamp.fromDate(lastLessonDate!) : null,
      'completedLessons': completedLessons,
      'achievements': achievements,
    };
  }
}
