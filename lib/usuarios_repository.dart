import 'db_firestore.dart';

class UsuarioRepository {

  static Future<bool> validarLogin(String emailDigitado, String senhaDigitada) async {
    final doc = await DbFirestore.get().collection('usuarios').doc(emailDigitado).get();
    if (!doc.exists) return false;
    final data = doc.data()!;
    return data['senha'] == senhaDigitada;
  }

  static Future<void> salvarUsuario({
    required String nomeCompleto,
    required String dataNasc,
    required String emailCadastro,
    required String telefoneCadastro,
    required String senhaCadastro,
  }) async {
    await DbFirestore.get()
        .collection('usuarios')
        .doc(emailCadastro)
        .set({
      'nome': nomeCompleto,
      'dataNascimento': dataNasc,
      'email': emailCadastro,
      'telefone': telefoneCadastro,
      'senha': senhaCadastro,
    });
  }

  static Future<Map<String, dynamic>?> buscarUsuario(String emailUsuario) async {
    final doc = await DbFirestore.get().collection('usuarios').doc(emailUsuario).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  static Future<void> atualizarUsuario({
    required String emailUsuario,
    required String nome,
    required String dataNascimento,
    required String telefone,
  }) async {
    await DbFirestore.get().collection('usuarios').doc(emailUsuario).update({
      'nome': nome,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
    });
  }

  static Future<bool> atualizarSenha({
    required String emailUsuario,
    required String senhaAtual,
    required String novaSenha,
  }) async {
    final doc = await DbFirestore.get().collection('usuarios').doc(emailUsuario).get();
    if (!doc.exists || senhaAtual != (doc.data()?['senha'] ?? '')) {
      return false;
    }
    await DbFirestore.get().collection('usuarios').doc(emailUsuario).update({
      'senha': novaSenha,
    });
    return true;
  }
}