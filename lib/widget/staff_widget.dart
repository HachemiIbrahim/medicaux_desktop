import 'package:flutter/material.dart';
import 'package:medicaux_desktop/model/staff.dart';
import 'package:http/http.dart' as http;
import 'package:medicaux_desktop/screen/staff/add_edit_staff.dart';

class StaffWidget extends StatelessWidget {
  const StaffWidget({super.key, required this.staff, required this.refresher});

  final Staff staff;
  final Future<void> Function() refresher;

  @override
  Widget build(BuildContext context) {
    Future<void> editStaff() async {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: AddEditStaffScreen(
              staff: staff,
              refresher: refresher,
            ),
          );
        },
      );
    }

    Future<void> deleteStaff(int id) async {
      final response =
          await http.delete(Uri.parse('http://localhost:8080/staff/$id'));
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
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: constraints.maxWidth * 0.01),
                Text(
                  staff.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: constraints.maxWidth * 0.01),
                SizedBox(width: constraints.maxWidth * 0.01),
                Text(
                  "role : ${staff.role}",
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
                          editStaff();
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteStaff(staff.staffId);
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
