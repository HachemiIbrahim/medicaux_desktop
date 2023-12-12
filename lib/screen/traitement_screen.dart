import 'package:flutter/material.dart';

class TraitementScreen extends StatefulWidget {
  const TraitementScreen({super.key});

  @override
  State<TraitementScreen> createState() => _TraitementScreenState();
}

class _TraitementScreenState extends State<TraitementScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Traitement'),
    );
  }
}
