import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/login.dart';
import 'package:mobile/components/register.dart';

const String policy =
    "By using this app, you agree to comply with and be bound by our terms and conditions. These terms may be updated from time to time, and it is your responsibility to review them periodically.";

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  //
  void onLoginButton() {
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      backgroundColor: Colors.grey.shade300,
      // barrierColor: Colors.grey,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => LoginModal(
        changeScreen: changeScreen,
      ),
    );
  }

  void onRegisterButton() {
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade300,
      useSafeArea: true,
      context: context,
      builder: (ctx) => RegisterModal(
        changeScreen: changeScreen,
      ),
    );
  }

  void changeScreen(bool isLogin) {
    if (!isLogin) {
      onRegisterButton();
    }
    if (isLogin) {
      onLoginButton();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: BounceInDown(
              child: SizedBox(
                width:
                    deviceWidth < 500 ? deviceWidth * 0.91 : deviceWidth * 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ZoomIn(
                      child: const Text(
                        'Gadgets Shop',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Lato"),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'One stop for new and used electronics in Nigeria',
                      style: TextStyle(fontSize: 14, fontFamily: "Lato"),
                    ),
                    const SizedBox(height: 12),
                    BounceInDown(
                      delay: const Duration(milliseconds: 900),
                      child: Icon(
                        Icons.shopify,
                        size: 120,
                        color: Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeIn(
                      delay: const Duration(milliseconds: 2000),
                      child: MaterialButton(
                        color: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: onLoginButton,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeIn(
                      delay: const Duration(milliseconds: 2200),
                      child: MaterialButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: onRegisterButton,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeIn(
                      delay: const Duration(milliseconds: 3000),
                      child: Text(
                        policy,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
