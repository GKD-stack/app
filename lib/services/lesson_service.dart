import '../models/lesson_models.dart';
import '../data/finance_lessons_data.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';
import '../models/userprogress_model.dart';
import '../models/lessoncategory_model.dart';

class FinanceLessonsService {
  // Get all Finance Foundations lessons
  static List<Lesson> getFinanceFoundationsLessons() {
    return financeFoundationsLessons;
  }

  // Get lesson by ID
  static Lesson? getLessonById(String id) {
    return financeFoundationsLessons.firstWhere(
      (lesson) => lesson.id == id,
      //orElse: () => null,
    );
  }

  // Get next lesson in sequence
  static Lesson? getNextLesson(String currentLessonId) {
    final currentIndex = financeFoundationsLessons.indexWhere(
      (lesson) => lesson.id == currentLessonId,
    );

    if (currentIndex != -1 &&
        currentIndex < financeFoundationsLessons.length - 1) {
      return financeFoundationsLessons[currentIndex + 1];
    }
    return null;
  }

  // Check if lesson is unlocked based on prerequisites
  static bool isLessonUnlocked(
      String lessonId, List<String> completedLessonIds) {
    final lesson = getLessonById(lessonId);
    if (lesson == null) return false;

    if (lesson.prerequisiteId == null) return true;

    return completedLessonIds.contains(lesson.prerequisiteId);
  }

  // Get user's progress for a category
  static LessonCategory getLessonCategoryProgress(
      List<String> completedLessonIds) {
    final totalLessons = financeFoundationsLessons.length;
    final completedCount = financeFoundationsLessons
        .where((lesson) => completedLessonIds.contains(lesson.id))
        .length;

    return LessonCategory(
      id: "finance_foundations",
      title: "Finance Foundations",
      description: "Master the basics of personal finance and money management",
      image: "assets/icons/cash.svg",
      lessonCount: totalLessons,
      completedLessons: completedCount,
      progressPercentage: (completedCount / totalLessons) * 100,
      lessons: financeFoundationsLessons,
    );
  }
}

// Example usage methods
class LessonProgressManager {
  // Award XP and update user progress after lesson completion
  static UserProgress completeLesson(
    UserProgress currentProgress,
    String lessonId,
    int xpEarned,
  ) {
    final now = DateTime.now();
    final lastLessonDate = currentProgress.lastLessonDate;

    // Calculate streak
    int newStreak = currentProgress.currentStreak;
    if (lastLessonDate != null) {
      final daysDiff = now.difference(lastLessonDate).inDays;
      if (daysDiff == 1) {
        newStreak += 1; // Continue streak
      } else if (daysDiff > 1) {
        newStreak = 1; // Reset streak
      }
      // Same day = maintain streak
    } else {
      newStreak = 1; // First lesson
    }

    final newCompletedLessons =
        Map<String, bool>.from(currentProgress.completedLessons);
    newCompletedLessons[lessonId] = true;

    final newTotalXP = currentProgress.totalXP + xpEarned;
    final newLevel = (newTotalXP / 100).floor() + 1;

    // Check for new achievements
    final newAchievements = List<String>.from(currentProgress.achievements);
    if (newStreak == 7 && !newAchievements.contains("week_streak")) {
      newAchievements.add("week_streak");
    }
    if (newLevel > currentProgress.currentLevel &&
        !newAchievements.contains("level_up")) {
      newAchievements.add("level_up");
    }

    return UserProgress(
      userId: currentProgress.userId,
      totalXP: newTotalXP,
      currentLevel: newLevel,
      currentStreak: newStreak,
      longestStreak: newStreak > currentProgress.longestStreak
          ? newStreak
          : currentProgress.longestStreak,
      lastLessonDate: now,
      completedLessons: newCompletedLessons,
      achievements: newAchievements,
    );
  }

  // Get motivational message based on progress
  static String getMotivationalMessage(UserProgress progress) {
    if (progress.currentStreak >= 7) {
      return "🔥 You're on fire! ${progress.currentStreak} day streak!";
    } else if (progress.currentStreak >= 3) {
      return "⭐ Great momentum! Keep it up!";
    } else if (progress.totalXP > 500) {
      return "💪 You're becoming a financial pro!";
    } else {
      return "🌱 Every expert was once a beginner. You've got this!";
    }
  }
}
