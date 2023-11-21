import 'package:dam_proyect_application/pages/adminHub.dart';
import 'package:dam_proyect_application/services/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class googleLoginPage extends StatefulWidget {
  const googleLoginPage({super.key});

  @override
  State<googleLoginPage> createState() => _googleLoginPageState();
}

class _googleLoginPageState extends State<googleLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 50,
          child: SignInButton(
            Buttons.google,
            onPressed: () async {
              var user = await FirebaseAuthService().signInWithGoogle();
              if (user != null) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => adminHubPage()),
                    (route) => false);
              }
            },
          ),
        ),
      ),
    );
  }
}