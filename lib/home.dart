import 'package:flutter/material.dart';
import 'perfil.dart';
import 'package:agenda/eventos.dart';
import 'appbuttombar.dart';


class HomePage extends StatelessWidget {
  final String emailLogado; // Recebe o email do usuário logado

  const HomePage({super.key, required this.emailLogado});

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) return; // já está na Home
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => EventosPage(emailLogado: emailLogado)),
      );
    }
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PerfilPage(emailLogado: emailLogado)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Cadastrar Evento'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Card da esquerda
            Expanded(
              child: EventCard(
                icon: Icons.add,
                label: "Novo Evento",
                color: Colors.lightBlue,
                onTap: null,
              ),
            ),
            SizedBox(width: 16),
            // Card da direita (navega)
            Expanded(
              child: EventCard(
                icon: Icons.visibility,
                label: "Visualizar Evento",
                color: Colors.indigoAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventosPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        emailLogado: emailLogado,
        currentIndex: 0,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const EventCard({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      height: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: cardContent)
        : cardContent;
  }
}
