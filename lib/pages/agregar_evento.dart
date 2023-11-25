import 'dart:io';

import 'package:dam_proyect_application/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EventoAgregarPage extends StatefulWidget {

  @override
  State<EventoAgregarPage> createState() => _EventoAgregarPageState();
}

class _EventoAgregarPageState extends State<EventoAgregarPage> {
  /*
      'nombre': nombre,
      'lugar' : lugar,
      'descripcion' : descripcion,
      'tipo' : tipo,
      'fecha' : fecha,
      'hora' : hora,
      'image' : 'image',
      'likes' : 0,
  */
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController tipoCtrl = TextEditingController();
  
  bool isTimePicked = false;
  bool isDatePicked = false;
  bool existImage = false;

  final formKey = GlobalKey<FormState>();
  DateTime timestamps = DateTime.now();

  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        title: Text('Agregar Evento'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Expanded(
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                  controller: nombreCtrl,
                  decoration: InputDecoration(
                    label: Text('Nombre'),
                  ),
                  validator: (nombre) {
                    //si se retorna un string (mensaje de error) campo es no valido
                    //si se retorna null o no hay return, el campo está ok
                    if (nombre!.isEmpty) {
                      return 'Indique el nombre';
                    }
                    if (nombre.length < 3) {
                      return 'El nombre debe tener al menos 3 letras';
                    }
                    return null;
                  },),
                ),
                Container(
                  child: TextFormField(
                  controller: lugarCtrl,
                  decoration: InputDecoration(
                    label: Text('Lugar Evento'),
                  ),
                  validator: (lugar) {
                    //si se retorna un string (mensaje de error) campo es no valido
                    //si se retorna null o no hay return, el campo está ok
                    if (lugar!.isEmpty) {
                      return 'Indique el lugar del evento';
                    }
                    if (lugar.length < 3) {
                      return 'El lugar debe tener al menos 3 letras';
                    }
                    return null;
                  },),
                ),
                Container(
                  child: TextFormField(
                  controller: descCtrl,
                  decoration: InputDecoration(
                    label: Text('Descripción del Evento'),
                  ),
                  validator: (desc) {
                    //si se retorna un string (mensaje de error) campo es no valido
                    //si se retorna null o no hay return, el campo está ok
                    if (desc!.isEmpty) {
                      return 'Indique la descripcion del evento';
                    }
                    return null;
                  },),
                ),
                Container(
                  child: TextFormField(
                  controller: tipoCtrl,
                  decoration: InputDecoration(
                    label: Text('Tipo del Evento (Concierto, festival, etc.)'),
                  ),
                  validator: (tipo) {
                    //si se retorna un string (mensaje de error) campo es no valido
                    //si se retorna null o no hay return, el campo está ok
                    if (tipo!.isEmpty) {
                      return 'Indique el tipo del evento';
                    }
                    return null;
                  },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell (
                        child: Row(
                          children: [
                            Icon(MdiIcons.image, size: 32,),
                            Text('Seleccionar imagen', style: TextStyle(fontSize: 22),)
                          ],
                        ),
                        onTap: () async{
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
          
                          String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();
          
                          Reference refRoot = FirebaseStorage.instance.ref();
                          Reference refDirImage = refRoot.child('images');
          
                          Reference referencImgToUpload = refDirImage.child(uniqueFileName);
          
                          try{
                            if(file != null){
                              await referencImgToUpload.putFile(File(file!.path));
                              imageUrl = await referencImgToUpload.getDownloadURL();
                              existImage = true;
                            }
          
                          }catch(error){
                            print("error catástrofico!");
                          }
          
          
                        },
                      ),
                    ],
                  ),
                ),
                InkWell (
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MdiIcons.calendar, size: 32,),
                      Text('Seleccionar Fecha', style: TextStyle(fontSize: 22),)
                    ],
                  ),
                  onTap: () async{
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), 
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                      locale: Locale('es', 'ES'),
                    ).then((fecha){
                    if(fecha != null){                    
                      setState(() {
                        timestamps = fecha;
                        isDatePicked = true;
                      }
                    
                      );
                    }
                    });
                    print(timestamps);
                  },
                ),
                InkWell (
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MdiIcons.clock, size: 32,),
                      Text('Seleccionar Hora', style: TextStyle(fontSize: 22),)
                    ],
                  ),
                  onTap: () async{
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: timestamps.hour,
                        minute: timestamps.minute,
                      ), 
                    ).then((hora){
                    if (hora!=null){
                      setState(() {
                        timestamps = DateTime(
                          timestamps.year,
                          timestamps.month,
                          timestamps.day,
                          hora.hour,
                          hora.minute,
                        );
                        isTimePicked = true;
                      });
                    }
                    });
                    print(timestamps);
                  },
                ),
                ElevatedButton(
                  child: Text('Guardar'),
                  onPressed: (){
                    if(formKey.currentState!.validate() && validarFecha()){
                      FirestoreService().eventoAgregar(
                        nombreCtrl.text.trim(), 
                        lugarCtrl.text.trim(), 
                        descCtrl.text.trim(), 
                        tipoCtrl.text.trim(), 
                        timestamps, 
                        imageUrl, 
                        0,
                        'Activo',
                      );
                      Navigator.pop(context);
                    }
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool validarFecha() {
    if (formKey.currentState!.validate()) {
      String errores = "";
      if (!isDatePicked) errores += "Debes seleccionar una fecha.\n";
      if (!isTimePicked) errores += "Debes seleccionar una hora.\n";
      if (existImage == false) errores += "Debes subir una imagen.\n";
      if (errores != "") {
        EasyLoading.showError(errores, duration: Duration(seconds: 1));
      } else {
        return true;
      }
    }
    return false;
  }
}