import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').orderBy('likes', descending: true).snapshots();  }

  // Stream<QuerySnapshot> eventosFinalizados() {
  //   return FirebaseFirestore.instance.collection('eventos').orderBy('timestamps').where('timestamps', isLessThanOrEqualTo: DateTime.now()).snapshots();
  // }

  Future<void> eventoAgregar(String nombre, String lugar, String descripcion, String tipo, DateTime timestamps, String image,int likes) async {
    return FirebaseFirestore.instance.collection('eventos').doc().set({
      'nombre': nombre,
      'lugar' : lugar,
      'descripcion' : descripcion,
      'tipo' : tipo,
      'timestamps' : timestamps,
      'image' : image,
      'likes' : 0,
    });
  }

  
  Future<void> eventoBorrar(String docId) async{
    return FirebaseFirestore.instance.collection('eventos').doc(docId).delete();
  }
}