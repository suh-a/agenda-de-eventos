import 'db_firestore.dart';
import 'eventos.dart';

class EventosRepository {
  static Future<void> salvarEvento(Evento evento) async {
    await DbFirestore.get()
        .collection('eventos')
        .add(evento.toMap());
  }

  static Future<List<Evento>> buscarEventos() async {
    final snapshot = await DbFirestore.get().collection('eventos').get();
    return snapshot.docs.map((doc) => Evento.fromMap(doc.data())).toList();
  }
}