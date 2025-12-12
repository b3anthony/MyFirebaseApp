import 'package:flutter/material.dart';
import 'package:my_firebase_app/Servicios/LibrosServicio.dart';
import 'package:my_firebase_app/Servicios/auth_service.dart';
import 'package:my_firebase_app/View/ViewAgregarLibro.dart';
import 'package:my_firebase_app/View/ViewEditarLibro.dart';
import 'package:my_firebase_app/View/ViewLeerLibro.dart';

class ViewLibros extends StatefulWidget {
  const ViewLibros({super.key});

  @override
  State<ViewLibros> createState() => _ViewLibrosState();
}

class _ViewLibrosState extends State<ViewLibros> {
  final LibrosService _service = LibrosService();
  final AuthService _authService = AuthService();

  late Future<List<Map<String, dynamic>>> _futureLibros;

  @override
  void initState() {
    super.initState();
    _futureLibros = _service.obtenerLibros();
  }

  void _recargarLista() {
    setState(() {
      _futureLibros = _service.obtenerLibros();
    });
  }

  Future<void> _confirmarEliminar(String id, String titulo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de eliminar el libro '$titulo'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _service.eliminarLibro(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Libro eliminado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          _recargarLista();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617), // Azul casi negro
      appBar: AppBar(
        title: const Text(
          "Biblioteca Digital",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Color(0xFFE5E7EB),
          ),
        ),
        backgroundColor: const Color(0xFF111827), // Surface
        foregroundColor: const Color(0xFFE5E7EB),
        elevation: 0,
      ),
      floatingActionButton: _authService.isAdmin()
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ViewAgregarLibro()),
                ).then((_) => _recargarLista());
              },
              backgroundColor: const Color(0xFFFBBF24), // Dorado
              icon: const Icon(Icons.add, color: Color(0xFF020617)),
              label: const Text(
                "Nuevo Libro",
                style: TextStyle(
                  color: Color(0xFF020617),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      body: FutureBuilder(
        future: _futureLibros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF5D4037)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    size: 100,
                    color: Color(0xFF9CA3AF), // Gris
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No hay libros en la biblioteca",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFE5E7EB), // Casi blanco
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Presiona el botón + para agregar uno",
                    style: TextStyle(
                      color: Color(0xFF9CA3AF), // Gris
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          final libros = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: libros.length,
            itemBuilder: (context, index) {
              final libro = libros[index];
              return _buildLibroCard(libro);
            },
          );
        },
      ),
    );
  }

  Widget _buildLibroCard(Map<String, dynamic> libro) {
    return Card(
      elevation: 4,
      color: const Color(0xFF111827), // Surface
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ViewEditarLibro(libro: libro)),
          ).then((_) => _recargarLista());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Portada del libro
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewLeerLibro(libro: libro),
                    ),
                  );
                },
                child: Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child:
                      libro["portadaUrl"] != null &&
                          libro["portadaUrl"].isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            libro["portadaUrl"],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultCover();
                            },
                          ),
                        )
                      : _buildDefaultCover(),
                ),
              ),
              const SizedBox(width: 16),

              // Información del libro
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewLeerLibro(libro: libro),
                          ),
                        );
                      },
                      child: Text(
                        libro["titulo"] ?? "Sin título",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFFBBF24),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      libro["autor"] ?? "Autor desconocido",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${libro["anioPublicacion"] ?? "N/A"}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.category,
                          size: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            libro["categoria"] ?? "",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (libro["rating"] != null && libro["rating"] > 0)
                      Row(
                        children: [
                          ...List.generate(5, (i) {
                            return Icon(
                              i < (libro["rating"] ?? 0).floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: const Color(0xFFFBBF24),
                            );
                          }),
                          const SizedBox(width: 6),
                          Text(
                            "${libro["rating"]?.toStringAsFixed(1) ?? "0.0"}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFBBF24),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Text(
                      libro["descripcion"] ?? "",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9CA3AF),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Botones de acción (solo para administradores)
              if (_authService.isAdmin())
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFFFBBF24)),
                      iconSize: 22,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewEditarLibro(libro: libro),
                          ),
                        ).then((_) => _recargarLista());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFF38BDF8)),
                      iconSize: 22,
                      onPressed: () {
                        _confirmarEliminar(
                          libro["id"],
                          libro["titulo"] ?? "este libro",
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111827), Color(0xFF1F2937)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.menu_book, size: 40, color: Color(0xFFFBBF24)),
      ),
    );
  }
}
