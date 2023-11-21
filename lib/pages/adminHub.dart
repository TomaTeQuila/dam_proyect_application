import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyect_application/pages/agregar_evento.dart';
import 'package:dam_proyect_application/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class adminHubPage extends StatelessWidget {

  final formatoFecha = DateFormat('dd-MM-yyyy');
  final formatoHora = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
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
                  Text(" Show ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            itemBuilder: (context) => [PopupMenuItem(child: Text('Admin Login'), value: 'adminlogin')],
            onSelected: (opcion) {
              print("Nigger");
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
                              FirestoreService().eventoBorrar(evento.id);
                            },
                          ),
                          SlidableAction(
                            icon: MdiIcons.pencil,
                            label: 'Editar',
                            backgroundColor: Colors.green,
                            onPressed: (context) {
                              FirestoreService().eventoBorrar(evento.id);
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
                            Image(image: AssetImage('assets/images/pencapalooza.png'),),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [                               
                                 Row(children: [
                                  Icon(MdiIcons.calendar),
                                  Text(formatoFecha.format(evento['fecha'].toDate())),
                                  ],
                                 ),
                                 Row(
                                  children: [
                                    Icon(MdiIcons.clock),
                                    Text(formatoHora.format(evento['fecha'].toDate())),
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
                                height: 500,
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
                                      Image(image: AssetImage('assets/images/pencapalooza.png')),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                        Text('Tipo: '),
                                        Text('${evento['tipo']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                      ],),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                        Row(
                                          children: [
                                            Icon(MdiIcons.calendar),
                                            Text(formatoFecha.format(evento['fecha'].toDate())),
                                          ],
                                        ),
                                        Row(children: [
                                          Icon(MdiIcons.clock),
                                          Text(formatoHora.format(evento['fecha'].toDate())),
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
}