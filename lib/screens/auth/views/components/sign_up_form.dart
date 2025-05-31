import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../constants.dart';
import '../../../../models/user_model.dart';

class SignUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(UserModel userModel, User firebaseUser)? onSignUpSuccess;

  const SignUpForm({
    super.key,
    required this.formKey,
    this.onSignUpSuccess,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (widget.formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create Firebase user
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        final firebaseUser = userCredential.user!;

        // Update display name
        await firebaseUser.updateDisplayName(_nameController.text.trim());

        // Create user model
        final userModel = UserModel(
          fullName: _nameController.text.trim(),
          email: firebaseUser.email!,
          uid: firebaseUser.uid,
        );

        print("User created: ${userModel.toMap()}");

        // Call callback if provided
        if (widget.onSignUpSuccess != null) {
          widget.onSignUpSuccess!(userModel, firebaseUser);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Full Name
          TextFormField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "Full Name",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/User.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your full name";
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),

          // Email
          TextFormField(
            controller: _emailController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email address",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Message.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your email";
              }

              // Basic email validation
              final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegExp.hasMatch(value)) {
                return "Please enter a valid email address";
              }

              return null;
            },
          ),
          const SizedBox(height: defaultPadding),

          // Password
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a password";
              }
              if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),

          // Confirm Password
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              }
              if (value != _passwordController.text) {
                return "Passwords don't match";
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding * 2),

          // Submit Button
          ElevatedButton(
            onPressed: _isLoading ? null : _signUp,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text("Sign Up"),
          ),
        ],
      ),
    );
  }
}

//newest up there

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: widget.formKey,
//       child: Column(
//         children: [
//           // Full Name
//           TextFormField(
//             controller: _fullNameController,
//             textInputAction: TextInputAction.next,
//             keyboardType: TextInputType.name,
//             decoration: InputDecoration(
//               hintText: "Full Name",
//               prefixIcon: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
//                 child: SvgPicture.asset(
//                   "assets/icons/User.svg",
//                   height: 24,
//                   width: 24,
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .color!
//                         .withOpacity(0.3),
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Please enter your full name";
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: defaultPadding),

//           // Email
//           TextFormField(
//             controller: _emailController,
//             textInputAction: TextInputAction.next,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: "Email address",
//               prefixIcon: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
//                 child: SvgPicture.asset(
//                   "assets/icons/Message.svg",
//                   height: 24,
//                   width: 24,
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .color!
//                         .withOpacity(0.3),
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Please enter your email";
//               }

//               // Basic email validation
//               final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//               if (!emailRegExp.hasMatch(value)) {
//                 return "Please enter a valid email address";
//               }

//               return null;
//             },
//           ),
//           const SizedBox(height: defaultPadding),

//           // Password
//           TextFormField(
//             controller: _passwordController,
//             obscureText: _obscurePassword,
//             textInputAction: TextInputAction.next,
//             decoration: InputDecoration(
//               hintText: "Password",
//               prefixIcon: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
//                 child: SvgPicture.asset(
//                   "assets/icons/Lock.svg",
//                   height: 24,
//                   width: 24,
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .color!
//                         .withOpacity(0.3),
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscurePassword = !_obscurePassword;
//                   });
//                 },
//               ),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Please enter a password";
//               }
//               if (value.length < 6) {
//                 return "Password must be at least 6 characters";
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: defaultPadding),

//           // Confirm Password
//           TextFormField(
//             controller: _confirmPasswordController,
//             obscureText: _obscureConfirmPassword,
//             textInputAction: TextInputAction.done,
//             decoration: InputDecoration(
//               hintText: "Confirm Password",
//               prefixIcon: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
//                 child: SvgPicture.asset(
//                   "assets/icons/Lock.svg",
//                   height: 24,
//                   width: 24,
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .color!
//                         .withOpacity(0.3),
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscureConfirmPassword
//                       ? Icons.visibility
//                       : Icons.visibility_off,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscureConfirmPassword = !_obscureConfirmPassword;
//                   });
//                 },
//               ),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Please confirm your password";
//               }
//               if (value != _passwordController.text) {
//                 return "Passwords don't match";
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: defaultPadding * 2),

          

//           // Submit Button
//           ElevatedButton(
//             onPressed: _saveForm,
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(double.infinity, 55),
//             ),
//             child: const Text("Sign Up"),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../../constants.dart';

// class SignUpForm extends StatelessWidget {
//   const SignUpForm({
//     super.key,
//     required this.formKey,
//   });

//   final GlobalKey<FormState> formKey;

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             onSaved: (emal) {
//               // Email
//             },
//             validator: emaildValidator.call,
//             textInputAction: TextInputAction.next,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: "Email address",
//               prefixIcon: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
//                 child: SvgPicture.asset(
//                   "assets/icons/Message.svg",
//                   height: 24,
//                   width: 24,
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .color!
//                         .withOpacity(0.3),
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: defaultPadding),
//           TextFormField(
//             onSaved: (pass) {
//               // Password
//             },
//             validator: passwordValidator.call,
//             obscureText: true,
//             decoration: InputDecoration(
//               hintText: "Password",
//               prefixIcon: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
//                 child: SvgPicture.asset(
//                   "assets/icons/Lock.svg",
//                   height: 24,
//                   width: 24,
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .color!
//                         .withOpacity(0.3),
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
