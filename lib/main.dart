import 'package:flutter/material.dart';
import 'package:rosha/presentation/loginScreen.dart';
import 'package:rosha/presentation/registerScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urban Drive',
      theme: ThemeData(
        // Defina o tema da aplicação
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/', // Define a rota inicial
      routes: {
        '/': (context) => const LoginScreen(), // Tela de login
        '/register': (context) => const RegisterScreen(), // Tela de registro
      },
    );
  }
}
