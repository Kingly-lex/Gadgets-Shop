import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mobile/components/widgets/logo_container.dart';
import 'package:mobile/extensions.dart';
import 'package:mobile/screens/shop/main_tab.dart';
import 'package:mobile/services/store.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    // receiveDataWhenStatusError: true,
  ),
);

class LoginModal extends StatefulWidget {
  const LoginModal({super.key, required this.changeScreen});

  final Function changeScreen;

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
// // init state
//   @override
//   void initState() {
//     super.initState();
//     _getSavedEmail();
//   }

  final _loginFormKey = GlobalKey<FormState>();

  bool isLoginPage = true;
  bool passwordState = true;

  bool isChecked = true;
  late String loginEmail;
  late String loginPassword;
  String savedEmail = '';

  bool isLoading = false;

  // save email if checked
  void saveEmail() async {
    if (isChecked) {
      await Store.setEmail(loginEmail);
    }
  }

  // submit func
  void submitLogin() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      saveEmail();
      final Map data = {"email": loginEmail, "password": loginPassword};

      setState(() {
        isLoading = true;
      });

      try {
        final Response response = await dio.post(
          '/api/auth/login/',
          data: data,
        );

        if (response.statusCode == 200) {
          final Map tokens = {
            'refresh': response.data['refresh'],
            'access': response.data['access'],
          };

          await Store.setTokens(tokens);

          if (mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
        }
      } on DioException catch (e) {
        setState(() {
          isLoading = false;
        });
        String msg = "An Error occured, Please try again";

        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.connectionError) {
          msg = "Please check your internet connection";
        }

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              showCloseIcon: true,
              content: Text(
                msg,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
    }
  }

  // build context
  @override
  Widget build(BuildContext context) {
    // get saved email
    void _getSavedEmail() async {
      print(savedEmail);
      final value = await Store.getEmail();
      if (value != null) {
        savedEmail = value;
      }
      print(savedEmail);
    }

    final deviceWidth = MediaQuery.of(context).size.width;
    print(savedEmail);

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: double.infinity,
            child: SizedBox(
              width: deviceWidth < 500
                  ? constraints.maxWidth * 0.91
                  : constraints.maxWidth * 0.75,
              child: child(),
            ),
          );
        },
      ),
    );
  }

  // widget child
  Widget child() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Text(
            'Welcome back, We\'ve missed you',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 30),
          Form(
            key: _loginFormKey,
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.grey[900]),
                  validator: (value) {
                    if (value != null &&
                        value.trim().isNotEmpty &&
                        value.isValidEmail()) {
                      return null;
                    }
                    return "Invalid email adress";
                  },
                  onSaved: (value) {
                    loginEmail = value!;
                  },
                  initialValue: savedEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue.shade100),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1.5,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Email Addresss",
                      hintStyle: TextStyle(
                          color: Colors.grey.shade500, letterSpacing: 0.4),
                      filled: true,
                      fillColor: Colors.white),
                ),
                const SizedBox(height: 15),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.grey[900]),
                      validator: (value) {
                        if (value != null &&
                            value.trim().isNotEmpty &&
                            value.length > 6 &&
                            value.length <= 50) {
                          return null;
                        }
                        return "Password must be between 6 and 50 characters";
                      },
                      onSaved: (value) {
                        loginPassword = value!;
                      },
                      obscureText: passwordState,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue.shade100),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.5,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500, letterSpacing: 0.4),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordState = !passwordState;
                          });
                        },
                        icon: Icon(
                          passwordState
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox.adaptive(
                              checkColor: Colors.white,
                              activeColor: Colors.black,
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                            ),
                            const Text(
                              'Remember email',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.grey.shade200),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                !isLoading
                    ? ElevatedButton(
                        onPressed: submitLogin,
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          foregroundColor: Colors.blue.shade100,
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.all(22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator.adaptive(),
              ],
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Divider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Text('Or login with'),
              ),
              Expanded(
                child: Divider(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoContainer(imagepath: "assets/images/google.png"),
              SizedBox(
                width: 20,
              ),
              LogoContainer(imagepath: "assets/images/apple.png")
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Not a member?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.changeScreen(false);
                },
                child: const Text(
                  "Register NoW",
                  style: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
