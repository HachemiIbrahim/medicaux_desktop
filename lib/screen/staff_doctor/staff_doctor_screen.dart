import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicaux_desktop/model/staff_doctor.dart';
import 'package:medicaux_desktop/screen/staff_doctor/add_staff_doctor.dart';
import 'package:medicaux_desktop/widget/staff_doctor_widget.dart';

class DoctorStaffScreen extends StatefulWidget {
  const DoctorStaffScreen({super.key});

  @override
  State<DoctorStaffScreen> createState() => _DoctorStaffScreenState();
}

class _DoctorStaffScreenState extends State<DoctorStaffScreen> {
  Future<void> refresh() async {
    setState(() {
      fetchDoctorStaff();
    });
  }

  Future<void> addDoctorStaff() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: AddEditDoctorStaff(refresher: refresh),
        );
      },
    );
  }

  Future<List<DoctorStaff>> fetchDoctorStaff() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/doctor_staff'),
    );
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((i) => DoctorStaff.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load Doctor Staff');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Staff"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                addDoctorStaff();
              },
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchDoctorStaff(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data;
            if (data!.isEmpty) {
              return const Center(
                child: Text("There is no Doctor Staff"),
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return DoctorStaffWidget(
                      doctorStaff: data[index],
                      refresher: refresh,
                    );
                  },
                ),
              );
            }
          } else {
            return const Center(
              child: Text("There is no Doctor Staff"),
            );
          }
        },
      ),
    );
  }
}
