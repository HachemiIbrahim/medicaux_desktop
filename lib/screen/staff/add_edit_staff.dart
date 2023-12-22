import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../model/staff.dart';

class AddEditStaffScreen extends StatefulWidget {
  final Staff? staff;
  final Future<void> Function() refresher;

  const AddEditStaffScreen({super.key, this.staff, required this.refresher});

  @override
  State<AddEditStaffScreen> createState() => _AddEditStaffScreenState();
}

class _AddEditStaffScreenState extends State<AddEditStaffScreen> {
  Future<void> addStaff() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/staff'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'name': _name,
          'role': _role,
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

  Future<void> updateStaff() async {
    final response = await http.patch(
      Uri.parse('http://localhost:8080/staff/${widget.staff!.staffId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'name': _name,
          'role': _role,
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
  String _role = '';

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      _name = widget.staff!.name;
      _role = widget.staff!.role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.staff == null ? 'Add Staff' : 'Edit Staff'),
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
              initialValue: _role,
              decoration: InputDecoration(
                labelText: 'role',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a role';
                }
                return null;
              },
              onSaved: (value) {
                _role = value!;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (widget.staff == null) {
                    addStaff().then((_) {
                      Navigator.of(context).pop();
                      widget.refresher();
                    });
                  } else {
                    updateStaff().then((_) {
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
