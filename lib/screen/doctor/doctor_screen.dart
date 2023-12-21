import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medicaux_desktop/screen/doctor/add_edit_doctor.dart';
import 'package:medicaux_desktop/widget/doctor_widget.dart';

import '../../model/doctor.dart';
import 'package:http/http.dart' as http;

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  Future<void> addDoctor() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: AddEditDoctorScreen(refresher: refresh),
        );
      },
    );
  }

  Future<void> refresh() async {
    setState(() {
      fetchDoctor();
    });
  }

  Future<List<Doctor>> fetchDoctor() async {
    final response = await http.get(Uri.parse('http://localhost:8080/doctor'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((i) => Doctor.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load Doctors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctors"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                addDoctor();
              },
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchDoctor(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data;
            if (data!.isEmpty) {
              return const Center(
                child: Text("There is no Doctors"),
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return DoctorWidget(
                      doctor: data[index],
                      refresher: refresh,
                    );
                  },
                ),
              );
            }
          } else {
            return const Center(
              child: Text("There is no Doctors"),
            );
          }
        },
      ),
    );
  }
}
