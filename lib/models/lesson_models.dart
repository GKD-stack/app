class ScenarioChoice {
  final String id;
  final String text;
  final int xpReward;
  final String outcome;
  final String explanation;
  final bool isOptimal;

  ScenarioChoice({
    required this.id,
    required this.text,
    required this.xpReward,
    required this.outcome,
    required this.explanation,
    required this.isOptimal,
  });

  factory ScenarioChoice.fromJson(Map<String, dynamic> json) {
    return ScenarioChoice(
      id: json['id'] as String,
      text: json['text'] as String,
      xpReward: json['xpReward'] as int,
      outcome: json['outcome'] as String,
      explanation: json['explanation'] as String,
      isOptimal: json['isOptimal'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'xpReward': xpReward,
      'outcome': outcome,
      'explanation': explanation,
      'isOptimal': isOptimal,
    };
  }
}

class Scenario {
  final String id;
  final String title;
  final String context;
  final String avatarImage;
  final String backgroundImage;
  final List<ScenarioChoice> choices;
  final String? nextScenarioId;

  Scenario({
    required this.id,
    required this.title,
    required this.context,
    required this.avatarImage,
    required this.backgroundImage,
    required this.choices,
    this.nextScenarioId,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    return Scenario(
      id: json['id'] as String,
      title: json['title'] as String,
      context: json['context'] as String,
      avatarImage: json['avatarImage'] as String,
      backgroundImage: json['backgroundImage'] as String,
      choices: (json['choices'] as List)
          .map((e) => ScenarioChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextScenarioId: json['nextScenarioId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'context': context,
      'avatarImage': avatarImage,
      'backgroundImage': backgroundImage,
      'choices': choices.map((e) => e.toJson()).toList(),
      'nextScenarioId': nextScenarioId,
    };
  }
}

class Lesson {
  final String id;
  final String title;
  final String category;
  final String description;
  final String image;
  final String duration;
  final double rating;
  final int ratingCount;
  final bool isCompleted;
  final double progressPercentage;
  final int xpReward;
  final List<Scenario> scenarios; // New: scenario-based content
  final String? prerequisiteId; // New: lesson dependencies
  final int difficultyLevel; // New: 1-5 scale

  Lesson({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.image,
    required this.duration,
    required this.rating,
    required this.ratingCount,
    this.isCompleted = false,
    this.progressPercentage = 0.0,
    this.xpReward = 100,
    required this.scenarios,
    this.prerequisiteId,
    this.difficultyLevel = 1,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      duration: json['duration'] as String,
      rating: json['rating'] as double,
      ratingCount: json['ratingCount'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      progressPercentage: json['progressPercentage'] as double? ?? 0.0,
      xpReward: json['xpReward'] as int? ?? 100,
      scenarios: (json['scenarios'] as List)
          .map((e) => Scenario.fromJson(e as Map<String, dynamic>))
          .toList(),
      prerequisiteId: json['prerequisiteId'] as String?,
      difficultyLevel: json['difficultyLevel'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'image': image,
      'duration': duration,
      'rating': rating,
      'ratingCount': ratingCount,
      'isCompleted': isCompleted,
      'progressPercentage': progressPercentage,
      'xpReward': xpReward,
      'scenarios': scenarios.map((e) => e.toJson()).toList(),
      'prerequisiteId': prerequisiteId,
      'difficultyLevel': difficultyLevel,
    };
  }
}

