import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luxery/features/auth/pressentation/components/landing_page.dart';
import 'package:luxery/themes/dark_mode.dart';
import 'package:luxery/themes/light_mode.dart';
import 'features/home/data/product_repo.dart';
import 'features/home/data/product_repo.dart';
import 'features/auth/data/firebase_auth_repo.dart';
import 'features/auth/pressentation/cubits/auth_cubit.dart';
import 'features/cart/cubit/cart_cubit.dart';
import 'features/product/cubit/product_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // 1. Initialize Repositories
  final firebaseAuthRepo = FirebaseAutoRepo();
  final productRepo = ProductRepo(); // <--- Initialize ProductRepo

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //  Auth
        BlocProvider<AuthCubit>(
          create: (context) =>
          AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        //  Cart
        BlocProvider<CartCubit>(
          create: (ctx) => CartCubit(),
        ),

        //  Product
        // 2. Updated BlocProvider to use the initialized ProductRepo
        BlocProvider<ProductCubit>(
          create: (_) => ProductCubit(productRepo)..loadProducts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        darkTheme: darkMode,
        home: const LandingPage(),
      ),
    );
  }
}
