import 'package:flutter/material.dart';
import 'eventos.dart';
import 'appbuttombar.dart';
import 'home.dart';
import 'perfil.dart';
import 'eventos_repository.dart';

class AddEventoPage extends StatefulWidget {
  final String? emailLogado;
  final Function(Evento)? onEventoAdicionado;

  const AddEventoPage({Key? key, this.emailLogado, this.onEventoAdicionado}) : super(key: key);

  @override
  State<AddEventoPage> createState() => _AddEventoPageState();
}

class _AddEventoPageState extends State<AddEventoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  DateTime? dataEvento;
  bool ativo = true;

  void _salvarEvento() async {
    if (_formKey.currentState!.validate() && dataEvento != null) {
      final novoEvento = Evento(
        nome: nomeController.text,
        local: localController.text,
        endereco: enderecoController.text,
        data: dataEvento!,
        usuario: widget.emailLogado ?? '',
      );
      await EventosRepository.salvarEvento(novoEvento); // Salva no Firestore
      widget.onEventoAdicionado?.call(novoEvento);
      Navigator.pop(context, novoEvento);
    } else if (dataEvento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione a data do evento')),
      );
    }
  }

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(emailLogado: widget.emailLogado ?? "")),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => EventosPage(emailLogado: widget.emailLogado ?? "")),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PerfilPage(emailLogado: widget.emailLogado ?? "")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Evento'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome do Evento'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o endereço' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  dataEvento == null
                      ? 'Selecione a data'
                      : 'Data: ${dataEvento!.day}/${dataEvento!.month}/${dataEvento!.year}',
                ),
                trailing: Icon(Icons.calendar_today, color: primaryColor),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    locale: const Locale('pt', 'BR'),
                  );
                  if (picked != null) {
                    setState(() {
                      dataEvento = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text('Evento Ativo'),
                value: ativo,
                onChanged: (val) => setState(() => ativo = val),
                activeColor: primaryColor,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _salvarEvento,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        emailLogado: widget.emailLogado ?? "",
        currentIndex: 1,
        onTap: _onNavTap,
      ),
    );
  }
}
