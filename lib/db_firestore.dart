import 'package:cloud_firestore/cloud_firestore.dart';

class DbFirestore {
  DbFirestore._();
  static final DbFirestore instance = DbFirestore._();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  static FirebaseFirestore get(){
    return DbFirestore.instance.firestore;
  }
}