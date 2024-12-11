// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// final firebaseAuthProvider =
//     Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
// final firestoreProvider =
//     Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// class AuthService {
//   final FirebaseAuth _auth;
//   final FirebaseFirestore _firestore;

//   AuthService(this._auth, this._firestore);

//   // Sign Up
//   Future<void> signUp({
//     required String firstName,
//     required String lastName,
//     required String email,
//     required String password,
//     required String phoneNumber,
//   }) async {
//     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     // Save basic user details to Firestore
//     await _firestore.collection('users').doc(userCredential.user!.uid).set({
//       'firstName': firstName,
//       'lastName': lastName,
//       'email': email,
//       'phoneNumber': phoneNumber,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

//   // Check if user is signed in
//   Future<bool> isUserSignedIn() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       // Optional: Verify expiration logic in Firestore
//       final sessionDoc =
//           await _firestore.collection('sessions').doc(user.uid).get();
//       if (sessionDoc.exists) {
//         final expirationDate = sessionDoc['expirationDate']?.toDate();
//         if (expirationDate != null && expirationDate.isAfter(DateTime.now())) {
//           return true;
//         }
//       } else {
//         // If session document doesn't exist, assume valid session
//         return true;
//       }
//     }
//     return false;
//   }

//   // Optional: Save session expiration date (30 days from now)
//   Future<void> saveSession(User user) async {
//     final expirationDate = DateTime.now().add(const Duration(days: 30));
//     await _firestore.collection('sessions').doc(user.uid).set({
//       'expirationDate': expirationDate,
//     }, SetOptions(merge: true));
//   }

// // signIn with username or email
//   Future<void> signInWithEmailOrUsername({
//     required String emailOrUsername,
//     required String password,
//   }) async {
//     String email = emailOrUsername;

//     // Check if input is a username, not an email
//     if (!emailOrUsername.contains('@')) {
//       // Query Firestore to get the email associated with the username
//       final querySnapshot = await _firestore
//           .collection('users')
//           .where('username', isEqualTo: emailOrUsername)
//           .get();

//       if (querySnapshot.docs.isEmpty) {
//         throw Exception('No user found with that username.');
//       }

//       email = querySnapshot.docs.first['email'];
//     }

//     // Use the resolved email to sign in
//     await _auth.signInWithEmailAndPassword(email: email, password: password);
//   }

//   // Google Sign-In
//   Future<void> signInWithGoogle() async {
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//     if (googleUser == null) return; // User canceled the login.

//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     UserCredential userCredential =
//         await _auth.signInWithCredential(credential);

//     if (userCredential.additionalUserInfo!.isNewUser) {
//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'firstName': googleUser.displayName?.split(' ')[0],
//         'lastName': googleUser.displayName?.split(' ')[1] ?? '',
//         'email': googleUser.email,
//         'phoneNumber': '',
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//     }
//   }

//   // Update Additional User Details (Step 2)
//   Future<void> completeUserProfile({
//     required String uid,
//     String? username,
//     String? title,
//     String? expertise,
//     String? accountType,
//   }) async {
//     await _firestore.collection('users').doc(uid).update({
//       if (username != null) 'username': username,
//       if (title != null) 'title': title,
//       if (expertise != null) 'expertise': expertise,
//       if (accountType != null) 'accountType': accountType,
//     });
//   }

//   // Real-Time Username Validation
//   Future<bool> isUsernameAvailable(String username) async {
//     final querySnapshot = await _firestore
//         .collection('users')
//         .where('username', isEqualTo: username)
//         .get();

//     return querySnapshot.docs.isEmpty;
//   }

//   Future<void> signInWithFacebook() async {
//     final LoginResult result = await FacebookAuth.instance.login();

//     if (result.status == LoginStatus.success) {
//       final AccessToken accessToken = result.accessToken!;

//       final OAuthCredential credential =
//           FacebookAuthProvider.credential(accessToken.tokenString);

//       UserCredential userCredential =
//           await _auth.signInWithCredential(credential);

//       if (userCredential.additionalUserInfo!.isNewUser) {
//         await _firestore.collection('users').doc(userCredential.user!.uid).set({
//           'firstName': userCredential.user!.displayName?.split(' ')[0] ?? '',
//           'lastName': userCredential.user!.displayName?.split(' ')[1] ?? '',
//           'email': userCredential.user!.email,
//           'phoneNumber': userCredential.user!.phoneNumber ?? '',
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//       }
//     } else if (result.status == LoginStatus.cancelled) {
//       throw Exception('Facebook sign-in was cancelled.');
//     } else {
//       throw Exception('Facebook sign-in failed: ${result.message}');
//     }
//   }
// }

