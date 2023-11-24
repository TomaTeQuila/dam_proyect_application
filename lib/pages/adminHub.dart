import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyect_application/pages/agregar_evento.dart';
import 'package:dam_proyect_application/pages/homePage.dart';
import 'package:dam_proyect_application/pages/tabs/publicHub.dart';
import 'package:dam_proyect_application/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class adminHubPage extends StatelessWidget {

  final formatoFecha = DateFormat('dd-MM-yyyy');
  final formatoHora = DateFormat('HH:mm');
  String estado = '';
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar( 
        backgroundColor: Colors.red,
        title: Row(
          children: [
            Icon(MdiIcons.ticket),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Row(
                children: [
                  Text(" Admin ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Text(" HUB ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),    
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [PopupMenuItem(child: Text('Cerrar Sesión'), value: 'logout')],
            onSelected: (opcion) async {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Padding(
           padding: EdgeInsets.all(10),
           child: StreamBuilder(
            stream: FirestoreService().eventos(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }else{
                return ListView.separated(
                  separatorBuilder: ((context, index) => Divider()),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    var evento = snapshot.data!.docs[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            icon: MdiIcons.trashCan,
                            label: 'Borrar',
                            backgroundColor: Colors.red,
                            onPressed: (context) {
                              showDialog(
                                barrierDismissible: false,
                                context: scaffoldKey.currentContext!,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[350],
                                    title: Row(
                                      children: [
                                        Icon(MdiIcons.trashCan, color: Colors.red[800],),
                                        Text('Confirmar Borrado', style: TextStyle(color: Colors.red[600]),),
                                      ],
                                    ),
                                    content: Row(
                                      children: [
                                        Text('¿Estás seguro de borrar '),
                                        Text('${evento['nombre']}', style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text('?')
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            child: Text('CONFIRMAR', style: TextStyle(color: Colors.red[500]),),
                                            onPressed: () {
                                              FirestoreService().eventoBorrar(evento.id);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Volver Atrás', style: TextStyle(color: Colors.black),),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),          
                          SlidableAction(
                            icon: MdiIcons.arrowExpandHorizontal,
                            label: 'Estado',
                            backgroundColor: Colors.green,
                            onPressed: (context) {
                              if ('${evento['estado']}' == 'Finalizado'){
                                FirestoreService().eventoStateToTrue(evento.id);
                              }
                              if ('${evento['estado']}' == 'Activo'){
                                FirestoreService().eventoStateToFalse(evento.id);
                              }
                            },
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                                Text("Evento: "),
                                Text("${evento['nombre']}", style: TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Image.network('${evento['image']}'),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [                               
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Row(
                                    children: [
                                      Icon(MdiIcons.calendar),
                                      Text(formatoFecha.format(evento['timestamps'].toDate())),
                                    ],
                                  ),
                                   Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                        Icon(MdiIcons.heart, color: Colors.redAccent[400],),
                                        Text('Likes: ${evento['likes']}'),
                                      ],),
                                  ],
                                 ),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [   
                                     Row(
                                      children: [
                                        Icon(MdiIcons.clock),
                                        Text(formatoHora.format(evento['timestamps'].toDate())),
                                      ],
                                     ),
                                    Row(children: [
                                      Text('Estado: ${evento['estado']}'),
                                    ],)
                                   ],
                                 ),
                              ],
                            ),
                          ],
                        ),
                        onLongPress: () {
                              //bottom sheet con info de estudiante
                          showBottomSheet(
                            context: context, 
                            builder: (context){
                              return SizedBox(
                                height: 700,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    border: Border.all(color: Colors.black, width: 0.5),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Información del Evento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                                      SizedBox(
                                        height: 150,
                                        child: Image.network('${evento['image']}')
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                        Text('Tipo: '),
                                        Text('${evento['tipo']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                      ],),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                        
                                        Icon(MdiIcons.heart, color: Colors.redAccent[400],),
                                        Text('Likes: ${evento['likes']}'),
                                      ],),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                        Row(
                                          children: [
                                            Icon(MdiIcons.calendar),
                                            Text(formatoFecha.format(evento['timestamps'].toDate())),
                                          ],
                                        ),
                                        Row(children: [
                                          Icon(MdiIcons.clock),
                                          Text(formatoHora.format(evento['timestamps'].toDate())),
                                          ],
                                        ),
                                        Row(children: [
                                          Icon(MdiIcons.mapMarkerRadius),
                                          Text('${evento['lugar']}'),
                                          ],
                                        ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black, width: 0.1),
                                          borderRadius: BorderRadius.circular(1)
                                        ),
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
                                            child: Column(
                                              children: [
                                                Text('${evento['descripcion']}'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),                                       
                                    ],
                                  ),
                                ),
                              );
                            }
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
           ), 
          ),),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[200],
        child: Icon(Icons.add_circle_outline_sharp),
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(builder: (context) => EventoAgregarPage());
          Navigator.push(context, route);
        },
      ),
    );
}
  String emailUsuario(BuildContext context) {
    final usuario = Provider.of<User?>(context);
    return usuario!.email.toString();
  }

}

