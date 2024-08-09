import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/widgets/logo_container.dart';
import 'package:mobile/extensions.dart';

class RegisterModal extends StatefulWidget {
  const RegisterModal({super.key, required this.changeScreen});

  final Function changeScreen;

  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  final _registerFormKey = GlobalKey<FormState>();
  bool registerPasswordState = true;

  late String registeremail;
  late String registerPassword;
  late String registerFirstname;
  late String registerLastname;
  late String passwordConfirm;

  void submitRegister() async {
    if (_registerFormKey.currentState!.validate()) {
      _registerFormKey.currentState!.save();

      final Map data = {
        "email": registeremail,
        "first_name": registerFirstname,
        "last_name": registerLastname,
        "password": registerPassword,
        "confirm_password": passwordConfirm,
      };

      try {
        final Response response = await _dio.post(
          '/api/auth/register/',
          data: data,
        );

        if (response.statusCode == 201 && mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.data['response'],
              ),
            ),
          );
        }
      } on DioException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.message.toString(),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: double.infinity,
            child: SizedBox(
              width: deviceWidth < 500
                  ? constraints.maxWidth * 0.75
                  : constraints.maxWidth * 0.91,
              child: child(),
            ),
          );
        },
      ),
    );
  }

  Widget child() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Let's create an account for you",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 30),
          Form(
            key: _registerFormKey,
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
                    registeremail = value!;
                  },
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
                      fillColor: Colors.grey.shade200),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey[900]),
                        validator: (value) {
                          if (value != null &&
                              value.trim().isNotEmpty &&
                              value.length > 1 &&
                              value.length <= 50) {
                            return null;
                          }
                          return "Invalid first name";
                        },
                        onSaved: (value) {
                          registerFirstname = value!;
                        },
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade100),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1.5,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "First Name",
                            hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                letterSpacing: 0.4),
                            filled: true,
                            fillColor: Colors.grey.shade200),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey[900]),
                        validator: (value) {
                          if (value != null &&
                              value.trim().isNotEmpty &&
                              value.length > 1 &&
                              value.length <= 50) {
                            return null;
                          }
                          return "Invalid last name";
                        },
                        onSaved: (value) {
                          registerLastname = value!;
                        },
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade100),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1.5,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Last Name",
                            hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                letterSpacing: 0.4),
                            filled: true,
                            fillColor: Colors.grey.shade200),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
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
                    registerPassword = value!;
                  },
                  onChanged: (value) {
                    registerPassword = value;
                  },
                  obscureText: registerPasswordState,
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
                      fillColor: Colors.grey.shade200),
                ),
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.grey[900]),
                      validator: (value) {
                        if (value != null &&
                            value.trim().isNotEmpty &&
                            value == registerPassword) {
                          return null;
                        }
                        return "Passwords do not match";
                      },
                      onSaved: (value) {
                        passwordConfirm = value!;
                      },
                      obscureText: registerPasswordState,
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
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500, letterSpacing: 0.4),
                          filled: true,
                          fillColor: Colors.grey.shade200),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            registerPasswordState = !registerPasswordState;
                          });
                        },
                        icon: Icon(registerPasswordState
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: submitRegister,
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
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Divider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Text('Or register with'),
              ),
              Expanded(
                child: Divider(),
              ),
            ],
          ),
          const SizedBox(height: 5),
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
              const Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.changeScreen(true);
                },
                child: const Text(
                  "Sign in",
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
