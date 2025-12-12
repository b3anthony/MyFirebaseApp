import 'package:flutter/material.dart';
import 'package:my_firebase_app/Servicios/LibrosServicio.dart';

class ViewEditarLibro extends StatefulWidget {
  final Map<String, dynamic> libro;

  const ViewEditarLibro({super.key, required this.libro});

  @override
  State<ViewEditarLibro> createState() => _ViewEditarLibroState();
}

class _ViewEditarLibroState extends State<ViewEditarLibro> {
  final LibrosService _service = LibrosService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _anioController;
  late TextEditingController _categoriaController;
  late TextEditingController _descripcionController;
  late TextEditingController _portadaUrlController;
  late TextEditingController _ratingController;
  late TextEditingController _contenidoController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con los valores actuales
    _tituloController = TextEditingController(
      text: widget.libro["titulo"] ?? "",
    );
    _autorController = TextEditingController(text: widget.libro["autor"] ?? "");
    _anioController = TextEditingController(
      text: widget.libro["anioPublicacion"]?.toString() ?? "",
    );
    _categoriaController = TextEditingController(
      text: widget.libro["categoria"] ?? "",
    );
    _descripcionController = TextEditingController(
      text: widget.libro["descripcion"] ?? "",
    );
    _portadaUrlController = TextEditingController(
      text: widget.libro["portadaUrl"] ?? "",
    );
    _ratingController = TextEditingController(
      text: widget.libro["rating"]?.toString() ?? "",
    );
    _contenidoController = TextEditingController(
      text: widget.libro["contenido"] ?? "",
    );
  }

  Future<void> _actualizarLibro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _service.actualizarLibro(
        id: widget.libro["id"],
        titulo: _tituloController.text.trim(),
        autor: _autorController.text.trim(),
        anioPublicacion: int.parse(_anioController.text),
        categoria: _categoriaController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        portadaUrl: _portadaUrlController.text.trim().isNotEmpty
            ? _portadaUrlController.text.trim()
            : null,
        rating: _ratingController.text.isNotEmpty
            ? double.parse(_ratingController.text)
            : null,
        contenido: _contenidoController.text.trim().isNotEmpty
            ? _contenidoController.text.trim()
            : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Libro actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text(
          'Editar Libro',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: const Color(0xFF111827),
        iconTheme: const IconThemeData(color: Color(0xFFE5E7EB)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título del libro
              _buildTextField(
                controller: _tituloController,
                label: 'Título del Libro',
                icon: Icons.menu_book,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el título del libro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Autor
              _buildTextField(
                controller: _autorController,
                label: 'Autor',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el nombre del autor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Año de publicación
              _buildTextField(
                controller: _anioController,
                label: 'Año de Publicación',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el año de publicación';
                  }
                  final anio = int.tryParse(value);
                  if (anio == null ||
                      anio < 1000 ||
                      anio > DateTime.now().year) {
                    return 'Ingrese un año válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Categoría
              _buildTextField(
                controller: _categoriaController,
                label: 'Categoría',
                icon: Icons.category,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descripción
              _buildTextField(
                controller: _descripcionController,
                label: 'Descripción',
                icon: Icons.description,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contenido del libro (opcional)
              _buildTextField(
                controller: _contenidoController,
                label: 'Contenido del Libro (opcional)',
                icon: Icons.article,
                maxLines: 10,
                hint: 'Escriba o pegue el texto completo del libro aquí...',
              ),
              const SizedBox(height: 16),

              // URL de la portada (opcional)
              _buildTextField(
                controller: _portadaUrlController,
                label: 'URL de la Portada (opcional)',
                icon: Icons.image,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              // Rating (opcional)
              _buildTextField(
                controller: _ratingController,
                label: 'Rating (0.0 - 5.0, opcional)',
                icon: Icons.star,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final rating = double.tryParse(value);
                    if (rating == null || rating < 0 || rating > 5) {
                      return 'Ingrese un rating entre 0.0 y 5.0';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Botón de actualizar
              ElevatedButton(
                onPressed: _isLoading ? null : _actualizarLibro,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFFBBF24),
                  foregroundColor: const Color(0xFF020617),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
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
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.update),
                          SizedBox(width: 8),
                          Text(
                            'Actualizar Libro',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
        prefixIcon: Icon(icon, color: const Color(0xFFFBBF24)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFBBF24), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFF111827),
      ),
      style: const TextStyle(color: Color(0xFFE5E7EB)),
      cursorColor: const Color(0xFFFBBF24),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _anioController.dispose();
    _categoriaController.dispose();
    _descripcionController.dispose();
    _portadaUrlController.dispose();
    _ratingController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }
}
