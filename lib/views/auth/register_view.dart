import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/bottom_nav_bar.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _authService = AuthService();

  final _dniController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _cargoController = TextEditingController();
  final _telefonoController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _ejecutarRegistro() async {
    if (_dniController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nombresController.text.isEmpty ||
        _apellidosController.text.isEmpty) {
      _notificar('Por favor, rellene los campos obligatorios.', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.registrarTrabajador(
        dni: _dniController.text.trim(),
        password: _passwordController.text.trim(),
        nombres: _nombresController.text.trim(),
        apellidos: _apellidosController.text.trim(),
        cargo: _cargoController.text.trim(),
        telefono: _telefonoController.text.trim(),
      );

      if (user != null && mounted) {
        _notificar('¡Cuenta corporativa creada con éxito! 🎉', Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavBar(uidTrabajador: user.uid)),
        );
      }
    } on Exception catch (e) {
      // 🚨 ESTO ES CLAVE: Pintará el motivo real en tu pestaña Run/Terminal abajo
      print("❌ ERROR REAL DE COMPILACIÓN: $e");

      if (mounted) {
        _notificar('Error interno: $e', Colors.red);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  void _notificar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Registro de Empleado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), backgroundColor: Colors.white, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 8))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField('Nombres *', _nombresController, Icons.person_outline, TextInputType.text),
                    const SizedBox(height: 16),
                    _buildInputField('Apellidos *', _apellidosController, Icons.people_outline, TextInputType.text),
                    const SizedBox(height: 16),
                    _buildInputField('DNI / Código *', _dniController, Icons.badge_outlined, TextInputType.number),
                    const SizedBox(height: 16),
                    _buildInputField('Cargo / Puesto', _cargoController, Icons.work_outline, TextInputType.text),
                    const SizedBox(height: 16),
                    _buildInputField('Teléfono', _telefonoController, Icons.phone_android_outlined, TextInputType.phone),
                    const SizedBox(height: 16),

                    const Text('Contraseña de acceso *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Mínimo 6 caracteres',
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
                    const SizedBox(height: 30),

                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: _ejecutarRegistro,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white, minimumSize: const Size.fromHeight(56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: const Text('Registrar y Vincular Cuenta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildInputField(String label, TextEditingController controller, IconData icon, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
