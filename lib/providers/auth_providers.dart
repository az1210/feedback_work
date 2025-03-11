import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/core/utils/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:feedback_work/core/constants/firebase_constants.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';

final authServiceProvider =
    NotifierProvider<AuthNotifier, AuthNotifierState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthNotifierState> {
  @override
  AuthNotifierState build() {
    return AuthNotifierState(state: AsyncState.initial);
  }

  // Sign up
  Future<void> signUp({
    required UserModel userModel,
    required String password,
    void Function()? callBack,
  }) async {
    state = state.copyWith(state: AsyncState.loading);
    FirebaseAuth auth = ref.read(firebaseAuthProvider);
    // FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password,
      );

      // Save basic user details to Firestore
      // final docRef = await firestore
      //     .collection(FirebaseConstants.userCollection)
      //     .doc(userCredential.user!.uid)
      //     .set(userModel.copyWith(id: userCredential.user!.uid).toMap());

      // Save session expiration date (30 days)
      await saveSession(userCredential.user!);
      callBack?.call();
      state = state.copyWith(state: AsyncState.success);
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  // Check if user is signed in and session is valid
  Future<bool> isUserSignedIn() async {
    FirebaseAuth auth = ref.read(firebaseAuthProvider);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    final user = auth.currentUser;
    try {
      if (user != null) {
        // Verify session expiration logic in Firestore
        final sessionDoc = await firestore
            .collection(FirebaseConstants.sessionCollection)
            .doc(user.uid)
            .get();
        if (sessionDoc.exists) {
          final expirationDate = sessionDoc['expirationDate']?.toDate();
          if (expirationDate != null &&
              expirationDate.isAfter(DateTime.now())) {
            // Session is valid
            return true;
          } else {
            // Session expired, delete from Firestore
            await firestore
                .collection(FirebaseConstants.sessionCollection)
                .doc(user.uid)
                .delete();
          }
        }
      }
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }

    return false; // No active session
  }

  // Save session expiration date (30 days from now)
  Future<void> saveSession(User user) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    final expirationDate = DateTime.now().add(const Duration(days: 30));
    try {
      await firestore
          .collection(FirebaseConstants.sessionCollection)
          .doc(user.uid)
          .set({
        'expirationDate': expirationDate,
      }, SetOptions(merge: true));
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  // Sign In with Email or Username
  Future<void> signInWithEmailOrUsername({
    required String emailOrUsername,
    required String password,
    void Function()? callback,
  }) async {
    FirebaseAuth auth = ref.read(firebaseAuthProvider);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    String email = emailOrUsername;

    try {
      // Check if input is a username, not an email
      if (!emailOrUsername.contains('@')) {
        // Query Firestore to get the email associated with the username
        final querySnapshot = await firestore
            .collection(FirebaseConstants.userCollection)
            .where('username', isEqualTo: emailOrUsername)
            .get();

        if (querySnapshot.docs.isEmpty) {
          throw Exception('No user found with that username.');
        }

        email = querySnapshot.docs.first['email'];
      }

      // Sign in with the resolved email
      await auth.signInWithEmailAndPassword(email: email, password: password);
      // Save session after sign-in
      final user = auth.currentUser;
      if (user != null) {
        Log.info(user.uid);
        await saveSession(user);
        ref.read(authProvider.notifier).state = true;
        callback?.call();
      } else {
        return;
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      if (e.code == 'user-not-found') {
        showToast(message: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showToast(message: 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        showToast(message: "Wrong email provided for that user.");
      } else if (e.code == 'invalid-credential') {
        showToast(message: "Invalid Credential provided for that user.");
      }
      Log.error(e.code);
      Log.error(stackTrace.toString());
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle({void Function()? callBack}) async {
    FirebaseAuth auth = ref.read(firebaseAuthProvider);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    GoogleSignIn googleSignIn = ref.read(googleSignInProvider);
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // User canceled the login.

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserModel userModel = UserModel(
        firstName: googleUser.displayName?.split(' ')[0] ?? '',
        lastName: googleUser.displayName?.split(' ')[1] ?? '',
        email: googleUser.email,
        phoneNumber: "",
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        await firestore
            .collection(FirebaseConstants.userCollection)
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
      }

      // Save session after sign-in
      await saveSession(userCredential.user!);
      ref.read(authProvider.notifier).state = true;
      callBack?.call();
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  // Complete User Profile (Step 2)
  Future<void> completeUserProfile({
    required String uid,
    required UserModel userModel,
  }) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      await firestore
          .collection(FirebaseConstants.userCollection)
          .doc(uid)
          .update(
        {
          "username": userModel.username,
          "title": userModel.title,
          "expertise": userModel.expertise,
          "accountType": userModel.accountType,
          "minimumRate": userModel.minimumRate,
        },
      );
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  // Real-Time Username Validation
  Future<bool> isUsernameAvailable(String username) async {
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    try {
      final querySnapshot = await firestore
          .collection(FirebaseConstants.userCollection)
          .where('username', isEqualTo: username)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
    return false;
  }

  // Facebook Sign-In
  Future<void> signInWithFacebook() async {
    FirebaseAuth auth = ref.read(firebaseAuthProvider);
    FirebaseFirestore firestore = ref.read(firestoreProvider);
    FacebookAuth facebookAuth = ref.read(facebookSignInProvider);
    try {
      final LoginResult result = await facebookAuth.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        UserCredential userCredential =
            await auth.signInWithCredential(credential);

        UserModel userModel = UserModel(
          firstName: userCredential.user!.displayName?.split(' ')[0] ?? '',
          lastName: userCredential.user!.displayName?.split(' ')[1] ?? '',
          email: userCredential.user!.email ?? "",
          phoneNumber: userCredential.user!.phoneNumber ?? '',
        );

        if (userCredential.additionalUserInfo!.isNewUser) {
          await firestore
              .collection(FirebaseConstants.userCollection)
              .doc(userCredential.user!.uid)
              .set(userModel.toMap());
        }

        // Save session after sign-in
        await saveSession(userCredential.user!);
        ref.read(authProvider.notifier).state = true;
      } else if (result.status == LoginStatus.cancelled) {
        throw Exception('Facebook sign-in was cancelled.');
      } else {
        throw Exception('Facebook sign-in failed: ${result.message}');
      }
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }

  Future<void> logout() async {
    FirebaseAuth auth = ref.read(firebaseAuthProvider);
    FacebookAuth facebookAuth = ref.read(facebookSignInProvider);
    GoogleSignIn googleSignIn = ref.read(googleSignInProvider);
    try {
      await auth.signOut();
      await googleSignIn.signOut();
      await facebookAuth.logOut();
      ref.read(authProvider.notifier).state = false;
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());
    }
  }
}

class AuthNotifierState {
  final String? error;
  final AsyncState state;

  AuthNotifierState({
    this.error,
    required this.state,
  });

  AuthNotifierState copyWith({
    String? error,
    AsyncState? state,
  }) {
    return AuthNotifierState(
      error: error ?? this.error,
      state: state ?? this.state,
    );
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

Future<bool> isLoggedIn(Ref ref) async {
  return ref.watch(authProvider);
}
