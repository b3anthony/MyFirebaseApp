import 'package:cloud_firestore/cloud_firestore.dart';

class LibrosService {
  final CollectionReference librosRef = FirebaseFirestore.instance.collection(
    'libros',
  );

  /// 🟢 CREAR - Agregar un libro
  Future<void> agregarLibro({
    required String titulo,
    required String autor,
    required int anioPublicacion,
    required String categoria,
    required String descripcion,
    String? portadaUrl,
    double? rating,
    String? contenido,
  }) async {
    await librosRef.add({
      "titulo": titulo,
      "autor": autor,
      "anioPublicacion": anioPublicacion,
      "categoria": categoria,
      "descripcion": descripcion,
      "portadaUrl": portadaUrl ?? "",
      "rating": rating ?? 0.0,
      "contenido": contenido ?? "",
      "creadoEn": FieldValue.serverTimestamp(),
    });
  }

  /// LEER - Obtener TODOS los libros
  Future<List<Map<String, dynamic>>> obtenerLibros() async {
    final QuerySnapshot snapshot = await librosRef
        .orderBy('creadoEn', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return {"id": doc.id, ...doc.data() as Map<String, dynamic>};
    }).toList();
  }

  /// LEER - Obtener un libro por ID
  Future<Map<String, dynamic>?> obtenerLibroPorId(String id) async {
    final DocumentSnapshot doc = await librosRef.doc(id).get();

    if (doc.exists) {
      return {"id": doc.id, ...doc.data() as Map<String, dynamic>};
    }
    return null;
  }

  /// ACTUALIZAR - Modificar un libro existente
  Future<void> actualizarLibro({
    required String id,
    required String titulo,
    required String autor,
    required int anioPublicacion,
    required String categoria,
    required String descripcion,
    String? portadaUrl,
    double? rating,
    String? contenido,
  }) async {
    await librosRef.doc(id).update({
      "titulo": titulo,
      "autor": autor,
      "anioPublicacion": anioPublicacion,
      "categoria": categoria,
      "descripcion": descripcion,
      "portadaUrl": portadaUrl ?? "",
      "rating": rating ?? 0.0,
      "contenido": contenido ?? "",
      "actualizadoEn": FieldValue.serverTimestamp(),
    });
  }

  /// ELIMINAR - Borrar un libro
  Future<void> eliminarLibro(String id) async {
    await librosRef.doc(id).delete();
  }

  /// Stream para actualizaciones en tiempo real (opcional)
  Stream<List<Map<String, dynamic>>> obtenerLibrosStream() {
    return librosRef.orderBy('creadoEn', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return {"id": doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    });
  }
}
