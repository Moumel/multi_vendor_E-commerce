// lib/features/home/presentation/pages/landing_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../customer/pages/customer_home_page.dart';
import '../../../vendor/presentation/pages/vendor_dashboard_page.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_states.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import 'loading.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _showLoginPage = true;

  void _togglePages() => setState(() => _showLoginPage = !_showLoginPage);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        // Waiting for auth check
        if (state is AuthLoading) return const LoadingScreen();

        // Logged in -> try to get role (prefer value from state if present)
        if (state is Authenticated) {
          final user = state.user;

          // If role already present on AppUser, use it
          if (user.role != null && user.role.isNotEmpty) {
            return user.role == 'vendor'
                ? const VendorDashboardPage()
                : const CustomerHomePage();
          }

          // Otherwise fallback to reading Firestore
          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingScreen();
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                // No doc — treat as customer or send to a profile-complete page.
                return const CustomerHomePage();
              }

              final data = snapshot.data!.data();
              final role = (data != null && data['role'] != null)
                  ? data['role'] as String
                  : 'customer';

              return role == 'vendor'
                  ? const VendorDashboardPage()
                  : const CustomerHomePage();
            },
          );
        }

        // Not authenticated -> show login/register with toggle
        return _showLoginPage
            ? LoginPage(togglePages: _togglePages)
            : RegisterPage(togglePages: _togglePages);
      },
    );
  }
}