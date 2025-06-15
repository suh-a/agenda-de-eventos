import 'package:flutter/material.dart';
import 'appbuttombar.dart';
import 'perfil.dart';
import 'home.dart';
import 'eventos_repository.dart';

class EventoDetalhesPage extends StatelessWidget {
  final Evento evento;

  const EventoDetalhesPage({Key? key, required this.evento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 28),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                evento.nome,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text('Endereço: ${evento.endereco}', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                'Data: ${evento.data.day}/${evento.data.month}/${evento.data.year}',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text(
                evento.ocorreu ? 'Já ocorreu' : 'Por vir',
                style: TextStyle(
                  color: evento.ocorreu ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Evento {
  final String nome;
  final String local;
  final String endereco;
  final DateTime data;
  final bool ocorreu;

  Evento({
    required this.nome,
    required this.local,
    required this.endereco,
    required this.data,
    required this.ocorreu,
  });

  factory Evento.fromMap(Map<String, dynamic> map) {
    return Evento(
      nome: map['nome'],
      local: map['local'],
      endereco: map['endereco'],
      data: DateTime.parse(map['data']),
      ocorreu: map['ocorreu'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'local': local,
      'endereco': endereco,
      'data': data.toIso8601String(),
      'ocorreu': ocorreu,
    };
  }
}

class EventosPage extends StatefulWidget {
  final String? emailLogado;
  const EventosPage({Key? key, this.emailLogado}) : super(key: key);

  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  late Future<List<Evento>> _eventosFuture;

  @override
  void initState() {
    super.initState();
    _eventosFuture = EventosRepository.buscarEventos();
  }

  void _onNavTap(int index) {
    if (index == 1) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(emailLogado: widget.emailLogado ?? "")),
      );
    }
    if (index == 2) {
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      body: FutureBuilder<List<Evento>>(
        future: _eventosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar eventos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum evento encontrado'));
          }
          final eventos = snapshot.data!;
          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: primaryColor.withOpacity(0.1)),
                ),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    evento.nome,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Endereço: ${evento.endereco}'),
                      Text('Data: ${evento.data.day}/${evento.data.month}/${evento.data.year}'),
                      const SizedBox(height: 4),
                      Text(
                        evento.ocorreu ? 'Já ocorreu' : 'Por vir',
                        style: TextStyle(
                          color: evento.ocorreu ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => EventoDetalhesPage(evento: evento),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: AppBottomBar(
        emailLogado: widget.emailLogado ?? "",
        currentIndex: 1,
        onTap: _onNavTap,
      ),
    );
  }
}