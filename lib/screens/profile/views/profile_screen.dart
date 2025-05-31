import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/components/list_tile/divider_list_tile.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/screens/auth/views/components/user_provider.dart';
import 'package:shop/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Helper method to get user email
  String _getUserEmail(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user?.email != null &&
        userProvider.user!.email.isNotEmpty) {
      return userProvider.user!.email;
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;
    return firebaseUser?.email ?? 'user@example.com';
  }

  // Helper method to get user name
  String _getUserName(BuildContext context, UserProvider userProvider) {
    if (userProvider.user?.fullName != null &&
        userProvider.user!.fullName.isNotEmpty) {
      return userProvider.user!.fullName;
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser?.displayName != null &&
        firebaseUser!.displayName!.isNotEmpty) {
      return firebaseUser.displayName!;
    }

    if (firebaseUser?.email != null) {
      final emailName = firebaseUser!.email!.split('@')[0];
      return emailName[0].toUpperCase() + emailName.substring(1);
    }

    return 'User';
  }

  // Get user profile image (you can extend this to get from Firestore if you store profile pics)
  String _getUserProfileImage(UserProvider userProvider) {
    // If you store profile images in Firestore, you can get it from userProvider
    // For now, we'll use a default or the Firebase Auth photo URL
    final firebaseUser = FirebaseAuth.instance.currentUser;
    return firebaseUser?.photoURL ?? "https://i.imgur.com/IXnwbLk.png";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final userName = _getUserName(context, userProvider);
          final userEmail = _getUserEmail(context);
          final profileImage = _getUserProfileImage(userProvider);

          return ListView(
            children: [
              ProfileCard(
                name: userName,
                email: userEmail,
                //imageSrc: profileImage,
                imageSrc:
                    "https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/1f436.png", // Replace with your image URL
                // proLableText: "Sliver",
                // isPro: true, if the user is pro
                press: () {
                  Navigator.pushNamed(context, userInfoScreenRoute);
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //       horizontal: defaultPadding, vertical: defaultPadding * 1.5),
              //   child: GestureDetector(
              //     onTap: () {},
              //     child: const AspectRatio(
              //       aspectRatio: 1.8,
              //       child: NetworkImageWithLoader(
              //           "https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/1f436.png"),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  "Account (Coming Soon)",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              // const SizedBox(height: defaultPadding / 2),
              // ProfileMenuListTile(
              //   text: "Update Financial ",
              //   svgSrc: "assets/icons/Order.svg",
              //   press: () {
              //     Navigator.pushNamed(context, ordersScreenRoute);
              //   },
              // ),
              // ProfileMenuListTile(
              //   text: "Payment",
              //   svgSrc: "assets/icons/card.svg",
              //   press: () {
              //     Navigator.pushNamed(context, emptyPaymentScreenRoute);
              //   },
              // ),
              // const SizedBox(height: defaultPadding),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //       horizontal: defaultPadding, vertical: defaultPadding / 2),
              //   child: Text(
              //     "Personalization (Coming Soon)",
              //     style: Theme.of(context).textTheme.titleSmall,
              //   ),
              // ),
              // DividerListTileWithTrilingText(
              //   svgSrc: "assets/icons/Notification.svg",
              //   title: "Notification",
              //   trilingText: "Off",
              //   press: () {
              //     Navigator.pushNamed(context, enableNotificationScreenRoute);
              //   },
              // ),
              // ProfileMenuListTile(
              //   text: "Preferences",
              //   svgSrc: "assets/icons/Preferences.svg",
              //   press: () {
              //     Navigator.pushNamed(context, preferencesScreenRoute);
              //   },
              // ),
              // const SizedBox(height: defaultPadding),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //       horizontal: defaultPadding, vertical: defaultPadding / 2),
              //   child: Text(
              //     "Settings",
              //     style: Theme.of(context).textTheme.titleSmall,
              //   ),
              // ),
              // ProfileMenuListTile(
              //   text: "Language",
              //   svgSrc: "assets/icons/Language.svg",
              //   press: () {
              //     Navigator.pushNamed(context, selectLanguageScreenRoute);
              //   },
              // ),
              // ProfileMenuListTile(
              //   text: "Location",
              //   svgSrc: "assets/icons/Location.svg",
              //   press: () {},
              // ),
              // const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 2),
                child: Text(
                  "Help & Support",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ProfileMenuListTile(
                text: "Provide Feedback",
                svgSrc: "assets/icons/Help.svg",
                press: () {
                  Navigator.pushNamed(context, feedbackRoute);
                },
              ),
              ProfileMenuListTile(
                text: "FAQ",
                svgSrc: "assets/icons/FAQ.svg",
                press: () {
                  Navigator.pushNamed(context, FAQRoute);
                },
                isShowDivider: false,
              ),
              const SizedBox(height: defaultPadding),

              // Log Out
              ListTile(
                onTap: () {},
                minLeadingWidth: 24,
                leading: SvgPicture.asset(
                  "assets/icons/Logout.svg",
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    errorColor,
                    BlendMode.srcIn,
                  ),
                ),
                title: const Text(
                  "Log Out",
                  style: TextStyle(color: errorColor, fontSize: 14, height: 1),
                ),
              ),
            ], // ListView children
          ); // ListView
        }, // Consumer builder
      ), // Consumer
    ); // Scaffold
  }
}
