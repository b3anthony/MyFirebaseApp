import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_firebase_app/View/AuthGate.dart';
import 'firebase_options.dart';

void main() async {
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
      debugShowCheckedModeBanner: false,
      title: 'Biblioteca Digital',
      theme: ThemeData(
        primaryColor: const Color(0xFFFBBF24), // Dorado
        scaffoldBackgroundColor: const Color(0xFF020617), // Azul casi negro
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFFBBF24), // Dorado
          secondary: const Color(0xFF38BDF8), // Celeste
          surface: const Color(0xFF111827), // Gris oscuro para cards
          background: const Color(0xFF020617), // Azul casi negro
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF111827),
          elevation: 4,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111827),
          foregroundColor: Color(0xFFE5E7EB),
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE5E7EB)),
          bodyMedium: TextStyle(color: Color(0xFF9CA3AF)),
          titleLarge: TextStyle(color: Color(0xFFE5E7EB)),
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