// final keepMeSignedInProvider =
//     StateNotifierProvider<CheckboxStateNotifier, bool>(
//   (ref) => CheckboxStateNotifier(),
// );

// class CheckboxStateNotifier extends StateNotifier<bool> {
//   CheckboxStateNotifier() : super(false);

//   void toggle(bool value) {
//     state = value; // Update the state
//   }
// }

// final authServiceProvider = Provider((ref) {
//   final auth = ref.watch(firebaseAuthProvider);
//   final firestore = ref.watch(firestoreProvider);
//   return AuthService(auth, firestore);
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService(this._auth, this._firestore);

  // Sign Up
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save basic user details to Firestore
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Save session expiration date (30 days)
    await saveSession(userCredential.user!);
  }

  // Check if user is signed in and session is valid
  Future<bool> isUserSignedIn() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Verify session expiration logic in Firestore
      final sessionDoc =
          await _firestore.collection('sessions').doc(user.uid).get();
      if (sessionDoc.exists) {
        final expirationDate = sessionDoc['expirationDate']?.toDate();
        if (expirationDate != null && expirationDate.isAfter(DateTime.now())) {
          // Session is valid
          return true;
        } else {
          // Session expired, delete from Firestore
          await _firestore.collection('sessions').doc(user.uid).delete();
        }
      }
    }
    return false; // No active session
  }

  // Save session expiration date (30 days from now)
  Future<void> saveSession(User user) async {
    final expirationDate = DateTime.now().add(const Duration(days: 30));
    await _firestore.collection('sessions').doc(user.uid).set({
      'expirationDate': expirationDate,
    }, SetOptions(merge: true));
  }

  // Sign In with Email or Username
  Future<void> signInWithEmailOrUsername({
    required String emailOrUsername,
    required String password,
  }) async {
    String email = emailOrUsername;

    // Check if input is a username, not an email
    if (!emailOrUsername.contains('@')) {
      // Query Firestore to get the email associated with the username
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: emailOrUsername)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No user found with that username.');
      }

      email = querySnapshot.docs.first['email'];
    }

    // Sign in with the resolved email
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    // Save session after sign-in
    final user = _auth.currentUser;
    if (user != null) {
      await saveSession(user);
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return; // User canceled the login.

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    if (userCredential.additionalUserInfo!.isNewUser) {
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': googleUser.displayName?.split(' ')[0],
        'lastName': googleUser.displayName?.split(' ')[1] ?? '',
        'email': googleUser.email,
        'phoneNumber': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // Save session after sign-in
    await saveSession(userCredential.user!);
  }

  // Complete User Profile (Step 2)
  Future<void> completeUserProfile({
    required String uid,
    String? username,
    String? title,
    String? expertise,
    String? accountType,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      if (username != null) 'username': username,
      if (title != null) 'title': title,
      if (expertise != null) 'expertise': expertise,
      if (accountType != null) 'accountType': accountType,
    });
  }

  // Real-Time Username Validation
  Future<bool> isUsernameAvailable(String username) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  // Facebook Sign-In
  Future<void> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.tokenString);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'firstName': userCredential.user!.displayName?.split(' ')[0] ?? '',
          'lastName': userCredential.user!.displayName?.split(' ')[1] ?? '',
          'email': userCredential.user!.email,
          'phoneNumber': userCredential.user!.phoneNumber ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Save session after sign-in
      await saveSession(userCredential.user!);
    } else if (result.status == LoginStatus.cancelled) {
      throw Exception('Facebook sign-in was cancelled.');
    } else {
      throw Exception('Facebook sign-in failed: ${result.message}');
    }
  }
}

final keepMeSignedInProvider =
    StateNotifierProvider<CheckboxStateNotifier, bool>(
  (ref) => CheckboxStateNotifier(),
);

class CheckboxStateNotifier extends StateNotifier<bool> {
  CheckboxStateNotifier() : super(false);

  void toggle(bool value) {
    state = value; // Update the state
  }
}

final authServiceProvider = Provider((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  return AuthService(auth, firestore);
});
