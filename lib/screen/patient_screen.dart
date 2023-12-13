import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicaux_desktop/widget/patient_widget.dart';

import '../model/patient.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  Future<List<Patient>> fetchPatients() async {
    final response = await http.get(Uri.parse('http://localhost:8080/patient'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((i) => Patient.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Patients"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: fetchPatients(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              return Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return PatientWidget(patient: data[index]);
                  },
                ),
              );
            } else {
              return const Center(
                child: Text("There is no patients"),
              );
            }
          },
        ));
  }
}
