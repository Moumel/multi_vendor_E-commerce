
// Auth repoisitory - Outines the possible auth operation for the app


import '../app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(String name, String email, String password, String role);
  Future <void> logout();
  Future<AppUser?> getCurrentUser();
  Future<String> sendPasswordResetEmail ( String email);
  Future<void> deleteAccount();
}