import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/screens/auth/splash_screen.dart';
import 'package:mobile/screens/profile/add_address.dart';
import 'package:mobile/screens/profile/address_book.dart';
import 'package:mobile/screens/profile/update_profile.dart';
import 'package:mobile/screens/shop/accounts.dart';
import 'package:mobile/screens/shop/cart.dart';
import 'package:mobile/screens/shop/shop_page.dart';
import 'package:mobile/screens/shop/main_tab.dart';
import 'package:mobile/screens/shop/search.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (_) => runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gadgets Shop',
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(),
      home: const SplashScreen(),
      routes: {
        'cart': (context) => const Cart(),
        'search': (context) => const SearchPage(),
        'accounts': (context) => const AccountsPage(),
        'shop': (context) => const ShopHomePage(),
        'profile': (context) => const UpdateProfile(),
        'address_book': (context) => const AddressBook(),
        'add_address': (context) => const AddAdressPage(),
        'main': (context) => const HomePage(),
      },
    );
  }
}
