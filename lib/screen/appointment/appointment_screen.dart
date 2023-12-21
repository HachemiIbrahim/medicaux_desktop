import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medicaux_desktop/model/appointment.dart';
import 'package:http/http.dart' as http;
import 'package:medicaux_desktop/screen/appointment/add_edit_appointment.dart';
import 'package:medicaux_desktop/widget/appointment_widget.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  Future<void> refresh() async {
    setState(() {
      fetchAppointment();
    });
  }

  Future<void> addAppointment() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: AddEditAppointment(refresher: refresh),
        );
      },
    );
  }

  Future<List<Appointment>> fetchAppointment() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/appointment'),
    );
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((i) => Appointment.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load Appointment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                addAppointment();
              },
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchAppointment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data;
            if (data!.isEmpty) {
              return const Center(
                child: Text("There is no Appointments"),
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return AppointmentWidget(
                      appointment: data[index],
                      refresher: refresh,
                    );
                  },
                ),
              );
            }
          } else {
            return const Center(
              child: Text("There is no Appointments"),
            );
          }
        },
      ),
    );
  }
}
