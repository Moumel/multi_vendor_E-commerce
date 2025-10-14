import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models/app_user.dart';
import '../domain/models/repo/auth_repo.dart';

class FirebaseAutoRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // fetch role from Firestore
      final doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      final role = doc.exists ? doc['role'] as String? ?? '' : '';

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        role: role,
      );
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(String name, String email, String password, String role) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        role: role,
      );

      // save to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': name,
        'role': role,
      });

      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) throw Exception('No user logged in..');
      await user.delete();
      await logout();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    final role = doc.exists ? doc['role'] as String? ?? '' : '';

    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!, role: role);
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return "Password reset email sent! Check your inbox";
    } catch (e) {
      return "An error occurred: $e";
    }
  }
}