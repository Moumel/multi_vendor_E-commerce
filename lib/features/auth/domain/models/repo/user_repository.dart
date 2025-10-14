import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_user.dart';


class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user data to Firestore
  Future<void> createUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  // Get user data
  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromJson(doc.data()!);
  }

  // Get role for routing
  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return doc['role'] as String?;
  }
}