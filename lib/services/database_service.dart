import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Sube la fotografía a Firebase Storage y almacena los datos de la marcación en Firestore.
  Future<void> guardarAsistencia({
    required String uid,
    required String tipo,
    required File foto,
    required double latitud,
    required double longitud,
  }) async {
    try {
      DateTime ahora = DateTime.now();

      // 1. Definir un nombre único para el archivo basado en el UID y la marca de tiempo
      String nombreArchivo = '${uid}_${ahora.millisecondsSinceEpoch}.jpg';

      // 2. Subir la imagen a la carpeta 'asistencias' en Firebase Storage
      Reference ref = _storage.ref().child('asistencias/$nombreArchivo');
      UploadTask uploadTask = ref.putFile(foto);
      TaskSnapshot snapshot = await uploadTask;

      // 3. Obtener la URL de descarga de la foto subida
      String urlFoto = await snapshot.ref.getDownloadURL();

      // 4. Guardar el documento completo de la asistencia en Cloud Firestore
      await _db.collection('asistencias').add({
        'id_trabajador': uid,
        'fecha': '${ahora.year}-${ahora.month.toString().padLeft(2, '0')}-${ahora.day.toString().padLeft(2, '0')}',
        'hora': '${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}:${ahora.second.toString().padLeft(2, '0')}',
        'tipo': tipo, // 'INGRESO' o 'SALIDA'
        'foto': urlFoto,
        'geolocalizacion': GeoPoint(latitud, longitud), // Formato NoSQL nativo para mapas
        'direccion': 'Marcado desde App Móvil',
        'fecha_registro': Timestamp.fromDate(ahora), // Timestamp nativo de Firebase
      });
    } catch (e) {
      // Envía el error hacia la vista para que la interfaz muestre la alerta al usuario
      rethrow;
    }
  }
}
