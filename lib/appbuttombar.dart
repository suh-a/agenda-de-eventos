import 'package:flutter/material.dart';

class AppBottomBar extends StatelessWidget {
  final String emailLogado;
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomBar({
    Key? key,
    required this.emailLogado,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.white),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event, color: Colors.white),
          label: 'Eventos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.white),
          label: 'Perfil',
        ),
      ],
      selectedLabelStyle: theme.textTheme.labelMedium?.copyWith(color: Colors.white),
      unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(color: Colors.white70),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showUnselectedLabels: true,
    );
  }
}