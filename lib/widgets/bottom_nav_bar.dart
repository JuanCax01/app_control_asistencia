import 'package:flutter/material.dart';
import '../views/employee/inicio_view.dart';
import '../views/employee/asistencia_view.dart';
import '../views/history/historial_view.dart';
import '../views/profile/perfil_view.dart';

class BottomNavBar extends StatefulWidget {
  final String uidTrabajador;
  const BottomNavBar({super.key, required this.uidTrabajador});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  // Lista de pantallas ordenadas según el menú inferior de tu diseño
  late final List<Widget> _pantallas;

  @override
  void initState() {
    super.initState();
    _pantallas = [
      InicioView(uidTrabajador: widget.uidTrabajador),
      AsistenciaView(uidTrabajador: widget.uidTrabajador),
      HistorialView(uidTrabajador: widget.uidTrabajador),
      PerfilView(uidTrabajador: widget.uidTrabajador),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pantallas, // Mantiene vivo el estado de las vistas al cambiar de pestaña
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF1E3A8A).withOpacity(0.1), // Azul tenue corporativo
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.home, color: Color(0xFF1E3A8A)),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.fingerprint_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.fingerprint, color: Color(0xFF1E3A8A)),
            label: 'Asistencia',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.calendar_month, color: Color(0xFF1E3A8A)),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.person, color: Color(0xFF1E3A8A)),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
