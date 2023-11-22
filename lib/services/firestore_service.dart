import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //obtener lista de estudiantes
  Stream<QuerySnapshot> eventos() {
    // return FirebaseFirestore.instance.collection('estudiantes').snapshots();
    return FirebaseFirestore.instance.collection('eventos').orderBy('nombre').snapshots();
    // return FirebaseFirestore.instance.collection('estudiantes').where('edad', isLessThanOrEqualTo: 25).snapshots();
  }

  Future<void> eventoAgregar(String nombre, String lugar, String descripcion, String tipo, DateTime fecha, DateTime hora,String image,int likes) async {
    return FirebaseFirestore.instance.collection('eventos').doc().set({
      'nombre': nombre,
      'lugar' : lugar,
      'descripcion' : descripcion,
      'tipo' : tipo,
      'fecha' : fecha,
      'hora' : hora,
      'image' : 'image',
      'likes' : 0,
    });
  }

  
  Future<void> eventoBorrar(String docId) async{
    return FirebaseFirestore.instance.collection('eventos').doc(docId).delete();
  }
}