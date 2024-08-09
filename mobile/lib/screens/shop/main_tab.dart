import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mobile/screens/shop/accounts.dart';
import 'package:mobile/screens/shop/shop_page.dart';
import 'package:mobile/screens/auth/splash_screen.dart';

mixin AppCloser {
  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AppCloser {
  int activeIndex = 0;
  DateTime? lastBackPressed;

  void logout() async {
    try {
      await dio.post(
        '/api/auth/logout/',
        data: {"token": ''},
      );
    } on DioException catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const ShopHomePage(),
      const AccountsPage(),
    ];
    // final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            DateTime currentTime = DateTime.now();
            if (!didPop) {
              if (activeIndex == 0) {
                if (lastBackPressed == null ||
                    currentTime.difference(lastBackPressed!) >
                        const Duration(seconds: 1)) {
                  lastBackPressed = currentTime;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      showCloseIcon: true,
                      duration: Duration(milliseconds: 800),
                      content: Center(
                        child: Text('Press back agin to exit'),
                      ),
                    ),
                  );
                } else {
                  closeApp();
                }
              } else {
                setState(() {
                  activeIndex = 0;
                });
              }
            }
          },
          child: IndexedStack(
            index: activeIndex,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GNav(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          selectedIndex: activeIndex,
          onTabChange: (index) {
            setState(() {
              activeIndex = index;
            });
          },
          gap: 10,
          tabActiveBorder: Border.all(color: Colors.grey),
          tabBackgroundColor: Colors.grey.shade900,
          activeColor: Colors.white,
          color: Colors.grey,
          tabBorderRadius: 19,
          mainAxisAlignment: MainAxisAlignment.center,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.menu,
              text: 'Account Menu',
            ),
          ],
        ),
      ),
    );
  }
}
