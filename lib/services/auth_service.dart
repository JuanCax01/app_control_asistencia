import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Login normal por DNI corporativo
  Future<User?> loginConDni(String dni, String password) async {
    try {
      String correoSintetico = "$dni@asistencia.com";
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: correoSintetico,
          password: password
      );
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Autenticación Biométrica Local
  Future<bool> autenticarConBiometria() async {
    try {
      bool puedeCheckear = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      if (!puedeCheckear) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Escanee su huella o rostro para ingresar al portal',
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Autenticación Biométrica',
            cancelButton: 'Cancelar',
          ),
        ],
      );
    } catch (e) {
      return false;
    }
  }

  /// Registra un nuevo trabajador en Firebase Auth y crea su documento en Firestore
  Future<User?> registrarTrabajador({
    required String dni,
    required String password,
    required String nombres,
    required String apellidos,
    required String cargo,
    required String telefono,
  }) async {
    try {
      String correoSintetico = "$dni@asistencia.com";

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: correoSintetico,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await _db.collection('trabajadores').doc(user.uid).set({
          'uid': user.uid,
          'dni': dni,
          'nombres': nombres,
          'apellidos': apellidos,
          'cargo': cargo,
          'telefono': telefono,
          'correo': correoSintetico,
          'id_rol': 'empleado',
          'estado': true,
          'foto_perfil': '',
          'fecha_registro': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
