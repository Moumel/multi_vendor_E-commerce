
// STATE MANAGEMENT

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/repo/auth_repo.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState>{
  final AuthRepo authRepo;

  AppUser? _currentUser;

  AuthCubit ({required this.authRepo}) : super (AuthInitial());

  //get current user
  AppUser? get currentUser => _currentUser;

  //check if user is auth..
  void checkAuth() async {

    emit(AuthLoading());
    final AppUser? user = await authRepo.getCurrentUser();

    if ( user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // login with email and password
  Future<void> login(String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, pw);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      }  else {
        emit(Unauthenticated());
      }
    }catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // register with email and password
  Future<void> register(String name, String email, String pw, String role) async {
    try {
      emit(AuthLoading());

      // Create Firebase Auth user
      final user = await authRepo.registerWithEmailPassword(name, email, pw, role);

      if (user != null) {
        _currentUser = user;

        // Save additional info in Firestore including role
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': name,
          'role': role,
        });

        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  //logout
  Future<void> logout() async {
    emit(AuthLoading());
    await authRepo.logout();
    emit(Unauthenticated());
  }

  //forgot password
  Future<String> forgotPassowrd(String email) async{
    try {
      final message = await authRepo.sendPasswordResetEmail(email);
      return message;
    }catch (e) {
      return e.toString();
    }
  }

  //delete account
  Future<void> deleteAccount() async {
    try{
      emit(AuthLoading());
      await authRepo.deleteAccount();
      emit(Unauthenticated());
    }catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

}