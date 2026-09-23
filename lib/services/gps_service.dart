import 'package:geolocator/geolocator.dart';

class GpsService {
  // Coordenadas de tu Sede Central según tu pantalla (Av. Javier Prado Este 4200)
  final double sedeLatitud = -12.09312;
  final double sedeLongitud = -77.02844;
  final double radioPermitidoMetros = 50.0; // Geocerca de 50 metros

  // 1. Verificar y solicitar permisos de GPS
  Future<bool> verificarPermisos() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  // 2. Obtener posición y validar si está en la oficina
  Future<Map<String, dynamic>> validarUbicacionActual() async {
    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Fórmula matemática nativa de Flutter para calcular distancia en metros
    double distanciaMetros = Geolocator.distanceBetween(
        pos.latitude, pos.longitude, sedeLatitud, sedeLongitud
    );

    return {
      'latitud': pos.latitude,
      'longitud': pos.longitude,
      'distancia': distanciaMetros,
      'dentro_de_rango': distanciaMetros <= radioPermitidoMetros,
    };
  }
}
