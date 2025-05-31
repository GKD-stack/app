import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class OnboardingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user data with better error handling and verbose logging
  Future<void> saveUserData(UserModel user) async {
    try {
      // Debug output - show exactly what we're saving and where
      print('📝 SAVING USER DATA:');
      print('- Email: ${user.email}');
      print('- Full data: ${user.toMap()}');

      // Create a safer document ID by replacing dots in email
      String docId = user.uid; 
      String collectionPath = 'users';
      String fullPath = '$collectionPath/$docId';
      print('- Saving to path: $fullPath');

      // Check if document already exists
      DocumentSnapshot existingDoc =
          await _firestore.collection(collectionPath).doc(docId).get();
      if (existingDoc.exists) {
        print('- Document already exists, will be updated');
      } else {
        print('- Document does not exist, will be created');
      }

      // Save the data to Firestore
      await _firestore.collection(collectionPath).doc(docId).set(
          user.toMap(),
          SetOptions(
              merge:
                  true) // Use merge: true to update fields rather than overwrite
          );

      // Verify data was actually saved by reading it back
      DocumentSnapshot verifyDoc =
          await _firestore.collection(collectionPath).doc(docId).get();
      if (verifyDoc.exists) {
        print('✅ VERIFICATION SUCCESSFUL: User data was saved');
        print('- Saved data: ${verifyDoc.data()}');
      } else {
        print(
            '❌ VERIFICATION FAILED: Data appears to be missing after save operation');
        throw Exception(
            'Data verification failed - document not found after save');
      }
    } catch (e) {
      print('❌ ERROR SAVING USER DATA: $e');
      if (e is FirebaseException) {
        print('- Firebase error code: ${e.code}');
        print('- Firebase error message: ${e.message}');

        // Handle specific Firebase error codes
        if (e.code == 'permission-denied') {
          print(
              '- This appears to be a permissions issue. Check your Firebase security rules.');
        } else if (e.code == 'unavailable') {
          print(
              '- This appears to be a connectivity issue. Check your internet connection.');
        }
      }
      // Rethrow to let calling code handle the error
      throw e;
    }
  }

  // Get user data with better error handling and verbose logging
  Future<UserModel?> getUserData({String? email}) async {
    try {
      // Determine which email to use
      String userEmail = email ??
          'default_user@example.com'; // Replace with actual default or user auth
      print('🔍 GETTING USER DATA:');
      print('- Email: $userEmail');

      // Create a safer document ID
      String docId = userEmail.replaceAll('.', '_');
      String collectionPath = 'users';
      String fullPath = '$collectionPath/$docId';
      print('- Looking up path: $fullPath');

      // Fetch the document
      DocumentSnapshot doc =
          await _firestore.collection(collectionPath).doc(docId).get();

      // Handle result
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('✅ USER FOUND: ${data.toString()}');
        return UserModel.fromMap(data);
      } else {
        print('ℹ️ NO USER FOUND for email: $userEmail');
        return null;
      }
    } catch (e) {
      print('❌ ERROR GETTING USER DATA: $e');
      if (e is FirebaseException) {
        print('- Firebase error code: ${e.code}');
        print('- Firebase error message: ${e.message}');
      }
      // Return null on error rather than throwing
      return null;
    }
  }

  // Add a method to list all users - helpful for debugging
  Future<void> listAllUsers() async {
    try {
      print('📋 LISTING ALL USERS:');

      QuerySnapshot snapshot = await _firestore.collection('users').get();

      if (snapshot.docs.isEmpty) {
        print('- No users found in the database');
      } else {
        print('- Found ${snapshot.docs.length} users:');
        for (var doc in snapshot.docs) {
          print('  • ${doc.id}: ${doc.data()}');
        }
      }
    } catch (e) {
      print('❌ ERROR LISTING USERS: $e');
    }
  }

  // Add a test write method to check permissions
  Future<bool> testWriteAccess() async {
    try {
      print('🧪 TESTING WRITE ACCESS:');

      // Try to write to a test document
      await _firestore
          .collection('app_tests')
          .doc('write_test')
          .set({'timestamp': FieldValue.serverTimestamp(), 'success': true});

      print('✅ WRITE TEST SUCCESSFUL');
      return true;
    } catch (e) {
      print('❌ WRITE TEST FAILED: $e');
      return false;
    }
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/user_model.dart';

// class OnboardingRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<UserModel?> getUserData() async {
//     final uid = _auth.currentUser?.uid;
//     if (uid == null) return null;

//     final doc = await _firestore.collection('users').doc(uid).get();
//     if (!doc.exists || doc.data() == null) return null;

//     return UserModel.fromMap(doc.data()!);
//   }

//   Future<void> saveUserData(UserModel user) async {
//     final uid = _auth.currentUser?.uid;
//     if (uid == null) return;

//     await _firestore
//         .collection('users')
//         .doc(uid)
//         .set(user.toMap(), SetOptions(merge: true));
//   }
// }
