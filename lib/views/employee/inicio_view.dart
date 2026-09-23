import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InicioView extends StatelessWidget {
  final String uidTrabajador;
  const InicioView({super.key, required this.uidTrabajador});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Fondo claro corporativo
      appBar: AppBar(
        title: const Text('Panel de Control', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Mensaje de Bienvenida Estilizado
            const Text(
              '¡Bienvenido de vuelta!',
              style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            const Text(
              'Portal del Empleado',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 24),

            // ⏱️ CARD DE ESTADO DE JORNADA (PANEL DIARIO)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A), // Azul/Negro pizarra oscuro corporativo
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estado actual:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: const Text('PENDIENTE', style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Jornada de Hoy', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.white24, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusIndicator(Icons.login, 'Ingreso', '--:--'),
                      _buildStatusIndicator(Icons.logout, 'Salida', '--:--'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 📊 RESUMEN SEMANAL / HISTORIAL CORTO
            const Text(
              'Resumen Semanal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 16),

            // Lista estática que simula el historial que tienes en tu maqueta
            _buildHistoryItem('Lunes 21 de Septiembre', '08:02 AM', '05:15 PM', 'Puntual', Colors.green),
            _buildHistoryItem('Viernes 18 de Septiembre', '08:14 AM', '05:03 PM', 'Tardanza', Colors.red),
            _buildHistoryItem('Jueves 17 de Septiembre', '07:58 AM', '05:00 PM', 'Puntual', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(IconData icon, String label, String time) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(time, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Widget _buildHistoryItem(String fecha, String ingreso, String salida, String estado, Color colorEstado) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fecha, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.login, size: 14, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(ingreso, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(width: 12),
                  Icon(Icons.logout, size: 14, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(salida, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: colorEstado.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(estado, style: TextStyle(color: colorEstado, fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
