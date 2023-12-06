import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Services/validator.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar('Password Reset Email Sent', 'Please check your email to reset your password',
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      print('Error sending reset email: $e');
      Get.snackbar('Password Reset Failed', 'Please try again',
          snackPosition: SnackPosition.TOP);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Forgot Password',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.deepPurple[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validator.validateEmail(
                email: value,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple
                //primar: Colors.deepPurple
              ),
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isNotEmpty) {
                  resetPassword(email);
                } else {
                  Get.snackbar('Email Required', 'Please enter your email',
                      snackPosition: SnackPosition.TOP);
                }
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
