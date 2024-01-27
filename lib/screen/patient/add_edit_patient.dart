import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:medicaux_desktop/model/patient.dart';
import 'package:http/http.dart' as http;

class AddEditPatientScreen extends StatefulWidget {
  final Patient? patient;
  final Future<void> Function() refresher;

  const AddEditPatientScreen(
      {super.key, this.patient, required this.refresher});

  @override
  State<AddEditPatientScreen> createState() => _AddEditPatientScreenState();
}

class _AddEditPatientScreenState extends State<AddEditPatientScreen> {
  Future<void> addPatient() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/patient'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'name': _name,
          'age': _age.toString(),
          'phoneNumber': _phoneNumber
        },
      ),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("patient created successfully"),
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

  Future<void> updatePatient() async {
    final response = await http.patch(
      Uri.parse('http://localhost:8080/patient/${widget.patient!.patientId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'name': _name,
          'age': _age.toString(),
          'phoneNumber': _phoneNumber
        },
      ),
    );

    if (response.statusCode == 202) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("patient updated successfully"),
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
  int _age = 0;
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    if (widget.patient != null) {
      _name = widget.patient!.name;
      _age = widget.patient!.age;
      _phoneNumber = widget.patient!.phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient == null ? 'Add Patient' : 'Edit Patient'),
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
              initialValue: _age == 0 ? "" : _age.toString(),
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an age';
                }
                return null;
              },
              onSaved: (value) {
                _age = int.parse(value!);
              },
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              initialValue: _phoneNumber,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
              onSaved: (value) {
                _phoneNumber = value!;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (widget.patient == null) {
                    addPatient().then((_) {
                      Navigator.of(context).pop();
                      widget.refresher();
                    });
                  } else {
                    updatePatient().then((_) {
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
