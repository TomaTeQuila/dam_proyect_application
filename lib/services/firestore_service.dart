import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots();  
  }

  Stream<QuerySnapshot> eventosPopulares() {
    return FirebaseFirestore.instance.collection('eventos').orderBy('likes', descending: true).snapshots();  
  }

  Stream<QuerySnapshot> eventosActivos() {
    return FirebaseFirestore.instance.collection('eventos').where('estado', isEqualTo: 'Activo').snapshots();  
  }

  Stream<QuerySnapshot> eventosPronto() {

    DateTime now = DateTime.now();
    DateTime future = now.add(Duration(days: 3));


    return FirebaseFirestore.instance.collection('eventos')
      .where('timestamps', isGreaterThanOrEqualTo: now)
      .where('timestamps', isLessThanOrEqualTo: future)
      .snapshots();
  }

  Future<void> eventoStateToFalse(String id) async {
    await FirebaseFirestore.instance.collection('eventos').doc(id).update({'estado': 'Finalizado'});
  }

  Future<void> eventoStateToTrue(String id) async {
    await FirebaseFirestore.instance.collection('eventos').doc(id).update({'estado': 'Activo'});
  }

  Stream<QuerySnapshot> eventosFinalizados() {
    DateTime now = DateTime.now();
    return FirebaseFirestore.instance.collection('eventos').where('estado', isEqualTo: 'Finalizado').snapshots();
  }

  Future<void> eventoAgregar(String nombre, String lugar, String descripcion, String tipo, DateTime timestamps, String image,int likes, String estado) async {
    return FirebaseFirestore.instance.collection('eventos').doc().set({
      'nombre': nombre,
      'lugar' : lugar,
      'descripcion' : descripcion,
      'tipo' : tipo,
      'timestamps' : timestamps,
      'image' : image,
      'likes' : 0,
      'estado' : estado,
    });
  }

  
  Future<void> eventoBorrar(String docId) async{
    return FirebaseFirestore.instance.collection('eventos').doc(docId).delete();
  }
}