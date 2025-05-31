import '../models/lesson_models.dart';
import '../models/userprogress_model.dart';

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
