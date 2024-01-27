import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicaux_desktop/model/staff.dart';
import '../../model/doctor.dart';
import '../../model/patient.dart';

class AddEditDoctorStaff extends StatefulWidget {
  final Future<void> Function() refresher;
  const AddEditDoctorStaff({super.key, required this.refresher});

  @override
  State<AddEditDoctorStaff> createState() => _AddEditDoctorStaffState();
}

class _AddEditDoctorStaffState extends State<AddEditDoctorStaff> {
  Future<void> addDoctorStaff() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/doctor_staff'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'staffId': staff.staffId.toString(),
          'doctorId': doctor.doctorId.toString(),
          'assignmentDate': _selectedDate
        },
      ),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("appointment created successfully"),
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

  List<Staff> staffs = [];
  List<Doctor> doctors = [];
  late Doctor doctor;
  late Staff staff;

  String _selectedStaff = "";
  String _selectedDoctor = "";
  String _selectedDate = "";
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStaff().then((value) => setState(() {
          staffs = value;
        }));
    fetchDoctor().then((value) => setState(() {
          doctors = value;
        }));
  }

  Future<List<Staff>> fetchStaff() async {
    final response = await http.get(Uri.parse('http://localhost:8080/staff'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((i) => Staff.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load staff');
    }
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
        title: const Text('Assign Staff'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Autocomplete<Doctor>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return doctors.where((Doctor doctor) {
                    return doctor.name
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                initialValue: null,
                displayStringForOption: (Doctor option) => option.name,
                onSelected: (Doctor selection) {
                  doctor = selection;
                  setState(() {
                    _selectedDoctor = selection.name;
                  });
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Select a doctor',
                      contentPadding: const EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              child: Autocomplete<Staff>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return staffs.where((Staff staff) {
                    return staff.name
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                initialValue: null,
                displayStringForOption: (Staff option) => option.name,
                onSelected: (Staff selection) {
                  staff = selection;
                  setState(() {
                    _selectedStaff = selection.name;
                  });
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Select a staff',
                      contentPadding: const EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _dateController,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2050),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors.deepPurpleAccent,
                        colorScheme: const ColorScheme.light(
                          primary: Colors.deepPurpleAccent, // body text color
                        ).copyWith(secondary: Colors.deepPurpleAccent),
                      ),
                      child: child!,
                    );
                  },
                );
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors.deepPurpleAccent,
                        colorScheme: const ColorScheme.light(
                          primary: Colors.deepPurpleAccent, // body text color
                        ).copyWith(secondary: Colors.deepPurpleAccent),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null && pickedTime != null) {
                  setState(() {
                    _selectedDate =
                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day} ${pickedTime.hour}:${pickedTime.minute}";
                    _dateController.text = _selectedDate;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Assignment Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2050),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors.deepPurpleAccent,
                            ).copyWith(secondary: Colors.deepPurpleAccent),
                          ),
                          child: child!,
                        );
                      },
                    );
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.deepPurpleAccent,
                            colorScheme: const ColorScheme.light(
                              primary: Colors.deepPurpleAccent,
                            ).copyWith(secondary: Colors.deepPurpleAccent),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null && pickedTime != null) {
                      setState(() {
                        _selectedDate =
                            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day} ${pickedTime.hour}:${pickedTime.minute}";
                        _dateController.text = _selectedDate;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                addDoctorStaff().then((_) {
                  Navigator.of(context).pop();
                  widget.refresher();
                });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
