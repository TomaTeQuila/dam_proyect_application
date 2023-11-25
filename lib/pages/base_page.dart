import 'package:dam_proyect_application/pages/adminHub.dart';
import 'package:dam_proyect_application/pages/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<User?>(context);

    if (usuario == null){
      return homePage();
    }else{
      return adminHubPage();
    }
  }
}