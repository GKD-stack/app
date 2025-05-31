import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/components/dot_indicators.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../repository/onboarding_repository.dart';
import '../../auth/views/components/user_provider.dart';
// Import the FinancialDetailsScreen from the correct file
import '../../financialdetails/financialdetails_screen.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  final List<Onbord> _onbordData = [
    Onbord(
      image: "assets/Illustration/Illustration-0.png",
      imageDarkTheme: "assets/Illustration/Illustration_darkTheme_0.png",
      title: "Find the financial literacy platform you've \nbeen looking for",
      description:
          "Rich and personalized content carefully curated for everyday learning on the go.",
    ),
    Onbord(
      image: "assets/Illustration/Illustration-1.png",
      imageDarkTheme: "assets/Illustration/Illustration_darkTheme_1.png",
      title: "Fill Out Your Personal Profile",
      description:
          "Tell us about yourself and your financial goals, and we'll help you get there.",
    ),
    Onbord(
      image: "assets/Illustration/Illustration-3.png",
      imageDarkTheme: "assets/Illustration/Illustration_darkTheme_3.png",
      title: "Lesson tracking",
      description:
          "Stay updated with your progress and get reminders for your next lesson.",
    ),
    Onbord(
      image: "assets/Illustration/Illustration-4.png",
      imageDarkTheme: "assets/Illustration/Illustration_darkTheme_4.png",
      title: "Current Events",
      description:
          "Enhance your knowledge with the latest financial news and events.",
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Add method to save user data to Firebase
  Future<void> _saveUserDataToFirebase(BuildContext context) async {
    print('Starting to save user data to Firebase...');

    //In a real app, collect this from user input in previous screens
    final String name = "Jane Doe 2.0";
    final String email = "jane@example.com";
    final String uid = "1234567890"; // Replace with actual UID

    try {
      print('Creating user model...');
      final user = UserModel(uid: uid, fullName: name, email: email);
      print('User model created: ${user.toMap()}');

      print('Creating repository...');
      final onboardingRepo = OnboardingRepository();

      print('Getting UserProvider...');
      // Make sure UserProvider is properly set up in your widget tree
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      print('Saving user data to Firebase...');
      await onboardingRepo.saveUserData(user);
      print('User data saved successfully to Firebase!');

      print('Updating UserProvider...');
      userProvider.setUser(user);

      print('Now navigating to login screen...');
      //After saving data, navigate to login screen
      Navigator.pushNamed(context, logInScreenRoute);
    } catch (e) {
      print('Error during saving user data: $e');
      // Show error to user but still navigate to login screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
      // Navigate to login even if saving data fails
      Navigator.pushNamed(context, logInScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  //onPressed: () => _saveUserDataToFirebase(context),
                  onPressed: () {
                    // Navigate to the login screen directly
                    Navigator.pushNamed(context, logInScreenRoute);
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onbordData.length,
                  onPageChanged: (value) {
                    setState(() {
                      _pageIndex = value;
                    });
                  },
                  itemBuilder: (context, index) => OnbordingContent(
                    title: _onbordData[index].title,
                    description: _onbordData[index].description,
                    image: (Theme.of(context).brightness == Brightness.dark &&
                            _onbordData[index].imageDarkTheme != null)
                        ? _onbordData[index].imageDarkTheme!
                        : _onbordData[index].image,
                    isTextOnTop: index.isOdd,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    _onbordData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: defaultPadding / 4),
                      child: DotIndicator(isActive: index == _pageIndex),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_pageIndex < _onbordData.length - 1) {
                          _pageController.nextPage(
                              curve: Curves.ease, duration: defaultDuration);
                        } else {
                          // Save data and then navigate
                          Navigator.pushNamed(context, logInScreenRoute);
                          //_saveUserDataToFirebase(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Arrow - Right.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}

class OnbordingContent extends StatelessWidget {
  const OnbordingContent({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    this.isTextOnTop = false,
  }) : super(key: key);

  final String title, description, image;
  final bool isTextOnTop;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Image.asset(
            image,
            fit: BoxFit.contain,
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: defaultPadding / 2),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}

class Onbord {
  final String image, title, description;
  final String? imageDarkTheme;

  Onbord({
    required this.image,
    required this.title,
    this.description = "",
    this.imageDarkTheme,
  });
}
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:shop/components/dot_indicators.dart';
// import 'package:shop/constants.dart';
// import 'package:shop/route/route_constants.dart';
// import 'package:provider/provider.dart';

// import '../../../models/user_model.dart';
// import '../../auth/views/components/user_provider.dart';
// import '../../financialdetails/financialdetails_screen.dart'; // Import the FinancialDetailsScreen


// // Keep the original class name since this might be referenced in routes
// class OnBordingScreen extends StatefulWidget {
//   const OnBordingScreen({super.key});

//   @override
//   State<OnBordingScreen> createState() => _OnBordingScreenState();
// }

// class _OnBordingScreenState extends State<OnBordingScreen> {
//   late PageController _pageController;
//   int _pageIndex = 0;

//   // Use your original Onbord class name since it may be referenced elsewhere
//   final List<Onbord> _onbordData = [
//     Onbord(
//       image: "assets/Illustration/Illustration-0.png",
//       imageDarkTheme: "assets/Illustration/Illustration_darkTheme_0.png",
//       title: "Find the financial literacy platform you've \nbeen looking for",
//       description:
//           "Rich and personalized content carefully curated for everyday learning on the go.",
//     ),
//     Onbord(
//       image: "assets/Illustration/Illustration-1.png",
//       imageDarkTheme: "assets/Illustration/Illustration_darkTheme_1.png",
//       title: "Fill Out Your Personal Profile",
//       description:
//           "Tell us about yourself and your financial goals, and we'll help you get there.",
//     ),
//     Onbord(
//       image: "assets/Illustration/Illustration-3.png",
//       imageDarkTheme: "assets/Illustration/Illustration_darkTheme_3.png",
//       title: "Lesson tracking",
//       description:
//           "Stay updated with your progress and get reminders for your next lesson.",
//     ),
//     Onbord(
//       image: "assets/Illustration/Illustration-4.png",
//       imageDarkTheme: "assets/Illustration/Illustration_darkTheme_4.png",
//       title: "Current Events",
//       description:
//           "Enhance your knowledge with the latest financial news and events.",
//     ),
//   ];

//   @override
//   void initState() {
//     _pageController = PageController(initialPage: 0);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   //final DatabaseReference _database = FirebaseDatabase.instance.ref();

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
//   // Add the function to save user data to Firebase
//   Future<void> _saveUserDataToFirebase(BuildContext context) async {
//     print('Starting to save user data to Firebase...');

//     // In a real app, collect this from user input in previous screens
//     final String name = "Jane Doe";
//     final String email = "jane@example.com";

//     try {
      
//       print('Creating user model...');
//       final user = UserModel(fullName: name, email: email);
//       print('User model created: ${user.toMap()}');

//       print('Creating repository...');
//       final onboardingRepo = OnboardingRepository();

//       print('Getting UserProvider...');
//       // Make sure UserProvider is properly set up in your widget tree
//       final userProvider = Provider.of<UserProvider>(context, listen: false);

//       print('Saving user data to Firebase...');
//       //await _database.child('users').child(user.email.replaceAll('.', '_')).set(user.toMap());
//       await onboardingRepo.saveUserData(user);
//       print('User data saved successfully to Firebase!');

//       print('Updating UserProvider...');
//       userProvider.setUser(user);

//       print('Now navigating to login screen...');
//       // After saving data, navigate to login screen as in your original code
//       Navigator.pushNamed(context, logInScreenRoute);
//     } catch (e) {
//       print('Error during saving user data: $e');
//       // Show error to user but still navigate to login screen
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving data: $e')),
//       );
//       // Navigate to login even if saving data fails
//       Navigator.pushNamed(context, logInScreenRoute);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () => _saveUserDataToFirebase(context),
//                   child: Text(
//                     "Skip",
//                     style: TextStyle(
//                         color: Theme.of(context).textTheme.bodyLarge!.color),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: PageView.builder(
//                   controller: _pageController,
//                   itemCount: _onbordData.length,
//                   onPageChanged: (value) {
//                     setState(() {
//                       _pageIndex = value;
//                     });
//                   },
//                   itemBuilder: (context, index) => OnbordingContent(
//                     title: _onbordData[index].title,
//                     description: _onbordData[index].description,
//                     image: (Theme.of(context).brightness == Brightness.dark &&
//                             _onbordData[index].imageDarkTheme != null)
//                         ? _onbordData[index].imageDarkTheme!
//                         : _onbordData[index].image,
//                     isTextOnTop: index.isOdd,
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   ...List.generate(
//                     _onbordData.length,
//                     (index) => Padding(
//                       padding: const EdgeInsets.only(right: defaultPadding / 4),
//                       child: DotIndicator(isActive: index == _pageIndex),
//                     ),
//                   ),
//                   const Spacer(),
//                   SizedBox(
//                     height: 60,
//                     width: 60,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_pageIndex < _onbordData.length - 1) {
//                           _pageController.nextPage(
//                               curve: Curves.ease, duration: defaultDuration);
//                         } else {
//                           // Save data and then navigate
//                           _saveUserDataToFirebase(context);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: const CircleBorder(),
//                       ),
//                       child: SvgPicture.asset(
//                         "assets/icons/Arrow - Right.svg",
//                         colorFilter: const ColorFilter.mode(
//                           Colors.white,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: defaultPadding),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Keep original class name for compatibility
// class OnbordingContent extends StatelessWidget {
//   const OnbordingContent({
//     Key? key,
//     required this.title,
//     required this.description,
//     required this.image,
//     this.isTextOnTop = false,
//   }) : super(key: key);

//   final String title, description, image;
//   final bool isTextOnTop;

//   @override
//   Widget build(BuildContext context) {
//     // Keep your original implementation
//     return Column(
//       children: [
//         // Implementation as per your original code
//         // This is a placeholder - you should replace with your actual implementation
//         Expanded(
//           child: Image.asset(
//             image,
//             fit: BoxFit.contain,
//           ),
//         ),
//         Text(
//           title,
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.w500,
//               ),
//         ),
//         const SizedBox(height: defaultPadding / 2),
//         Text(
//           description,
//           textAlign: TextAlign.center,
//         ),
//         const Spacer(),
//       ],
//     );
//   }
// }

// // Keep original Onbord class since this might be used elsewhere
// class Onbord {
//   final String image, title, description;
//   final String? imageDarkTheme;

//   Onbord({
//     required this.image,
//     required this.title,
//     this.description = "",
//     this.imageDarkTheme,
//   });
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:shop/components/dot_indicators.dart';
// import 'package:shop/constants.dart';
// import 'package:shop/route/route_constants.dart';

// import 'components/onbording_content.dart';

// import '../../../models/user_model.dart';
// import '../../../repository/onboarding_repository.dart';
// import 'package:provider/provider.dart';
// import '../../auth/views/components/user_provider.dart'; // adjust path as needed

// class OnBordingScreen extends StatefulWidget {
//   const OnBordingScreen({super.key});

//   @override
//   State<OnBordingScreen> createState() => _OnBordingScreenState();
// }

// class _OnBordingScreenState extends State<OnBordingScreen> {
//   late PageController _pageController;
//   int _pageIndex = 0;
//   final List<Onbord> _onbordData = [
//     Onbord(
//       image: "assets/Illustration/Illustration-0.png",
//       imageDarkTheme: "assets/Illustration/Illustration_darkTheme_0.png",
//       title: "Find the financial literacy platform you’ve \nbeen looking for",
//       description:
//           "Rich and personalized content carefully curated for everyday learning on the go.",
//     ),
//     Onbord(
//       image: "assets/Illustration/Illustration-1.png",
//       imageDarkTheme: "assets/Illustration/Illustration_darkTheme_1.png",
//       title: "Fill Out Your Personal Profile",
//       description:
//           "Tell us about yourself and your financial goals, and we’ll help you get there.",
//     ),
//     Onbord(
//       image: "assets/Illustration/Illustration-3.png",
//       imageDarkTheme: "assets/Illustration/Illustration_darkTheme_3.png",
//       title: "Lesson tracking",
//       description:
//           "Stay updated with your progress and get reminders for your next lesson.",
//     ),
//     Onbord(
//       image: "assets/Illustration/Illustration-4.png",
//       imageDarkTheme: "assets/Illustration/Illustration_darkTheme_4.png",
//       title: "Current Events",
//       description:
//           "Enhance your knowledge with the latest financial news and events.",
//     ),
//   ];

//   @override
//   void initState() {
//     _pageController = PageController(initialPage: 0);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, logInScreenRoute);
//                     //await AuthService().signUp(email, password);
//                     //   Navigator.pushReplacement(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (_) => const logInScreenRoute()),
//                     //   );
//                   },
//                   child: Text(
//                     "Skip",
//                     style: TextStyle(
//                         color: Theme.of(context).textTheme.bodyLarge!.color),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: PageView.builder(
//                   controller: _pageController,
//                   itemCount: _onbordData.length,
//                   onPageChanged: (value) {
//                     setState(() {
//                       _pageIndex = value;
//                     });
//                   },
//                   itemBuilder: (context, index) => OnbordingContent(
//                     title: _onbordData[index].title,
//                     description: _onbordData[index].description,
//                     image: (Theme.of(context).brightness == Brightness.dark &&
//                             _onbordData[index].imageDarkTheme != null)
//                         ? _onbordData[index].imageDarkTheme!
//                         : _onbordData[index].image,
//                     isTextOnTop: index.isOdd,
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   ...List.generate(
//                     _onbordData.length,
//                     (index) => Padding(
//                       padding: const EdgeInsets.only(right: defaultPadding / 4),
//                       child: DotIndicator(isActive: index == _pageIndex),
//                     ),
//                   ),
//                   const Spacer(),
//                   SizedBox(
//                     height: 60,
//                     width: 60,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_pageIndex < _onbordData.length - 1) {
//                           _pageController.nextPage(
//                               curve: Curves.ease, duration: defaultDuration);
//                         } else {
//                           Navigator.pushNamed(context, logInScreenRoute);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: const CircleBorder(),
//                       ),
//                       child: SvgPicture.asset(
//                         "assets/icons/Arrow - Right.svg",
//                         colorFilter: const ColorFilter.mode(
//                           Colors.white,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: defaultPadding),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OnboardingScreen extends StatelessWidget {
//   const OnboardingScreen({super.key});

//   void onCompleteOnboarding(
//       BuildContext context, String name, String email) async {
//     final user = UserModel(fullName: name, email: email);
//     final onboardingRepo = OnboardingRepository();
//     final userProvider = Provider.of<UserProvider>(context, listen: false);

//     await onboardingRepo.saveUserData(user);
//     userProvider.setUser(user);

//     Navigator.pushReplacementNamed(context, homeScreenRoute);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // your UI here
//       floatingActionButton: FloatingActionButton(
//         onPressed: () =>
//             onCompleteOnboarding(context, "Jane Doe", "jane@example.com"),
//         child: const Icon(Icons.check),
//       ),
//     );
//   }
// }

// void onCompleteOnboarding(
//     BuildContext context, String name, String email) async {
//   print('Starting onCompleteOnboarding...');
//   final user = UserModel(fullName: name, email: email);
//   print('User model created: ${user.toMap()}');

//   final onboardingRepo = OnboardingRepository();
//   print('Repository created');

//   final userProvider = Provider.of<UserProvider>(context, listen: false);
//   print('Repository created');

//   try {
//     print('Attempting to save user data...');
//     await onboardingRepo.saveUserData(user);
//     print('User data saved successfully!');

//     userProvider.setUser(user);
//     print('User set in provider');

//     Navigator.pushReplacementNamed(context, homeScreenRoute);
//     print('Navigation completed');
//   } catch (e) {
//     print('Error in onCompleteOnboarding: $e');
//   }

//   // await onboardingRepo.saveUserData(user);
//   // userProvider.setUser(user);

//   // Navigator.pushReplacementNamed(context, homeScreenRoute);
//   // print('User data saved to Firestore: ${user.toMap()}');
// }

// class Onbord {
//   final String image, title, description;
//   final String? imageDarkTheme;

//   Onbord({
//     required this.image,
//     required this.title,
//     this.description = "",
//     this.imageDarkTheme,
//   });
// }


