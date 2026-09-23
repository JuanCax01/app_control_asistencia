import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../services/gps_service.dart';
import 'package:image_picker/image_picker.dart';

class AsistenciaView extends StatefulWidget {
  final String uidTrabajador;
  const AsistenciaView({super.key, required this.uidTrabajador});

  @override
  State<AsistenciaView> createState() => _AsistenciaViewState();
}

class _AsistenciaViewState extends State<AsistenciaView> {
  final DatabaseService _databaseService = DatabaseService();
  final _gpsService = GpsService();

  File? _fotoCapturada;
  String _tipoAsistencia = 'INGRESO';

  bool _estaVerificandoGps = false;
  bool _estaGuardando = false;
  bool _dentroDeGeocerca = false;

  double? _latitudActual;
  double? _longitudActual;
  double _distanciaSede = 0.0;

  @override
  void initState() {
    super.initState();
    _ejecutarValidacionGps(); // Valida el GPS automáticamente al abrir la pestaña
  }

  // Lógica combinada del GPS (Paso 9️⃣)
  Future<void> _ejecutarValidacionGps() async {
    setState(() => _estaVerificandoGps = true);

    bool permisosListos = await _gpsService.verificarPermisos();
    if (!permisosListos) {
      _notificar('Faltan permisos de ubicación en el equipo.', Colors.red);
      setState(() => _estaVerificandoGps = false);
      return;
    }

    try {
      final resultadoGps = await _gpsService.validarUbicacionActual();
      setState(() {
        _latitudActual = resultadoGps['latitud'];
        _longitudActual = resultadoGps['longitud'];
        _distanciaSede = resultadoGps['distancia'];
        _dentroDeGeocerca = resultadoGps['dentro_de_rango'];
      });
    } catch (e) {
      _notificar('Error al capturar coordenadas GPS.', Colors.red);
    } finally {
      setState(() => _estaVerificandoGps = false);
    }
  }

  // Lógica de la Cámara (Paso 8️⃣)
  Future<void> _capturarFotoRostro() async {
    final picker = ImagePicker();
    final foto = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40, // Optimiza el peso de la imagen para Firebase Storage
      preferredCameraDevice: CameraDevice.front, // Intenta abrir la cámara frontal
    );

    if (foto != null) {
      setState(() => _fotoCapturada = File(foto.path));
    }
  }

  // Enviar Todo al Backend Local (Paso 🔟)
  Future<void> _enviarMarcadoAsistencia() async {
    if (_fotoCapturada == null || _latitudActual == null) {
      _notificar('Falta capturar la foto o verificar la ubicación.', Colors.orange);
      return;
    }

    if (!_dentroDeGeocerca) {
      _notificar('Bloqueado: Estás fuera del rango perimetral permitido.', Colors.red);
      return;
    }

    setState(() => _estaGuardando = true);

    try {
      await _databaseService.guardarAsistencia(
        uid: widget.uidTrabajador,
        tipo: _tipoAsistencia,
        foto: _fotoCapturada!,
        latitud: _latitudActual!,
        longitud: _longitudActual!,
      );

      _notificar('¡Asistencia registrada exitosamente! ✅', Colors.green);

      setState(() {
        _fotoCapturada = null;
      });
      // Aquí podrás añadir más adelante la navegación a tu pantalla de Éxito
    } catch (e) {
      _notificar('Error en la red al guardar asistencia.', Colors.red);
    } finally {
      setState(() => _estaGuardando = false);
    }
  }

  void _notificar(String texto, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Marcado Biométrico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 🔄 SELECTOR DE ESTADO DE ASISTENCIA
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'INGRESO', label: Text('Entrada'), icon: Icon(Icons.login)),
                ButtonSegment(value: 'SALIDA', label: Text('Salida'), icon: Icon(Icons.logout)),
              ],
              selected: {_tipoAsistencia},
              onSelectionChanged: (val) => setState(() => _tipoAsistencia = val.first),
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: const Color(0xFF0F172A),
                selectedForegroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // 📷 CUADRO DE CAPTURA FACIAL (CÁMARA)
            GestureDetector(
              onTap: _capturarFotoRostro,
              child: Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _fotoCapturada != null ? Colors.green.shade300 : Colors.grey.shade300, width: 2),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: _fotoCapturada != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.file(_fotoCapturada!, fit: BoxFit.cover),
                )
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.face, size: 70, color: Colors.blue),
                    SizedBox(height: 12),
                    Text('Presiona para capturar rostro', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                    Text('Cámara frontal obligatoria', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 📍 PANEL DE ESTADO GEOCERCA (GPS)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Sede San Isidro', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        ],
                      ),
                      _estaVerificandoGps
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : IconButton(icon: const Icon(Icons.refresh, color: Colors.blue), onPressed: _ejecutarValidacionGps)
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Perímetro de marcado:', style: TextStyle(color: Color(0xFF475569))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _dentroDeGeocerca ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _dentroDeGeocerca ? 'PERMITIDO' : 'FUERA DE RANGO',
                          style: TextStyle(color: _dentroDeGeocerca ? Colors.green.shade700 : Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Distancia a la oficina:', style: TextStyle(color: Color(0xFF475569))),
                      Text('${_distanciaSede.toStringAsFixed(1)} metros', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // ✅ BOTÓN PRINCIPAL DE ENVÍO
            _estaGuardando
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _enviarMarcadoAsistencia,
              style: ElevatedButton.styleFrom(
                backgroundColor: _dentroDeGeocerca ? Colors.green.shade600 : Colors.grey.shade400,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Registrar asistencia ahora', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
