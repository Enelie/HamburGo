import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:peliculas/pages/create_burger_page.dart';
import 'package:peliculas/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'pages/editor_page.dart';
import 'pages/checkout_page.dart';
import 'pages/kitchen_page.dart';
import 'pages/admin_page.dart';
import 'pages/delivery_page.dart';
import 'pages/manager_page.dart';
import 'pages/reviews_page.dart';
import 'pages/login_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nveruzhsgjalydimusbe.supabase.co',
    anonKey: 'sb_publishable_ZFFrRY4z1Pu630v81T-rFg_uhOs0s8B',
  );
    runApp(const HamburGoApp());
}

class HamburGoApp extends StatelessWidget {
  const HamburGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AppProvider()..init()),
    ChangeNotifierProvider(create: (_) => SupabaseProvider()),
  ],
  child: MaterialApp(
    title: 'HamburGo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    initialRoute: '/',
    routes: {
      '/': (_) => const LoginPage(),
      '/home': (_) => const EditorPage(),
      '/editor': (_) => const EditorPage(),
      '/createBurger': (context) => const CreateBurgerPage(),
      '/checkout': (_) => const CheckoutPage(),
      '/kitchen': (_) => const KitchenPage(),
      '/admin': (_) => const AdminPage(),
      '/delivery': (_) => const DeliveryPage(),
      '/manager': (_) => const ManagerPage(),
      '/reviews': (_) => const ReviewsPage(),
    },
  ),
)
    ;
  }
} 