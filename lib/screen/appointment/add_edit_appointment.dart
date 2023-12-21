import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medicaux_desktop/model/appointment.dart';
import 'package:http/http.dart' as http;
import '../../model/doctor.dart';
import '../../model/patient.dart';

class AddEditAppointment extends StatefulWidget {
  final Appointment? appointment;
  final Future<void> Function() refresher;
  const AddEditAppointment(
      {super.key, this.appointment, required this.refresher});

  @override
  State<AddEditAppointment> createState() => _AddEditAppointmentState();
}

class _AddEditAppointmentState extends State<AddEditAppointment> {
  List<Patient> patients = [];
  List<Doctor> doctors = [];
  String _selectedPatient = "";
  String _selectedDoctor = "";
  String _selectedDate = "";
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPatients().then((value) => setState(() {
          patients = value;
        }));
    fetchDoctor().then((value) => setState(() {
          doctors = value;
        }));
    if (widget.appointment != null) {
      _dateController.text = widget.appointment!.appointment_date;
      _selectedPatient = widget.appointment!.patientName;
      _selectedDoctor = widget.appointment!.doctorName;
      _selectedDate = widget.appointment!.appointment_date;
    }
  }

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
        title: Text(widget.appointment != null
            ? 'Edit Appointment'
            : 'Add Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              color: widget.appointment != null ? Colors.grey[-1] : null,
              child: Autocomplete<Doctor>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (widget.appointment != null ||
                      textEditingValue.text == '') {
                    return const Iterable<Doctor>.empty();
                  }
                  return doctors.where((Doctor doctor) {
                    return doctor.name
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                initialValue: widget.appointment != null
                    ? TextEditingValue(
                        text: doctors
                            .firstWhere(
                              (Doctor doctor) =>
                                  doctor.name == widget.appointment!.doctorName,
                            )
                            .name)
                    : null,
                displayStringForOption: (Doctor option) => option.name,
                onSelected: (Doctor selection) {
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
              color: widget.appointment != null ? Colors.grey[-1] : null,
              child: Autocomplete<Patient>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (widget.appointment != null ||
                      textEditingValue.text == '') {
                    return const Iterable<Patient>.empty();
                  }
                  return patients.where((Patient patient) {
                    return patient.name
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                initialValue: widget.appointment != null
                    ? TextEditingValue(
                        text: patients
                            .firstWhere(
                              (Patient patient) =>
                                  patient.name ==
                                  widget.appointment!.patientName,
                            )
                            .name)
                    : null,
                displayStringForOption: (Patient option) => option.name,
                onSelected: (Patient selection) {
                  setState(() {
                    _selectedPatient = selection.name;
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
                      hintText: 'Select a patient',
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
                labelText: 'Appointment Date',
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
                              primary:
                                  Colors.deepPurpleAccent, // body text color
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
                // Handle appointment creation here.
              },
              child: Text(widget.appointment != null ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
