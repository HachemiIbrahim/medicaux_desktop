import 'package:flutter/material.dart';
import 'package:medicaux_desktop/model/patient.dart';

class PatientWidget extends StatelessWidget {
  const PatientWidget({super.key, required this.patient});

  final Patient patient;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                child: Icon(Icons.person),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  patient.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "${patient.age}",
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 15),
          Text(
            patient.phoneNumber,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 15),
          const Divider(
            thickness: 2,
          )
        ],
      ),
    );
  }
}
