import 'package:dam_proyect_application/pages/adminHub.dart';
import 'package:dam_proyect_application/pages/publicHub.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //decidir si mostrar el login o pagina home (estudiantes)

    final usuario = Provider.of<User?>(context);

    if (usuario == null){
      return publicHubPage();
    }else{
      return adminHubPage();
    }
  }
}