import 'package:flutter/material.dart';
import 'package:agenda/home.dart';

class UsuarioRepository {
  static String? nome;
  static String? dataNascimento;
  static String? email;
  static String? telefone;
  static String? senha;

  static bool get temUsuario => email != null && senha != null;

  static bool validarLogin(String emailDigitado, String senhaDigitada) {
    return emailDigitado == email && senhaDigitada == senha;
  }

  static void salvarUsuario({
    required String nomeCompleto,
    required String dataNasc,
    required String emailCadastro,
    required String telefoneCadastro,
    required String senhaCadastro,
  }) {
    nome = nomeCompleto;
    dataNascimento = dataNasc;
    email = emailCadastro;
    telefone = telefoneCadastro;
    senha = senhaCadastro;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool existeUsuario = UsuarioRepository.temUsuario;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: senhaController,
                      label: 'Senha',
                      icon: Icons.lock,
                      obscure: true,
                    ),
                    const SizedBox(height: 30),
                    _buildButton(
                      text: 'Login',
                      onPressed: () {
                        final email = emailController.text.trim();
                        final senha = senhaController.text;

                        if (email.isEmpty || senha.isEmpty) {
                          _showSnack('Preencha todos os campos');
                          return;
                        }

                        if (!existeUsuario) {
                          _showSnack('Nenhum usuário cadastrado. Cadastre-se.');
                          return;
                        }

                        if (!UsuarioRepository.validarLogin(email, senha)) {
                          _showSnack('Email ou senha incorretos');
                          return;
                        }

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    if (!existeUsuario)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CadastroPage()),
                          );
                        },
                        child: Text(
                          'Cadastre-se',
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  int etapa = 1;

  final nomeController = TextEditingController();
  final dataNascController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  void proximaEtapa() {
    setState(() => etapa++);
  }

  void voltar() {
    if (etapa > 1) {
      setState(() => etapa--);
    } else {
      Navigator.pop(context);
    }
  }

  void concluirCadastro() {
    if (senhaController.text != confirmarSenhaController.text) {
      _showSnack('As senhas não coincidem');
      return;
    }

    UsuarioRepository.salvarUsuario(
      nomeCompleto: nomeController.text,
      dataNasc: dataNascController.text,
      emailCadastro: emailController.text,
      telefoneCadastro: telefoneController.text,
      senhaCadastro: senhaController.text,
    );

    _showSnack('Cadastro realizado com sucesso!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Cadastro - Etapa $etapa'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: voltar),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (etapa == 1) ...[
                      _buildTextField('Nome completo', nomeController),
                      const SizedBox(height: 16),
                      _buildTextField('Data de nascimento', dataNascController),
                    ] else if (etapa == 2) ...[
                      _buildTextField('Email', emailController),
                      const SizedBox(height: 16),
                      _buildTextField('Telefone', telefoneController),
                    ] else if (etapa == 3) ...[
                      _buildTextField('Senha', senhaController, obscure: true),
                      const SizedBox(height: 16),
                      _buildTextField('Confirmar senha', confirmarSenhaController, obscure: true),
                    ],
                    const SizedBox(height: 32),
                    _buildButton(
                      text: etapa < 3 ? 'Próximo' : 'Cadastrar',
                      onPressed: etapa < 3 ? proximaEtapa : concluirCadastro,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

