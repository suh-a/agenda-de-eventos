import 'package:flutter/material.dart';
import 'Login.dart';
import 'home.dart';
import 'perfil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda de Eventos',
      theme: ThemeData(
        primaryColor: Color(0xFF0099D8),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF0099D8),
          secondary: Colors.indigoAccent,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
