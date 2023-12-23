import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicaux_desktop/model/staff_doctor.dart';

class DoctorStaffWidget extends StatelessWidget {
  const DoctorStaffWidget(
      {Key? key, required this.doctorStaff, required this.refresher})
      : super(key: key);
  final DoctorStaff doctorStaff;
  final Future<void> Function() refresher;

  @override
  Widget build(BuildContext context) {
    Future<void> deleteStaffMember(int doctorId, int staffId) async {
      final response = await http.delete(
          Uri.parse('http://localhost:8080/doctor_staff/$doctorId/$staffId'));
      if (response.statusCode == 202) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Staff member deleted successfully'),
          ),
        );
        refresher();
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occurred'),
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
                    child: ImageIcon(
                      AssetImage("assets/images/doctor_staff.png"),
                    )),
                SizedBox(width: constraints.maxWidth * 0.01),
                Text(
                  "Staff name : ${doctorStaff.staffName}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: constraints.maxWidth * 0.01),
                Text(
                  "Doctor Name: ${doctorStaff.doctorName}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                SizedBox(width: constraints.maxWidth * 0.01),
                Text(
                  "Assignment Date: ${doctorStaff.assignmentDate}",
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
                        onPressed: () {
                          deleteStaffMember(
                              doctorStaff.doctorID, doctorStaff.staffID);
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
