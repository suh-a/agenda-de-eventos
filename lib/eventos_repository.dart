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

  static Future<void> excluirEvento(Evento evento) async {
    final snapshot = await DbFirestore.get()
        .collection('eventos')
        .where('nome', isEqualTo: evento.nome)
        .where('endereco', isEqualTo: evento.endereco)
        .where('data', isEqualTo: evento.data.toIso8601String())
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}