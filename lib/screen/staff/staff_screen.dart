import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medicaux_desktop/model/staff.dart';
import 'package:medicaux_desktop/screen/staff/add_edit_staff.dart';
import 'package:medicaux_desktop/widget/staff_widget.dart';

import 'package:http/http.dart' as http;

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  Future<void> addDoctor() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: AddEditStaffScreen(refresher: refresh),
        );
      },
    );
  }

  Future<void> refresh() async {
    setState(() {
      fetchStaff();
    });
  }

  Future<List<Staff>> fetchStaff() async {
    final response = await http.get(Uri.parse('http://localhost:8080/staff'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((i) => Staff.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load Staff members');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff"),
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
        future: fetchStaff(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data;
            if (data!.isEmpty) {
              return const Center(
                child: Text("There is no Staff"),
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return StaffWidget(
                      staff: data[index],
                      refresher: refresh,
                    );
                  },
                ),
              );
            }
          } else {
            return const Center(
              child: Text("There is no Staff"),
            );
          }
        },
      ),
    );
  }
}
