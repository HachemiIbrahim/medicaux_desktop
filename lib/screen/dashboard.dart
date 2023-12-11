import 'package:flutter/material.dart';
import 'package:medicaux_desktop/screen/patient_screen.dart';

import 'appointment_screen.dart';
import 'doctor_screen.dart';
import 'home_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() {
    return _DashBoardState();
  }
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const PatientScreen(),
    const AppointmentScreen(),
    const DoctorScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _pages.length,
      child: Scaffold(
        body: Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 5),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  child: Material(
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: const TabBar(
                      tabs: [
                        Tab(
                          icon: Icon(Icons.home_outlined),
                          text: 'Home',
                        ),
                        Tab(
                          icon: Icon(Icons.person_outline),
                          text: 'Patients',
                        ),
                        Tab(
                          icon: Icon(Icons.calendar_month_outlined),
                          text: 'Appointments',
                        ),
                        Tab(
                          icon: Icon(Icons.medical_services_outlined),
                          text: 'Doctors',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: _pages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
