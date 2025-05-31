

/// UserModel represents a user and their onboarding information.
class UserModel {
  final String uid; // Unique identifier for the user
  final String fullName;
  final String email;
  final String? imageSrc;
  final bool isPro;

  // Optional onboarding fields
  final String? ageGroup;
  final String? employmentStatus;
  final String? annualIncome;
  final String? financialLiteracyLevel;
  final List<String>? financialGoals;

  // You can keep password for local use, but don't store in Firestore!
  final String? password;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.imageSrc,
    this.isPro = false,
    this.ageGroup,
    this.employmentStatus,
    this.annualIncome,
    this.financialLiteracyLevel,
    this.financialGoals,
    this.password,
  });

  /// Converts this user to a map for Firestore/JSON.
  Map<String, dynamic> toMap(
      {bool includePassword = false, bool includeUid = false}) {
    final map = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'imageSrc': imageSrc,
      'isPro': isPro,
      'ageGroup': ageGroup,
      'employmentStatus': employmentStatus,
      'annualIncome': annualIncome,
      'financialLiteracyLevel': financialLiteracyLevel,
      'financialGoals': financialGoals,
    };

    if (includeUid) {
      map['uid'] = uid;
    }

    // Only include password if explicitly requested (not recommended for Firestore)
    if (includePassword && password != null) {
      map['password'] = password;
    }
    return map;
  }

  /// Creates a UserModel from a map (e.g., from Firestore or JSON).
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '', // ✅ Now required
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      imageSrc: map['imageSrc'],
      isPro: map['isPro'] ?? false,
      ageGroup: map['ageGroup'],
      employmentStatus: map['employmentStatus'],
      annualIncome: map['annualIncome'],
      financialLiteracyLevel: map['financialLiteracyLevel'],
      financialGoals: map['financialGoals'] != null
          ? List<String>.from(map['financialGoals'])
          : null,
      // Password should not be loaded from Firestore, but included for completeness
      password: map['password'],
    );
  }
}
