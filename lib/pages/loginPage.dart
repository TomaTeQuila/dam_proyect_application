import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
          child: Form(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 150, horizontal: 20),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MdiIcons.hammerWrench, color: const Color.fromARGB(255, 0, 0, 0), size: 32),
                      Text('Admin Login', style: TextStyle(fontSize: 32),)
                    ],
                  ),
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
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (ex) {
                          //llega acá si hay algún problema con el login
                          setState(() {
                            switch (ex.code) {
                              case 'channel-error':
                                msgError = 'Debe Ingresar credenciales';
                                break;
                              case 'invalid-email':
                                msgError = 'Respetar formato de email';
                                break;
                              case 'INVALID_LOGIN_CREDENTIALS':
                                msgError = 'Credenciales incorrectas\n Prueba otro email o contraseña';
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
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async{
                          await logGoogle();
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(

                              margin: EdgeInsets.fromLTRB(10, 10, 5, 10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.green),
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(MdiIcons.google, size: 20,),
                              )),
                              Text('Iniciar sesion con Google'),
                          ],
                        ),
                      ),
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

  Future<UserCredential?> logGoogle() async {
  try {
    final GoogleSignInAccount? userG = await GoogleSignIn().signIn();
    print(userG);
    if (userG == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Inicio de sesión cancelado por el usuario',
      );
    }
    final GoogleSignInAuthentication? authG = await userG.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: authG?.accessToken,
      idToken: authG?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    
    print('Error al iniciar sesión con Google: $e');
    return null;
  }
}
}