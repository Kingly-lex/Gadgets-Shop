import 'package:flutter/material.dart';
import 'package:mobile/screens/auth/splash_screen.dart';
import 'package:mobile/services/store.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.logout,
  });

  final Function logout;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade300,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const DrawerHeader(
              child: Icon(
                Icons.shopify,
                size: 85,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListTile(
                onTap: () {},
                title: const Text(
                  'Home',
                  style: TextStyle(fontSize: 17),
                ),
                leading: const Icon(Icons.home),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListTile(
                onTap: () {},
                title: const Text(
                  'Profile',
                  style: TextStyle(fontSize: 17),
                ),
                leading: const Icon(Icons.verified_user_rounded),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListTile(
                onTap: () {},
                title: const Text(
                  'Wishlist',
                  style: TextStyle(fontSize: 17),
                ),
                leading: const Icon(Icons.favorite_outline),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: ListTile(
                onTap: () {
                  logout();
                  Store.clear();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ));
                },
                title: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 17),
                ),
                leading: const Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
