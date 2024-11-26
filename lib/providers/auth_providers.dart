import 'package:flutter_riverpod/flutter_riverpod.dart';

// UserSignUp model
class UserSignUp {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final String username;
  final String title;
  final String expertise;
  final String accountType;

  UserSignUp({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phoneNumber = '',
    this.password = '',
    this.username = '',
    this.title = '',
    this.expertise = '',
    this.accountType = '',
  });

  UserSignUp copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? username,
    String? title,
    String? expertise,
    String? accountType,
  }) {
    return UserSignUp(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      username: username ?? this.username,
      title: title ?? this.title,
      expertise: expertise ?? this.expertise,
      accountType: accountType ?? this.accountType,
    );
  }
}

// StateNotifier to manage user signup data
class UserSignUpNotifier extends StateNotifier<UserSignUp> {
  UserSignUpNotifier() : super(UserSignUp());

  void updateBasicDetails({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) {
    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  void updateProfileDetails({
    required String username,
    required String title,
    required String expertise,
    required String accountType,
  }) {
    state = state.copyWith(
      username: username,
      title: title,
      expertise: expertise,
      accountType: accountType,
    );
  }

  void clear() {
    state = UserSignUp();
  }
}

// Define a Riverpod provider
final userSignUpProvider =
    StateNotifierProvider<UserSignUpNotifier, UserSignUp>((ref) {
  return UserSignUpNotifier();
});
