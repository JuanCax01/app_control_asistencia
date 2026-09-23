import 'package:flutter/material.dart';
class InicioView extends StatelessWidget {
  final String uidTrabajador;
  const InicioView({super.key, required this.uidTrabajador});
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Vista Inicio')));
}
