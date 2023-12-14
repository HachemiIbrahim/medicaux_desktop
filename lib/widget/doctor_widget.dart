import 'package:flutter/material.dart';
import 'package:medicaux_desktop/model/doctor.dart';
import 'package:http/http.dart' as http;
import 'package:medicaux_desktop/screen/doctor/add_edit_doctor.dart';

class DoctorWidget extends StatelessWidget {
  const DoctorWidget(
      {super.key, required this.doctor, required this.refresher});

  final Doctor doctor;
  final Future<void> Function() refresher;

  @override
  Widget build(BuildContext context) {
    Future<void> editDoctor() async {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: AddEditDoctorScreen(
              doctor: doctor,
              refresher: refresher,
            ),
          );
        },
      );
    }

    Future<void> deleteDoctor(int id) async {
      final response =
          await http.delete(Uri.parse('http://localhost:8080/doctor/$id'));
      if (response.statusCode == 202) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).clearSnackBars();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doctor deleted successfully'),
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
          color: Colors.lightBlue[50],
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
                        doctor.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(width: constraints.maxWidth * 0.01),
                      Flexible(
                        child: Text(
                          "speciality : ${doctor.speciality}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
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
                          editDoctor();
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteDoctor(doctor.doctorId);
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
