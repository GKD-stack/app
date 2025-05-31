import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:shop/screens/auth/views/components/sign_up_form.dart';
import 'package:shop/route/route_constants.dart';
import 'components/user_provider.dart';
import '../../../constants.dart';
import '../../../models/user_model.dart';
import '../../../repository/onboarding_repository.dart';
import '../../financialdetails/financialdetails_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// Focused fix for Firebase Authentication issues
class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;
  bool _isLoading = false;

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Improved signup method focusing on authentication
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please agree to the terms and conditions')),
      );
      return;
    }

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      print('Attempting to create user with email auth...');

      // Get values from controllers
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      print('Signup attempt with email: $email');

      // IMPORTANT: Create account with Firebase with more specific error handling
      final UserCredential userCredential;
      try {
        // Using try/catch specifically for the auth operation
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        print('Firebase user created successfully!');
      } on FirebaseAuthException catch (e) {
        print('Firebase Auth Exception: ${e.code}');
        print('Error message: ${e.message}');

        String errorMessage;
        // Map Firebase error codes to user-friendly messages
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'This email is already registered';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/password accounts are not enabled';
            break;
          case 'weak-password':
            errorMessage = 'Password is too weak';
            break;
          default:
            errorMessage = 'Authentication error: ${e.message}';
        }

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );

        return; // Exit the method early
      }

      // Get Firebase user
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Failed to create user account - user is null');
      }

      print('Firebase account created with ID: ${firebaseUser.uid}');

      // Create user model
      final UserModel userModel = UserModel(
        uid: firebaseUser.uid,
        fullName: name,
        email: email,
        // Add other required fields with default values
      );

      // Handle successful sign-up
      _handleSignUpSuccess(userModel, firebaseUser);
    } catch (e) {
      print('Unexpected error in _signUp method: $e');
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: ${e.toString()}')),
      );
    }
  }

  // Handle successful sign-up and save user data
  void _handleSignUpSuccess(UserModel userModel, User firebaseUser) async {
    try {
      // Save user data to provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userModel);

      // Save user to repository/database
      final onboardingRepo = OnboardingRepository();
      await onboardingRepo.saveUserData(userModel);

      setState(() {
        _isLoading = false;
      });

      print('User data saved successfully!');

      // Navigate to financial details screen with the Firebase user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FinancialDetailsScreen(user: firebaseUser),
        ),
      );
    } catch (e) {
      print('Error in _handleSignUpSuccess: $e');
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving user data: ${e.toString()}')),
      );
    }
  }

  // For testing: Add a simple test function that can be called from a test button
  Future<void> _testFirebaseAuth() async {
    try {
      setState(() {
        _isLoading = true;
      });

      print('Testing Firebase Auth...');

      // First make sure we're logged out for testing
      await FirebaseAuth.instance.signOut();
      print('Signed out any existing users');

      // Test to create a user with a test email (won't be used in production)
      final testEmail =
          'test${DateTime.now().millisecondsSinceEpoch}@example.com';
      final testPass = 'Test123!';

      print('Attempting to create test user: $testEmail');

      final userCred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPass,
      );

      print('Test user created successfully with ID: ${userCred.user?.uid}');

      // Clean up by signing out
      await FirebaseAuth.instance.signOut();
      print('Test completed and signed out');

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firebase Auth test successful!')),
      );
    } catch (e) {
      print('Error in Firebase Auth test: $e');
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase Auth test failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Name field
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: 'Full Name'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email field
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            // Basic email validation
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Terms checkbox
                        CheckboxListTile(
                          title:
                              const Text('I agree to the terms and conditions'),
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // Sign up button
                  ElevatedButton(
                    onPressed: _signUp,
                    child: const Text('Sign Up'),
                  ),

                  const SizedBox(height: 16),

                  // Test button for Firebase Auth (only during development)
                  ElevatedButton(
                    onPressed: _testFirebaseAuth,
                    child: const Text('Test Firebase Auth'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.amber,
                    ),
                  ),

                  // Already have an account link
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, logInScreenRoute);
                    },
                    child: const Text('Already have an account? Log in'),
                  ),
                ],
              ),
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:shop/screens/auth/views/components/sign_up_form.dart';
// import 'package:shop/route/route_constants.dart';
// import 'components/user_provider.dart';
// import '../../../constants.dart';
// import '../../../models/user_model.dart';
// import '../../../repository/onboarding_repository.dart';
// import '../../financialdetails/financialdetails_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _agreeToTerms = false;
//   bool _isLoading = false;

//   // Handle successful sign-up and save user data
//   void _handleSignUpSuccess(UserModel userModel, User firebaseUser) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Save user data to provider
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       userProvider.setUser(userModel);

//       // Save user to repository/database
//       final onboardingRepo = OnboardingRepository();
//       await onboardingRepo.saveUserData(userModel);

//       setState(() {
//         _isLoading = false;
//       });

//       print('User data saved successfully!');

