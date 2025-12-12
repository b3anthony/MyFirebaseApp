import 'package:flutter/material.dart';

class ViewLeerLibro extends StatefulWidget {
  final Map<String, dynamic> libro;

  const ViewLeerLibro({super.key, required this.libro});

  @override
  State<ViewLeerLibro> createState() => _ViewLeerLibroState();
}

class _ViewLeerLibroState extends State<ViewLeerLibro> {
  final ScrollController _scrollController = ScrollController();
  double _fontSize = 18.0;
  bool _showControls = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    final contenido =
        widget.libro["contenido"] ??
        "No hay contenido disponible para este libro.";

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: _showControls
          ? AppBar(
              backgroundColor: const Color(0xFF111827),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFFE5E7EB)),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                widget.libro["titulo"] ?? "Sin título",
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Color(0xFFE5E7EB)),
                  onPressed: () {
                    setState(() {
                      if (_fontSize > 12) _fontSize -= 2;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFFE5E7EB)),
                  onPressed: () {
                    setState(() {
                      if (_fontSize < 32) _fontSize += 2;
                    });
                  },
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Container(
          color: const Color(0xFF020617),
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del libro (solo visible con controles)
                if (_showControls) ...[
                  Center(
                    child: Column(
                      children: [
                        if (widget.libro["portadaUrl"] != null &&
                            widget.libro["portadaUrl"].toString().isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.libro["portadaUrl"],
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _buildDefaultCover(),
                            ),
                          )
                        else
                          _buildDefaultCover(),
                        const SizedBox(height: 24),
                        Text(
                          widget.libro["titulo"] ?? "Sin título",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.libro["autor"] ?? "Autor desconocido",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF9CA3AF),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.grey[800]),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],

                // Contenido del libro
                SelectableText(
                  contenido,
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: const Color(0xFFE5E7EB),
                    height: 1.8,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _showControls
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFFBBF24),
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.arrow_upward, color: Color(0xFF020617)),
            )
          : null,
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      height: 200,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111827), Color(0xFF1F2937)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.menu_book, size: 60, color: Color(0xFFFBBF24)),
      ),
    );
  }
}
