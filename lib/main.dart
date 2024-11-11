import 'package:authentication_firebase/components/bottom_navigation_bar.dart';
import 'package:authentication_firebase/firebase_options.dart';
import 'package:authentication_firebase/main_screens/login_page.dart';
import 'package:authentication_firebase/provider/auth_provider.dart';
import 'package:authentication_firebase/provider/cart_provider.dart';
// import 'package:authentication_firebase/provider/firebase_api.dart';
import 'package:authentication_firebase/provider/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseApi().initNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: Provider.of<LoginProvider>(context, listen: false)
            .checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            return const CustomBottomNavigationBar();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
