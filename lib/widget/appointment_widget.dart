import 'package:flutter/material.dart';
import 'package:medicaux_desktop/model/appointment.dart';
import 'package:http/http.dart' as http;

class AppointmentWidget extends StatelessWidget {
  const AppointmentWidget(
      {super.key, required this.appointment, required this.refresher});
  final Appointment appointment;
  final Future<void> Function() refresher;

  @override
  Widget build(BuildContext context) {
    Future<void> deleteAppointment(int id) async {
      final response =
          await http.delete(Uri.parse('http://localhost:8080/appointment/$id'));
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
          color: Colors.lightBlue[50],
          child: Container(
            padding: EdgeInsets.all(constraints.maxWidth * 0.01),
            margin: EdgeInsets.all(constraints.maxWidth * 0.01),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.calendar_month, color: Colors.white),
                ),
                SizedBox(width: constraints.maxWidth * 0.01),
                Text(
                  "${appointment.appointmentId}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: constraints.maxWidth * 0.01),
                Text(
                  "Doctor Name: ${appointment.doctorName}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                SizedBox(width: constraints.maxWidth * 0.01),
                Text(
                  "Patient Name: ${appointment.patientName}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                SizedBox(width: constraints.maxWidth * 0.01),
                Text(
                  "Appointment Date: ${appointment.appointment_date}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                const Spacer(),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteAppointment(appointment.appointmentId);
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
