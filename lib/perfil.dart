import 'package:flutter/material.dart';
import 'Login.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late TextEditingController nomeController;
  late TextEditingController dataNascController;
  late TextEditingController emailController;
  late TextEditingController telefoneController;
  late TextEditingController senhaController;
  late TextEditingController novaSenhaController;
  late TextEditingController confirmarNovaSenhaController;

  bool editando = false;
  bool mudandoSenha = false;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: UsuarioRepository.nome ?? '');
    dataNascController = TextEditingController(text: UsuarioRepository.dataNascimento ?? '');
    emailController = TextEditingController(text: UsuarioRepository.email ?? '');
    telefoneController = TextEditingController(text: UsuarioRepository.telefone ?? '');
    senhaController = TextEditingController();
    novaSenhaController = TextEditingController();
    confirmarNovaSenhaController = TextEditingController();
  }

  @override
  void dispose() {
    nomeController.dispose();
    dataNascController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
    novaSenhaController.dispose();
    confirmarNovaSenhaController.dispose();
    super.dispose();
  }

  void salvarEdicao() {
    setState(() {
      UsuarioRepository.nome = nomeController.text;
      UsuarioRepository.dataNascimento = dataNascController.text;
      UsuarioRepository.email = emailController.text;
      UsuarioRepository.telefone = telefoneController.text;
      editando = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dados atualizados com sucesso!')),
    );
  }

  void salvarNovaSenha() {
    if (senhaController.text != UsuarioRepository.senha) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha atual incorreta!')),
      );
      return;
    }
    if (novaSenhaController.text != confirmarNovaSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('As novas senhas não coincidem!')),
      );
      return;
    }
    setState(() {
      UsuarioRepository.senha = novaSenhaController.text;
      mudandoSenha = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Senha alterada com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF0099D8);
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(editando ? Icons.save : Icons.edit),
            tooltip: editando ? 'Salvar' : 'Editar',
            onPressed: () {
              if (editando) {
                salvarEdicao();
              } else {
                setState(() => editando = true);
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: primaryColor.withOpacity(0.2),
              child: Icon(Icons.person, size: 60, color: primaryColor),
            ),
            const SizedBox(height: 24),
            _buildTextField('Nome completo', nomeController, enabled: editando),
            const SizedBox(height: 16),
            _buildTextField('Data de nascimento', dataNascController, enabled: editando),
            const SizedBox(height: 16),
            _buildTextField('Email', emailController, enabled: editando),
            const SizedBox(height: 16),
            _buildTextField('Telefone', telefoneController, enabled: editando),
            const SizedBox(height: 32),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock, color: primaryColor),
              title: Text('Alterar senha', style: TextStyle(color: primaryColor)),
              trailing: Icon(mudandoSenha ? Icons.expand_less : Icons.expand_more, color: primaryColor),
              onTap: () => setState(() => mudandoSenha = !mudandoSenha),
            ),
            if (mudandoSenha) ...[
              _buildTextField('Senha atual', senhaController, obscure: true),
              const SizedBox(height: 12),
              _buildTextField('Nova senha', novaSenhaController, obscure: true),
              const SizedBox(height: 12),
              _buildTextField('Confirmar nova senha', confirmarNovaSenhaController, obscure: true),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  elevation: 6,
                ),
                onPressed: salvarNovaSenha,
                child: Text('Salvar nova senha'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = false, bool obscure = false}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: enabled ? Colors.grey[50] : Colors.grey[200],
        suffixIcon: obscure ? Icon(Icons.visibility_off) : null,
      ),
    );
  }
}
