// import 'package:flutter/material.dart';
// import 'package:shop/components/Banner/S/banner_s_style_1.dart';
// import 'package:shop/components/Banner/S/banner_s_style_5.dart';
// import 'package:shop/constants.dart';
// import 'package:shop/route/screen_export.dart';

// import 'components/best_sellers.dart';
// import 'components/flash_sale.dart';
// import 'components/most_popular.dart';
// import 'components/offer_carousel_and_categories.dart';
// import 'components/popular_products.dart';

//import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/auth/views/components/user_provider.dart';
import 'components/offer_carousel_and_categories.dart';

import 'package:flutter/material.dart';
import 'package:shop/components/Banner/S/banner_s_style_1.dart';
//import 'package:shop/components/Banner/S/banner_s_style_5.dart';
import 'package:shop/constants.dart';
import 'components/current_events.dart'; // New component for financial news articles

import 'package:shop/screens/home/views/components/learning_progress.dart'
    as lp;
import 'package:shop/screens/home/views/components/popular_lessons.dart' as pl;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//const double defaultPadding = 16.0;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  // Helper method to get user name
  String _getUserDisplayName(BuildContext context) {
    // Try to get from Provider first
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user?.fullName != null &&
        userProvider.user!.fullName.isNotEmpty) {
      return userProvider.user!.fullName;
    }

    // Fallback to Firebase Auth display name
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser?.displayName != null &&
        firebaseUser!.displayName!.isNotEmpty) {
      return firebaseUser.displayName!;
    }

    // Extract name from email if available
    if (firebaseUser?.email != null) {
      final emailName = firebaseUser!.email!.split('@')[0];
      // Capitalize first letter
      return emailName[0].toUpperCase() + emailName.substring(1);
    }

    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            //const SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    // Get user name with fallbacks
                    String userName = 'User';

                    if (userProvider.user?.fullName != null &&
                        userProvider.user!.fullName.isNotEmpty) {
                      userName = userProvider.user!.fullName;
                    } else {
                      final firebaseUser = FirebaseAuth.instance.currentUser;
                      if (firebaseUser?.displayName != null) {
                        userName = firebaseUser!.displayName!;
                      } else if (firebaseUser?.email != null) {
                        userName = firebaseUser!.email!.split('@')[0];
                        userName =
                            userName[0].toUpperCase() + userName.substring(1);
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back, $userName!',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your Home For All Things Money',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF7B61FF),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Learning Progress Bars for different lesson categories
            const SliverToBoxAdapter(child: lp.LearningProgress()),

            // Popular Lessons instead of Popular Products
            //const SliverToBoxAdapter(child: pl.LearningProgress()),

            // Current Events Section - Financial News
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
              sliver: SliverToBoxAdapter(child: CurrentEvents()),
            ),

            // Featured Article 1
            SliverToBoxAdapter(
              child: Container(
                color: Colors.green[50], // Light green background
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 8.0), // Optional: some padding
                child: Column(
                  children: [
                    // const BannerMSkelton(), // Uncomment if you want to show a skeleton while loading
                    BannerSStyle1(
                      title:
                          "Market Basics: Understanding Bull vs Bear Markets",
                      discountParcent: 50,
                      //press: () {}, // Disabled: does nothing on tap
                    ),
                    const SizedBox(height: defaultPadding / 4),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding * 1.5),
                  const SizedBox(height: defaultPadding / 4),
                  // While loading use 👇
                  // const BannerSSkelton(),
                  // BannerSStyle5(
                  //   title: "Inflation Explained: How It Affects Your Savings",
                  //   press: () {
                  //     Navigator.pushNamed(context, 'lessonDetailScreenRoute');
                  //   },
                  // ),
                  const SizedBox(height: defaultPadding / 4),
                ],
              ),
            ),

            // More Financial News/Articles
            const SliverToBoxAdapter(child: MoreArticles()),
          ],
        ),
      ),
    );
  }
}
