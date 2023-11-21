import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //obtener lista de estudiantes
  Stream<QuerySnapshot> eventos() {
    // return FirebaseFirestore.instance.collection('estudiantes').snapshots();
    return FirebaseFirestore.instance.collection('eventos').orderBy('nombre').snapshots();
    // return FirebaseFirestore.instance.collection('estudiantes').where('edad', isLessThanOrEqualTo: 25).snapshots();
  }

  Future<void> estudianteAgregar(String nombre, String lugar, String descripcion, String tipo, DateTime fecha, DateTime hora, int likes, String image) async {
    return FirebaseFirestore.instance.collection('estudiantes').doc().set({
      'nombre': nombre,
      'lugar' : lugar,
      'descripcion' : descripcion,
      'tipo' : tipo,
      'fecha' : fecha,
      'hora' : hora,
      'likes' : 0,
      'image' : 'image',
    });
  }

  Future<void> eventoBorrar(String docId) async{
    return FirebaseFirestore.instance.collection('eventos').doc(docId).delete();
  }
}