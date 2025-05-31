
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/components/dot_indicators.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../repository/onboarding_repository.dart';
import '../auth/views/components/user_provider.dart';
import '../../services/classification.dart';

class FinancialDetailsScreen extends StatefulWidget {
  final User user;
  const FinancialDetailsScreen({super.key, required this.user});

  @override
  State<FinancialDetailsScreen> createState() => _FinancialDetailsScreenState();
}

class _FinancialDetailsScreenState extends State<FinancialDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _currentStep = 0;

  String? _selectedAge;
  String? _selectedEmployment;
  String? _selectedIncome;
  String? _selectedLiteracy;
  List<String> _selectedGoals = [];

  final List<String> ageOptions = ['18–24', '25–34', '35–44', '45–60', '60+'];
  final List<String> employmentOptions = [
    'Student',
    'Employed',
    'Unemployed',
    'Self-employed'
  ];
  final List<String> incomeOptions = [
    '< \$25k',
    '\$25k–\$50k',
    '\$50k–\$100k',
    '\$100k–\$150k',
    '\$150k–\$200k',
    '\$200k–\$250k',
    '\$300k–\$350k',
    '>\$350k'
  ];
  final List<String> literacyOptions = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> goalOptions = [
    'Save money',
    'Invest',
    'Budget better',
    'Retire early',
    'Pay off debt'
  ];

  // Add method to save all user data including financial details
  Future<void> _saveUserDataWithFinancialDetails() async {
    try {
      final uid = widget.user.uid;
      if (uid == null || uid.isEmpty) {
        print("User not logged in or invalid UID");
        return;
      }

      final collectionPath = 'users';
      final docId = uid;

      final docSnapshot =
          await _firestore.collection(collectionPath).doc(docId).get();
      final data = docSnapshot.data() as Map<String, dynamic>;
      final fullName = data['fullName'] ?? 'User';
      final String? email = widget.user.email;
      // Create a complete user model with financial details
      final userModel = UserModel(
        uid: uid,
        fullName: fullName, // Use display name or default
        email: email ?? "", // Use email or empty string
      );

      // Save the basic user model first
      final onboardingRepo = OnboardingRepository();
      await onboardingRepo.saveUserData(userModel);

      // Update user provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userModel);

      print('Age: $_selectedAge');
      print('Employment: $_selectedEmployment');
      print('Income: $_selectedIncome');
      print('Literacy: $_selectedLiteracy');
      print('Goals: $_selectedGoals');
      print("Saving to user doc: $uid");

      final categoryInfo = ClassificationService.classifyAndGetInfo(
        ageGroup: _selectedAge,
        annualIncome: _selectedIncome,
        financialLiteracyLevel: _selectedLiteracy,
        financialGoals: _selectedGoals,
      );

      print('User classified as: ${categoryInfo.emoji} ${categoryInfo.title}');

      // Save financial details to the same user document
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'ageGroup': _selectedAge,
        'employmentStatus': _selectedEmployment,
        'annualIncome': _selectedIncome,
        'financialLiteracyLevel': _selectedLiteracy,
        'financialGoals': _selectedGoals,
        'financialCategory':
            categoryInfo.category.name, // Add the classification
        'financialCategoryTitle': categoryInfo.title,
        'financialCategoryEmoji': categoryInfo.emoji,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Navigate to the main app screen
      Navigator.pushReplacementNamed(context, entryPointScreenRoute);
    } catch (e) {
      print('Failed to save complete user data: $e');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving your information: $e')),
      );
    }
  }

  void _nextStep() async {
    if (_currentStep < 5) {
      setState(() => _currentStep++);
    } else {
      // Save complete user data with financial details
      print("saving financial details");
      await _saveUserDataWithFinancialDetails();
    }
  }

  Widget _buildIntroStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Replace with your own SVG or image, or remove this widget if not needed
          SvgPicture.asset(
            'assets/icons/questions.svg',
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32),
          Text(
            "Let's Personalize Your Experience",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "We'll ask you a few quick questions to tailor the app just for you.\n\n"
            "It'll take less than 2 minutes!",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _nextStep,
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownStep({
    required String title,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 30),
        DropdownButtonFormField<String>(
          value: value,
          hint: const Text("Select one"),
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildGoalsStep() {
    return Column(
      children: [
        Text("What are your financial goals?",
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          children: goalOptions.map((goal) {
            final selected = _selectedGoals.contains(goal);
            return FilterChip(
              label: Text(goal),
              selected: selected,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedGoals.add(goal);
                  } else {
                    _selectedGoals.remove(goal);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Steps: 0 = intro, 1 = age, 2 = employment, 3 = income, 4 = literacy, 5 = goals
    List<Widget> steps = [
      _buildIntroStep(),
      _buildDropdownStep(
        title: "What's your age?",
        value: _selectedAge,
        options: ageOptions,
        onChanged: (val) => setState(() => _selectedAge = val),
      ),
      _buildDropdownStep(
        title: "What's your employment status?",
        value: _selectedEmployment,
        options: employmentOptions,
        onChanged: (val) => setState(() => _selectedEmployment = val),
      ),
      _buildDropdownStep(
        title: "What's your annual income?",
        value: _selectedIncome,
        options: incomeOptions,
        onChanged: (val) => setState(() => _selectedIncome = val),
      ),
      _buildDropdownStep(
        title: "What's your financial literacy level?",
        value: _selectedLiteracy,
        options: literacyOptions,
        onChanged: (val) => setState(() => _selectedLiteracy = val),
      ),
      _buildGoalsStep(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_currentStep > 0)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("${_currentStep}/5"),
                ),
              const SizedBox(height: 20),
              Expanded(child: steps[_currentStep]),
              if (_currentStep > 0)
                ElevatedButton(
                  onPressed: _nextStep,
                  child: Text(_currentStep < 5 ? "Next" : "Finish"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}