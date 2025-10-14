import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Adjust these imports if your file locations differ:
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/cubit/cart_state.dart';
import '../../cart/pages/cart_page.dart';
import '../../home/presentation/pages/profile_page.dart';
import '../widgets/customer_home_body.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _currentIndex = 0; // 0 = Home, 1 = Cart, 2 = Profile

  Widget _pageForIndex(int index) {
    switch (index) {
      case 1:
        return const CartPage();
      case 2:
        return const ProfilePage();
      case 0:
      default:
        return const CustomerHomeBody();
    }
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bg,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: cs.primary),
                child: Center(
                  child: Text(
                    'L U X U R Y',
                    style: TextStyle(
                      color: cs.onPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  // If you're using AuthCubit, call logout from it:
                  // context.read<AuthCubit>().logout();
                  Navigator.of(context).pop(); // close drawer
                },
              ),
              // Add more drawer items here if needed
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: cs.secondary,
        elevation: 0,
        title: const Text(
          'L U X U R Y',
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // cart icon with live badge
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final total = state.totalItems;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      setState(() => _currentIndex = 1);
                    },
                  ),
                  if (total > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.secondary, width: 1),
                        ),
                        child: Text(
                          '$total',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // body switches between home, cart, profile
      body: _pageForIndex(_currentIndex),

      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onBottomNavTap,
            backgroundColor: cs.secondary,
            selectedItemColor: cs.primary,
            unselectedItemColor: cs.onSurface,
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (state.totalItems > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: Text(
                            '${state.totalItems}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          );
        },
      ),
    );
  }
}