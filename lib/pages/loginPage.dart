import 'package:dam_proyect_application/pages/adminHub.dart';
import 'package:dam_proyect_application/services/google_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  String msgError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          margin: EdgeInsets.only(top: 0),
          child: Form(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 180, horizontal: 20),
              color: Colors.white,
              child: Column(
                children: [
                  Icon(MdiIcons.hammerWrench, color: const Color.fromARGB(255, 0, 0, 0), size: 120),
                  Text('Ingrese sus credenciales de administrador.'),
                  //email
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: TextField(
                      controller: emailCtrl,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  //password
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: TextFormField(
                      controller: passwordCtrl,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                         borderSide: BorderSide(color: Colors.black)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Contraseña',
                      ),
                    ),
                  ),
                  //boton
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text('Iniciar Sesión como Administrador', style: TextStyle(color: Colors.black),),
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailCtrl.text.trim(),
                            password: passwordCtrl.text.trim(),
                          );
                        } on FirebaseAuthException catch (ex) {
                          //llega acá si hay algún problema con el login
                          setState(() {
                            switch (ex.code) {
                              case 'channel-error':
                                msgError = 'Ingrese sus credenciales';
                                break;
                              case 'invalid-email':
                                msgError = 'Email no válido';
                                break;
                              case 'INVALID_LOGIN_CREDENTIALS':
                                msgError = 'Credenciales incorrectas';
                                break;
                              case 'user-disabled':
                                msgError = 'Cuenta desactivada';
                                break;
                              default:
                                msgError = 'Error desconocido';
                            }
                          });
                        }
                      },
                    ),
                  ),
                  //errores
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(msgError, style: TextStyle(color: Colors.red)),
                  ),
                  Divider(),
                  Text('O desea iniciar con'),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          child: FilledButton(
                            child: Row(
                              children: [
                                Icon(MdiIcons.google),
                                Text(' Iniciar Sesion con Google'),
                              ],
                            ),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}