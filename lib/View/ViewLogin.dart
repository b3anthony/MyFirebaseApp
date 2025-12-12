import 'package:flutter/material.dart';
import 'package:my_firebase_app/Servicios/auth_service.dart';

class ViewLogin extends StatefulWidget {
  const ViewLogin({super.key});

  @override
  State<ViewLogin> createState() => _ViewLoginState();
}

class _ViewLoginState extends State<ViewLogin> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();
  
  String errorMessage = "";
  bool _isLoading = false;
  bool _isRegistering = false;

  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      errorMessage = "";
    });

    try {
      final user = _isRegistering
          ? await auth.register(emailController.text.trim(), passwordController.text)
          : await auth.login(emailController.text.trim(), passwordController.text);

      if (user != null && mounted) {
        // La navegación se maneja automáticamente por el AuthGate
      }
    } catch (e) {
      setState(() {
        if (_isRegistering) {
          errorMessage = "Error al registrar. Verifica los datos.";
        } else {
          errorMessage = "Credenciales incorrectas";
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      errorMessage = "";
    });

    try {
      final user = await auth.signInWithGoogle();
      if (user == null && mounted) {
        setState(() {
          errorMessage = "No se pudo completar el inicio de sesión con Google";
        });
      }
      // Si user no es null, AuthGate redirigirá automáticamente
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Error al iniciar sesión con Google: ${e.toString()}";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo o título
                Icon(
                  Icons.auto_stories,
                  size: 80,
                  color: Colors.brown[700],
                ),
                const SizedBox(height: 20),
                Text(
                  _isRegistering ? 'Crear Cuenta' : 'Biblioteca Digital',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!_isRegistering)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Inicia sesión para continuar',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.brown[400],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 30),

                // Campo de email
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Correo electrónico",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su correo';
                    }
                    if (!value.contains('@')) {
                      return 'Ingrese un correo válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo de contraseña
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Mensaje de error
                if (errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),

                // Botón principal (Login o Registro)
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleEmailAuth,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _isRegistering ? 'Registrarse' : 'Iniciar Sesión',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 15),

                // Botón de cambio entre login y registro
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isRegistering = !_isRegistering;
                            errorMessage = "";
                          });
                        },
                  child: Text(
                    _isRegistering
                        ? '¿Ya tienes cuenta? Inicia sesión'
                        : '¿No tienes cuenta? Regístrate',
                  ),
                ),
                const SizedBox(height: 20),

                // Divider
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("O"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),

                // Botón de Google Sign-In
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  icon: Image.network(
                    'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.g_mobiledata);
                    },
                  ),
                  label: const Text('Continuar con Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}