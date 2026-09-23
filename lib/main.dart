import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/auth/login_view.dart'; // Tu login corporativo con botones corregidos

void main() async {
  // Inicialización obligatoria de componentes antes de arrancar
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Asistencia Saas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F172A)),
        useMaterial3: true,
      ),
      home: const LoginView(), // Obliga a arrancar en tu login empresarial actualizado
    );
  }
}
