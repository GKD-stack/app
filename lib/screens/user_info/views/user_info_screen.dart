import 'package:flutter/material.dart';
import 'package:shop/components/buy_full_ui_kit.dart';

// class UserInfoScreen extends StatelessWidget {
//   const UserInfoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const BuyFullKit(images: [
//       "assets/screens/Profile.png",
//       "assets/screens/Edit profile.png"
//     ]);
//   }
// }

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your actual user info UI
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example user info
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage("https://i.imgur.com/IXnwbLk.png"),
            ),
            const SizedBox(height: 16),
            const Text(
              "Gurman Dhaliwal",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "theflutterway@gmail.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            // Add more user info fields or edit profile button here
          ],
        ),
      ),
    );
  }
}