//       // Navigate to financial details screen with the Firebase user
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => FinancialDetailsScreen(user: firebaseUser),
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving user data: ${e.toString()}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(defaultPadding),
//                 child: Column(
//                   children: [
//                     // Pass the form key and success callback
//                     SignUpForm(
//                       formKey: _formKey,
//                       onSignUpSuccess:
//                           _agreeToTerms ? _handleSignUpSuccess : null,
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: _agreeToTerms,
//                           onChanged: (value) {
//                             setState(() {
//                               _agreeToTerms = value ?? false;
//                             });
//                           },
//                         ),
//                         Expanded(
//                           child: RichText(
//                             text: TextSpan(
//                               style: Theme.of(context).textTheme.bodyMedium,
//                               children: [
//                                 const TextSpan(text: 'I agree to the '),
//                                 TextSpan(
//                                   text: 'Terms and Conditions',
//                                   style: const TextStyle(
//                                     color: Colors.blue,
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                   recognizer: TapGestureRecognizer()
//                                     ..onTap = () {
//                                       Navigator.pushNamed(
//                                         context,
//                                         termsOfServicesScreenRoute,
//                                       );
//                                     },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(
//                           context,
//                           logInScreenRoute,
//                         );
//                       },
//                       child: const Text('Already have an account? Sign In'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:shop/screens/auth/views/components/sign_up_form.dart';
// import 'package:shop/route/route_constants.dart';
// import 'components/user_provider.dart';
// import '../../../constants.dart';
// import '../../../models/user_model.dart';
// import '../../financialdetails/financialdetails_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _agreeToTerms = false;
//   bool _isLoading = false;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _nameController.dispose();
//     super.dispose();
//   }

//   // Update the function signature to match what SignUpForm expects
//   void _saveUserData(UserModel userModel, User firebaseUser) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       userProvider.setUser(userModel); // Save basic info (name, email, etc.)

//       setState(() {
//         _isLoading = false;
//       });

//       // Navigate to the financial details screen with the Firebase user
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => FinancialDetailsScreen(user: firebaseUser),
//         ),
//       );
//       print('Saving user data and navigating...');
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     }
//   }

//   // Handle the sign-up process
//   Future<void> _signUp() async {
//     if (!_agreeToTerms) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please agree to the Terms and Conditions')),
//       );
//       return;
//     }

//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         _isLoading = true;
//       });

//       print('Email: ${_emailController.text}');
//       print('Password: ${_passwordController.text}');
//       print('Name: ${_nameController.text}');

//       try {
//         // Create Firebase user
//         final userCredential =
//             await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text,
//         );

//         final firebaseUser = userCredential.user!;

//         // Create user model
//         final userModel = UserModel(
//           fullName: _nameController.text.trim(),
//           email: firebaseUser.email!,
//           // Add more fields as needed
//         );

//         _saveUserData(userModel, firebaseUser);
//       } catch (e) {
//         setState(() {
//           _isLoading = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Sign up failed: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(defaultPadding),
//                 child: Column(
//                   children: [
//                     // Pass the controllers to the form
//                     SignUpForm(
//                       formKey: _formKey,
//                       nameController: _nameController,
//                       emailController: _emailController,
//                       passwordController: _passwordController,
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: _agreeToTerms,
//                           onChanged: (value) {
//                             setState(() {
//                               _agreeToTerms = value ?? false;
//                             });
//                           },
//                         ),
//                         Expanded(
//                           child: RichText(
//                             text: TextSpan(
//                               style: Theme.of(context).textTheme.bodyMedium,
//                               children: [
//                                 const TextSpan(text: 'I agree to the '),
//                                 TextSpan(
//                                   text: 'Terms and Conditions',
//                                   style: const TextStyle(
//                                     color: Colors.blue,
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                   recognizer: TapGestureRecognizer()
//                                     ..onTap = () {
//                                       Navigator.pushNamed(
//                                         context,
//                                         termsOfServicesScreenRoute,
//                                       );
//                                     },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _agreeToTerms ? _signUp : null,
//                       child: const Text('Sign Up'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(
//                           context,
//                           logInScreenRoute,
//                         );
//                       },
//                       child: const Text('Already have an account? Sign In'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Now this will work after running flutter pub get
// import 'package:shop/entry_point.dart';
// import 'package:shop/screens/auth/views/components/sign_up_form.dart';
// import 'package:shop/route/route_constants.dart';
// import 'components/user_provider.dart';
// import '../../../constants.dart';
// import '../../../models/user_model.dart';
// import '../../financialdetails/financialdetails_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _agreeToTerms = false;
//   bool _isLoading = false;

//   void _saveUserData(UserModel user) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final currentUser = FirebaseAuth.instance.currentUser;

//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       userProvider.setUser(user); // Save basic info (name, email, etc.)

//       setState(() {
//         _isLoading = false;
//       });

//       // ✅ Navigate to the user info onboarding screen
//       // Navigator.pushReplacementNamed(
//       //     context, financialDetailsRoute); // or onboardingRoute if defined
//       // After successful signup
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => FinancialDetailsScreen(user: currentUser),
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(defaultPadding),
//                 child: Column(
//                   children: [
//                     SignUpForm(formKey: _formKey),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: _agreeToTerms,
//                           onChanged: (value) {
//                             setState(() {
//                               _agreeToTerms = value ?? false;
//                             });
//                           },
//                         ),
//                         Expanded(
//                           child: RichText(
//                             text: TextSpan(
//                               style: Theme.of(context).textTheme.bodyMedium,
//                               children: [
//                                 const TextSpan(text: 'I agree to the '),
//                                 TextSpan(
//                                   text: 'Terms and Conditions',
//                                   style: const TextStyle(
//                                     color: Colors.blue,
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                   recognizer: TapGestureRecognizer()
//                                     ..onTap = () {
//                                       Navigator.pushNamed(
//                                         context,
//                                         termsOfServicesScreenRoute,
//                                       );
//                                     },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     // ElevatedButton(
//                     //   onPressed: _agreeToTerms
//                     //       ? () {
//                     //           if (_formKey.currentState?.validate() ?? false) {
//                     //             _formKey.currentState?.save();
//                     //             // Form submission logic would be handled in the form
//                     //           }
//                     //         }
//                     //       : null,
//                     //   child: const Text('Sign Up'),
//                     //),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(
//                           context,
//                           //signUpScreenRoute,
//                           financialDetailsRoute,
//                         );
//                       },
//                       child: const Text('Already have an account? Sign In'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
