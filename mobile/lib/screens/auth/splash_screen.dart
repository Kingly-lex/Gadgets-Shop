import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/shop/main_tab.dart';
import 'package:mobile/screens/auth/user_auth.dart';
import 'package:mobile/services/store.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    receiveDataWhenStatusError: true,
  ),
);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserToken();
  }

  void _checkUserToken() async {
    final Map? tokens = await Store.getToken();

    if (tokens != null) {
      try {
        final Response response = await dio.post(
          '/api/token/refresh/',
          data: {
            "refresh": tokens['refresh'],
          },
        );

        if (response.statusCode == 200) {
          final Map tokens = {
            'refresh': response.data['refresh'],
            'access': response.data['access'],
          };

          await Store.setTokens(tokens);
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
          }
        } else {
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const StartScreen(),
            ));
          }
        }
      } on DioException catch (e) {
        e.message.toString();
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const StartScreen(),
          ));
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const StartScreen(),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(75.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.all(25),
                    clipBehavior: Clip.hardEdge,
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: CupertinoActivityIndicator(
                animating: true,
                color: Colors.green,
                radius: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
