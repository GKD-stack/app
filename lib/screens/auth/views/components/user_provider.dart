import 'package:flutter/foundation.dart';
import '../../../../models/user_model.dart';

//models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void updateUser({
    String? fullName,
    String? email,
    String? imageSrc,
    bool? isPro,
    String? ageGroup,
    String? employmentStatus,
    String? annualIncome,
    String? financialLiteracyLevel,
    List<String>? financialGoals,
  }) {
    if (_user == null) return;

    _user = UserModel(
      uid: _user!.uid,
      fullName: fullName ?? _user!.fullName,
      email: email ?? _user!.email,
      password: _user!.password,
      imageSrc: imageSrc ?? _user!.imageSrc,
      isPro: isPro ?? _user!.isPro,
      ageGroup: ageGroup ?? _user!.ageGroup,
      employmentStatus: employmentStatus ?? _user!.employmentStatus,
      annualIncome: annualIncome ?? _user!.annualIncome,
      financialLiteracyLevel:
          financialLiteracyLevel ?? _user!.financialLiteracyLevel,
      financialGoals: financialGoals ?? _user!.financialGoals,
    );

    notifyListeners();
  }

  void logOut() {
    _user = null;
    notifyListeners();
  }
}
