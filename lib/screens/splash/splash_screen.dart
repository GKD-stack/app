import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../repository/onboarding_repository.dart';
import '../auth/views/components/user_provider.dart';
import '../../models/user_model.dart';
import '../../route/route_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final user = _auth.currentUser;
    print("user: $user");

    if (user == null) {
      // Not signed in → send to auth/onboarding
      //Navigator.pushReplacementNamed(context, onbordingScreenRoute);
      print("here");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, onbordingScreenRoute);
      });
      return;
    }

    final onboardingRepo = OnboardingRepository();
    final userModel = await onboardingRepo.getUserData();

    if (userModel == null) {
      // No onboarding data → go to onboarding
      //Navigator.pushReplacementNamed(context, onbordingScreenRoute);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, onbordingScreenRoute);
      });
    } else {
      // Has onboarding data → go to home
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userModel);
      //Navigator.pushReplacementNamed(context, homeScreenRoute);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, homeScreenRoute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
