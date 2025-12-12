import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase_app/Servicios/auth_service.dart';
import 'package:my_firebase_app/View/ViewLibros.dart';

class ViewHome extends StatelessWidget {
  const ViewHome({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final User? user = authService.currentUser;
    
    // Obtener nombre o email del usuario
    String displayName = user?.displayName ?? user?.email ?? "Usuario";
    
    return Scaffold(
      backgroundColor: const Color(0xFF020617), // Azul casi negro
      appBar: AppBar(
        title: const Text(
          "Biblioteca Digital",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFE5E7EB),
          ),
        ),
        backgroundColor: const Color(0xFF111827),
        foregroundColor: const Color(0xFFE5E7EB),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: () async {
              try {
                await authService.logout();
                if (context.mounted) {
                  // El AuthGate redirigirá automáticamente al login
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al cerrar sesión: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Avatar del usuario
              CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFFFBBF24).withValues(alpha: 0.2), // Dorado
                child: user?.photoURL != null
                    ? ClipOval(
                        child: Image.network(
                          user!.photoURL!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 60,
                              color: Color(0xFFFBBF24), // Dorado
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFFFBBF24), // Dorado
                      ),
              ),
              const SizedBox(height: 30),

              // Mensaje de bienvenida
              const Text(
                "¡Bienvenido a tu Biblioteca!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE5E7EB), // Casi blanco
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF9CA3AF), // Gris
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Tarjeta de Biblioteca
              Card(
                elevation: 6,
                color: const Color(0xFF111827), // Surface
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF111827),
                        const Color(0xFF1F2937),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.auto_stories,
                          size: 70,
                          color: Color(0xFFFBBF24), // Dorado
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Gestiona tu Colección",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE5E7EB), // Casi blanco
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Explora, organiza y administra tu biblioteca personal de libros",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF9CA3AF), // Gris
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ViewLibros(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward, size: 22),
                          label: const Text(
                            "Abrir Biblioteca",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 18,
                            ),
                            backgroundColor: const Color(0xFFFBBF24), // Dorado
                            foregroundColor: const Color(0xFF020617), // Azul oscuro
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botón de cerrar sesión
              TextButton.icon(
                onPressed: () async {
                  try {
                    await authService.logout();
                    if (context.mounted) {
                      // El AuthGate redirigirá automáticamente al login
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al cerrar sesión: $e')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout, color: Color(0xFF38BDF8)), // Celeste
                label: const Text(
                  "Cerrar Sesión",
                  style: TextStyle(
                    color: Color(0xFF38BDF8), // Celeste
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
