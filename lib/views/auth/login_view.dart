import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
final _dniController = TextEditingController();
final _passwordController = TextEditingController();
final _authService = AuthService();

bool _obscurePassword = true;
bool _rememberMe = true;
bool _isLoading = false;

Future<void> _procesarLogin() async {
if (_dniController.text.isEmpty || _passwordController.text.isEmpty) {
_mostrarAlerta('Por favor, ingresa tus credenciales.', Colors.orange);
return;
}

setState(() => _isLoading = true);

try {
final user = await _authService.loginConDni(
_dniController.text.trim(),
_passwordController.text.trim(),
);

if (user != null && mounted) {
Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) => BottomNavBar(uidTrabajador: user.uid),
),
);
}
} catch (e) {
if (mounted) {
_mostrarAlerta('DNI o contraseña incorrectos. Verifica tus datos.', Colors.red);
}
} finally {
if (mounted) setState(() => _isLoading = false);
}
}

Future<void> _procesarBiometria() async {
bool exito = await _authService.autenticarConBiometria();
if (exito && mounted) {
_mostrarAlerta('Autenticación biométrica exitosa', Colors.green);
} else if (mounted) {
_mostrarAlerta('No se pudo verificar la identidad biométrica.', Colors.red);
}
}

void _mostrarAlerta(String mensaje, Color color) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(mensaje),
backgroundColor: color,
behavior: SnackBarBehavior.floating,
),
);
}

@override
void dispose() {
_dniController.dispose();
_passwordController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF8FAFC),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
child: Column(
children: [
const SizedBox(height: 20),
Center(
child: Container(
padding: const EdgeInsets.all(16),
decoration: const BoxDecoration(
color: Colors.white,
shape: BoxShape.circle,
boxShadow: [
BoxShadow(
color: Colors.black12,
blurRadius: 10,
offset: Offset(0, 4),
)
],
),
child: const Icon(Icons.shield, size: 50, color: Color(0xFF0F172A)),
),
),
const SizedBox(height: 24),

const Text(
'Control de Asistencia',
style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
),
const SizedBox(height: 6),
const Text(
'Portal del Empleado y Registro Biométrico',
style: TextStyle(fontSize: 15, color: Colors.grey),
),
const SizedBox(height: 16),

Container(
padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
decoration: BoxDecoration(
color: const Color(0xFFEFF6FF),
borderRadius: BorderRadius.circular(20),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Container(
width: 8,
height: 8,
decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
),
const SizedBox(width: 8),
const Text(
'SISTEMA OPERATIVO CONECTADO',
style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
),
],
),
),
const SizedBox(height: 30),

Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(24),
boxShadow: const [
BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 8))
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: const [
Text('Usuario / DNI / Código', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155))),
Text('Obligatorio', style: TextStyle(color: Colors.blue, fontSize: 12)),
],
),
const SizedBox(height: 8),
TextField(
controller: _dniController,
keyboardType: TextInputType.number,
decoration: InputDecoration(
hintText: 'Ej. 74839201',
prefixIcon: const Icon(Icons.badge_outlined),
filled: true,
fillColor: const Color(0xFFF8FAFC),
border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
),
),
const SizedBox(height: 20),

const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155))),
const SizedBox(height: 8),
TextField(
controller: _passwordController,
obscureText: _obscurePassword,
decoration: InputDecoration(
hintText: '••••••••••••',
prefixIcon: const Icon(Icons.lock_outline),
suffixIcon: IconButton(
icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
),
filled: true,
fillColor: const Color(0xFFF8FAFC),
border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
),
),
const SizedBox(height: 16),

Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Row(
children: [
SizedBox(
width: 24,
height: 24,
child: Checkbox(
value: _rememberMe,
onChanged: (val) => setState(() => _rememberMe = val!),
activeColor: Colors.blue,
),
),
const SizedBox(width: 8),
const Text('Recordar equipo', style: TextStyle(color: Color(0xFF475569), fontSize: 13)),
],
),
TextButton(
onPressed: () {},
style: TextButton.styleFrom(padding: EdgeInsets.zero),
child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
)
],
),
const SizedBox(height: 20),

_isLoading
? const Center(child: CircularProgressIndicator())
: ElevatedButton(
onPressed: _procesarLogin,
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFF0F172A),
foregroundColor: Colors.white,
minimumSize: const Size.fromHeight(56),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
elevation: 0,
),
child: const Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text('Iniciar sesión', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
SizedBox(width: 8),
Icon(Icons.arrow_forward, size: 18),
],
),
),
const SizedBox(height: 16),

OutlinedButton.icon(
onPressed: _procesarBiometria,
icon: const Icon(Icons.fingerprint, color: Colors.blue),
  label: const Text('Acceder con Huella o FaceID', style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w600)),style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(54),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),side: BorderSide(color: Colors.grey.shade200),),),const SizedBox(height: 20),Row(mainAxisAlignment: MainAxisAlignment.center,children: [const Text('¿Nuevo en la empresa? ', style: TextStyle(color: Color(0xFF475569), fontSize: 13)),GestureDetector(onTap: () {Navigator.push(context,MaterialPageRoute(builder: (context) => const RegisterView()),);},child: const Text('Regístrate aquí',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13),),),],),],),),const SizedBox(height: 24),Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),decoration: BoxDecoration(color: const Color(0xFFF1F5F9),borderRadius: BorderRadius.circular(16),),child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Row(children: const [Icon(Icons.admin_panel_settings_outlined, color: Color(0xFF475569)),SizedBox(width: 12),Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Text('¿Eres administrador?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),Text('Acceso a panel de supervisores', style: TextStyle(fontSize: 12, color: Colors.grey)),],)],),TextButton(onPressed: () {},child: const Row(children: [Text('Ingresar', style: TextStyle(fontWeight: FontWeight.bold)),Icon(Icons.chevron_right, size: 16),],),)],),),const SizedBox(height: 24),const Text('🔒 Conexión cifrada TLS 256-bit', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),const Text('v2.4.0 Empresarial • Conexión Segura', style: TextStyle(fontSize: 11, color: Colors.grey)),const SizedBox(height: 20),],),),),);}}