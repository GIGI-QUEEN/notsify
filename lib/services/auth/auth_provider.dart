import 'package:notsify/services/auth/auth_user.dart';

abstract class AuthProvider {
  //return current user
  AuthUser? get currentUser;
  Future<AuthUser> logIn({required String email, required String password});
  Future<AuthUser> createuser(
      {required String email, required String password});
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
