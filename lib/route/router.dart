import 'package:flutter/material.dart';
import 'package:shop/entry_point.dart';
import 'package:shop/screens/faq/faq_screen.dart';
import 'package:shop/screens/feedback/feedback_screen.dart';

import 'screen_export.dart';
import '../screens/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Yuo will get 50+ screens and more once you have the full template
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

// NotificationPermissionScreen()
// PreferredLanguageScreen()
// SelectLanguageScreen()
// SignUpVerificationScreen()
// ProfileSetupScreen()
// VerificationMethodScreen()
// OtpScreen()
// SetNewPasswordScreen()
// DoneResetPasswordScreen()
// TermsOfServicesScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFaceIdScreen()
// OnSaleScreen()
// BannerLStyle2()
// BannerLStyle3()
// BannerLStyle4()
// SearchScreen()
// SearchHistoryScreen()
// NotificationsScreen()
// EnableNotificationScreen()
// NoNotificationScreen()
// NotificationOptionsScreen()
// ProductInfoScreen()
// ShippingMethodsScreen()
// ProductReviewsScreen()
// SizeGuideScreen()
// BrandScreen()
// CartScreen()
// EmptyCartScreen()
// PaymentMethodScreen()
// ThanksForOrderScreen()
// CurrentPasswordScreen()
// EditUserInfoScreen()
// OrdersScreen()
// OrderProcessingScreen()
// OrderDetailsScreen()
// CancleOrderScreen()
// DelivereOrdersdScreen()
// AddressesScreen()
// NoAddressScreen()
// AddNewAddressScreen()
// ServerErrorScreen()
// NoInternetScreen()
// ChatScreen()
// DiscoverWithImageScreen()
// SubDiscoverScreen()
// AddNewCardScreen()
// EmptyPaymentScreen()
// GetHelpScreen()

// ℹ️ All the comments screen are included in the full template
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onbordingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case signUpScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case financialDetailsRoute:
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If not logged in, redirect to login screen
        return MaterialPageRoute(
          builder: (context) =>
              const LoginScreen(), // Replace with your login screen
        );
      }
      // You might want to add guards here to ensure only logged-in users can access
      return MaterialPageRoute(
        builder: (context) => FinancialDetailsScreen(user: user),
      );
    case feedbackRoute:
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If not logged in, redirect to login screen
        return MaterialPageRoute(
          builder: (context) =>
              const LoginScreen(), // Replace with your login screen
        );
      }
      // You might want to add guards here to ensure only logged-in users can access
      return MaterialPageRoute(
        builder: (context) => FeedbackScreen(user: user),
      );
    case FAQRoute:
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If not logged in, redirect to login screen
        return MaterialPageRoute(
          builder: (context) =>
              const LoginScreen(), // Replace with your login screen
        );
      }
      // You might want to add guards here to ensure only logged-in users can access
      return MaterialPageRoute(
        builder: (context) => FAQScreen(user: user),
      );
    case passwordRecoveryScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PasswordRecoveryScreen(),
      );
    case '/':
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    // case verificationMethodScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const VerificationMethodScreen(),
    //   );
    // case otpScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OtpScreen(),
    //   );
    // case newPasswordScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SetNewPasswordScreen(),
    //   );
    // case doneResetPasswordScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DoneResetPasswordScreen(),
    //   );
    // case termsOfServicesScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const TermsOfServicesScreen(),
    //   );
    // case noInternetScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NoInternetScreen(),
    //   );
    // case serverErrorScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ServerErrorScreen(),
    //   );
    // case signUpVerificationScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SignUpVerificationScreen(),
    //   );
    // case setupFingerprintScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SetupFingerprintScreen(),
    //   );
    // case setupFaceIdScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SetupFaceIdScreen(),
    //   );
    // case productDetailsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) {
    //       bool isProductAvailable = settings.arguments as bool? ?? true;
    //       return ProductDetailsScreen(isProductAvailable: isProductAvailable);
    //     },
    //   );
    // case productReviewsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ProductReviewsScreen(),
    //   );
    // case addReviewsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddReviewScreen(),
    //   );
    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
    // case brandScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const BrandScreen(),
    //   );
    // case discoverWithImageScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DiscoverWithImageScreen(),
    //   );
    // case subDiscoverScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SubDiscoverScreen(),
    //   );
    case discoverScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const DiscoverScreen(),
      );
    // case onSaleScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OnSaleScreen(),
    //   );
    // case kidsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const KidsScreen(),
    //   );
    case searchScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );
    // case searchHistoryScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SearchHistoryScreen(),
    //   );
    case bookmarkScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const BookmarkScreen(),
      );
    case entryPointScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      );
    case profileScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      );

    // case chatScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ChatScreen(),
    //   );
    case userInfoScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    // case currentPasswordScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CurrentPasswordScreen(),
    //   );
    // case editUserInfoScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EditUserInfoScreen(),
    //   );
    // case notificationsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NotificationsScreen(),
    //   );
    // case noNotificationScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NoNotificationScreen(),
    //   );
    // case enableNotificationScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EnableNotificationScreen(),
    //   );
    // case notificationOptionsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NotificationOptionsScreen(),
    //   );
    // case selectLanguageScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SelectLanguageScreen(),
    //   );
    // case noAddressScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NoAddressScreen(),
    //   );
    case addressesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const AddressesScreen(),
      );
    // case addNewAddressesScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddNewAddressScreen(),
    //   );
    case ordersScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OrdersScreen(),
      );
    // case orderProcessingScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrderProcessingScreen(),
    //   );
    // case orderDetailsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrderDetailsScreen(),
    //   );
    // case cancleOrderScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CancleOrderScreen(),
    //   );
    // case deliveredOrdersScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DelivereOrdersdScreen(),
    //   );
    // case cancledOrdersScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CancledOrdersScreen(),
    //   );
    case preferencesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PreferencesScreen(),
      );
    // case emptyPaymentScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EmptyPaymentScreen(),
    //   );
    // case emptyWalletScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EmptyWalletScreen(),
    //   );
    // case walletScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const WalletScreen(),
    //   );
    // case cartScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CartScreen(),
    //   );
    // case paymentMethodScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const PaymentMethodScreen(),
    //   );
    // case addNewCardScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddNewCardScreen(),
    //   );
    // case thanksForOrderScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ThanksForOrderScreen(),
    //   );
    default:
      return MaterialPageRoute(
        // Make a screen for undefine
        builder: (context) => const OnBordingScreen(),
      );
  }
}
