import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyect_application/pages/loginPage.dart';
import 'package:dam_proyect_application/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:intl/intl.dart';

class endEvents extends StatelessWidget {

  final formatoFecha = DateFormat('dd-MM-yyyy');
  final formatoHora = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(child: Padding(
           padding: EdgeInsets.all(10),
           child: StreamBuilder(
            stream: FirestoreService().eventosFinalizados(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }else{
                return ListView.separated(
                  separatorBuilder: ((context, index) => Divider()),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    var evento = snapshot.data!.docs[index];
                    return ListTile(
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
                                //  TextButton(
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Icon(MdiIcons.heartPlus),
                                //       Text('Me gusta')
                                //     ],
                                //   ),
                                //   onPressed: () {
                                //     var collection = FirebaseFirestore.instance.collection('eventos');
                                //     collection
                                //       .doc(evento.id)
                                //       .update({'likes' : FieldValue.increment(1)}) // <-- Datos actualizados
                                //       .then((_) => print('Éxito'))
                                //       .catchError((error) => print('Error: $error'));
                                //   },
                                //  ),
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
                    );
                  },
                );
              }
            },
           ), 
          ),),
        ],
      );
  }
}