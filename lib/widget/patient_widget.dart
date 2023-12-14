import 'package:flutter/material.dart';
import 'package:medicaux_desktop/model/patient.dart';
import 'package:http/http.dart' as http;
import 'package:medicaux_desktop/screen/add_edit_patient.dart';

class PatientWidget extends StatelessWidget {
  const PatientWidget(
      {super.key, required this.patient, required this.refresher});

  final Patient patient;
  final Future<void> Function() refresher;

  @override
  Widget build(BuildContext context) {
    Future<void> editPatient() async {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: AddEditPatientScreen(
              patient: patient,
              refresher: refresher,
            ),
          );
        },
      );
    }

    Future<void> deletePatient(int id) async {
      final response =
          await http.delete(Uri.parse('http://localhost:8080/patient/$id'));
      if (response.statusCode == 202) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).clearSnackBars();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patient deleted successfully'),
          ),
        );
        refresher();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).clearSnackBars();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('an error hapend'),
        ));
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          color: Colors.lightBlue[50], // change card color
          child: Container(
            padding: EdgeInsets.all(constraints.maxWidth * 0.01),
            margin: EdgeInsets.all(constraints.maxWidth * 0.01),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: constraints.maxWidth * 0.01),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(width: constraints.maxWidth * 0.01),
                      Text(
                        "Age: ${patient.age}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black), // change text style
                      ),
                      SizedBox(width: constraints.maxWidth * 0.01),
                      Flexible(
                        child: Text(
                          "Phone Number: ${patient.phoneNumber}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black), // change text style
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          editPatient();
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () {
                          deletePatient(patient.patientId);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
