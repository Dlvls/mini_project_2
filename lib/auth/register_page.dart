import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../resources/colors.dart';
import '../resources/styles.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo.png',
                      width: 100.0,
                      height: 100.0,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Create your",
                      textAlign: TextAlign.left,
                      style: Styles.appbarText.copyWith(fontSize: 24),
                    ),
                    Text(
                      "Account",
                      textAlign: TextAlign.left,
                      style: Styles.appbarText.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "Enter your details to create an account",
                      style: Styles.subtitle,
                    ),
                    const SizedBox(height: 32.0),
                    Text(
                      "Username",
                      style: Styles.subtitle,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        hintStyle: Styles.subtitle,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Border color when enabled
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Add border radius
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor, // Border color when focused
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Add border radius
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors
                                .red, // Border color when there's an error
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Add border radius
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Border color when disabled
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Add border radius
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      "Password",
                      style: Styles.subtitle,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: Styles.subtitle,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Border color when enabled
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Add border radius
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor, // Border color when focused
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Add border radius
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors
                                .red, // Border color when there's an error
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Add border radius
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Border color when disabled
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Add border radius
                        ),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: Styles.subtitle.copyWith(
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Perform registration action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: Styles.title.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
