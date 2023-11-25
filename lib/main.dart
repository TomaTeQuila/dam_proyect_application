// ignore: unused_import
import 'package:dam_proyect_application/pages/adminHub.dart';
import 'package:dam_proyect_application/pages/base_page.dart';
import 'package:dam_proyect_application/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().usuario,
      child: MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: [const Locale('es')],
        title: 'ShowHUB',
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
          useMaterial3: true,
        ),
        home: BasePage(), 
      ),
    );
  }
}

