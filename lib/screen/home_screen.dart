import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/appointment.dart';
import '../widget/appointment_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int numDoc = 0;
  int numStaff = 0;
  int numPatient = 0;
  Future<int> numberOfDoctors() async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/doctor'),
    );
    return int.parse(response.body);
  }

  Future<int> numberOfStaff() async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/staff'),
    );
    return int.parse(response.body);
  }

  Future<int> numberOfPatient() async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/patient'),
    );
    return int.parse(response.body);
  }

  Future<List<Appointment>> fetchTodayAppointment() async {
    final response = await http.put(
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

  Future<void> refresh() async {
    setState(() {
      fetchTodayAppointment();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData().then((_) {
      setState(() {});
    });
  }

  Future<void> loadData() async {
    numDoc = await numberOfDoctors();
    numPatient = await numberOfPatient();
    numStaff = await numberOfStaff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "availble doctors",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const ImageIcon(
                                    AssetImage("assets/images/doctor.png")),
                                const SizedBox(width: 12),
                                Text("$numDoc",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "availble nurses",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const ImageIcon(AssetImage(
                                    "assets/images/doctor_staff.png")),
                                const SizedBox(width: 12),
                                Text("$numStaff",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "indoor patients",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.person, size: 30),
                                const SizedBox(width: 12),
                                Text("$numPatient",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Today's Appointment",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          FutureBuilder(
            future: fetchTodayAppointment(),
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
                  return Expanded(
                    child: Container(
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
        ],
      ),
    );
  }
}
