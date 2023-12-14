import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:medicaux_desktop/model/doctor.dart';
import 'package:http/http.dart' as http;

class AddEditDoctorScreen extends StatefulWidget {
  final Doctor? doctor;
  final Future<void> Function() refresher;

  const AddEditDoctorScreen({super.key, this.doctor, required this.refresher});

  @override
  State<AddEditDoctorScreen> createState() => _AddEditDoctorScreenState();
}

class _AddEditDoctorScreenState extends State<AddEditDoctorScreen> {
  Future<void> addDoctor() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/doctor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'name': _name,
          'speciality': _speciality,
        },
      ),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("doctor created successfully"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("an error happened"),
        ),
      );
    }
  }

  Future<void> updateDoctor() async {
    final response = await http.patch(
      Uri.parse('http://localhost:8080/doctor/${widget.doctor!.doctorId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'name': _name,
          'speciality': _speciality,
        },
      ),
    );

    if (response.statusCode == 202) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("doctor updated successfully"),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("an error happened"),
        ),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _speciality = '';

  @override
  void initState() {
    super.initState();
    if (widget.doctor != null) {
      _name = widget.doctor!.name;
      _speciality = widget.doctor!.speciality;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctor == null ? 'Add Doctor' : 'Edit Doctor'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              initialValue: _speciality,
              decoration: InputDecoration(
                labelText: 'speciality',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a speciality';
                }
                return null;
              },
              onSaved: (value) {
                _speciality = value!;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (widget.doctor == null) {
                    addDoctor().then((_) {
                      Navigator.of(context).pop();
                      widget.refresher();
                    });
                  } else {
                    updateDoctor().then((_) {
                      Navigator.of(context).pop();
                      widget.refresher();
                    });
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
