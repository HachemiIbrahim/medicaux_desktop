import 'package:flutter/material.dart';
import 'package:medicaux_desktop/screen/doctor_staff.dart';
import 'package:medicaux_desktop/screen/patient/patient_screen.dart';
import 'package:medicaux_desktop/screen/staff_screen.dart';
import 'package:medicaux_desktop/screen/traitement_screen.dart';

import 'appointment/appointment_screen.dart';
import 'doctor/doctor_screen.dart';
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
    const TraitementScreen(),
    const StaffScreen(),
    const DoctorStaffScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint) {
          return Row(
            children: [
              NavigationRail(
                leading: Column(
                  children: [
                    SizedBox(
                      height: constraint.maxHeight * 0.05,
                    ),
                    Image.asset(
                      "assets/images/logo.png",
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(
                      height: constraint.maxHeight * 0.05,
                    )
                  ],
                ),
                useIndicator: false,
                extended: true,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                selectedIndex: _currentIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                destinations: <NavigationRailDestination>[
                  NavigationRailDestination(
                    padding: const EdgeInsets.all(10),
                    icon: Icon(
                      Icons.home,
                      color: _currentIndex == 0 ? Colors.grey : Colors.white,
                    ),
                    selectedIcon: Icon(
                      Icons.home,
                      color: _currentIndex == 0 ? Colors.grey : Colors.white,
                    ),
                    label: Text(
                      'Home',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color:
                                _currentIndex == 6 ? Colors.grey : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  NavigationRailDestination(
                    padding: const EdgeInsets.all(10),
                    icon: Icon(
                      Icons.person,
                      color: _currentIndex == 1 ? Colors.grey : Colors.white,
                    ),
                    selectedIcon: Icon(
                      Icons.person,
                      color: _currentIndex == 1 ? Colors.grey : Colors.white,
                    ),
                    label: Text(
                      'Patient',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              _currentIndex == 6 ? Colors.grey : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  NavigationRailDestination(
                    padding: const EdgeInsets.all(10),
                    icon: Icon(
                      Icons.calendar_month,
                      color: _currentIndex == 2 ? Colors.grey : Colors.white,
                    ),
                    selectedIcon: Icon(
                      Icons.calendar_month,
                      color: _currentIndex == 2 ? Colors.grey : Colors.white,
                    ),
                    label: Text(
                      'Appointment',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              _currentIndex == 6 ? Colors.grey : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  NavigationRailDestination(
                    padding: const EdgeInsets.all(10),
                    icon: ImageIcon(
                      const AssetImage("assets/images/doctor.png"),
                      color: _currentIndex == 3 ? Colors.grey : Colors.white,
                    ),
                    selectedIcon: ImageIcon(
                      const AssetImage("assets/images/doctor.png"),
                      color: _currentIndex == 3 ? Colors.grey : Colors.white,
                    ),
                    label: Text(
                      'Doctor',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              _currentIndex == 6 ? Colors.grey : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  NavigationRailDestination(
                    padding: const EdgeInsets.all(10),
                    icon: ImageIcon(
                      const AssetImage("assets/images/traitement.png"),
                      color: _currentIndex == 4 ? Colors.grey : Colors.white,
                    ),
                    selectedIcon: ImageIcon(
                      const AssetImage("assets/images/traitement.png"),
                      color: _currentIndex == 4 ? Colors.grey : Colors.white,
                    ),
                    label: Text(
                      'Traitement',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              _currentIndex == 6 ? Colors.grey : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  NavigationRailDestination(
                    padding: const EdgeInsets.all(10),
                    icon: ImageIcon(
                      const AssetImage("assets/images/nurse.png"),
                      color: _currentIndex == 5 ? Colors.grey : Colors.white,
                    ),
                    selectedIcon: ImageIcon(
                      const AssetImage("assets/images/nurse.png"),
                      color: _currentIndex == 5 ? Colors.grey : Colors.white,
                    ),
                    label: Text(
                      'Staff',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              _currentIndex == 6 ? Colors.grey : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  NavigationRailDestination(
                    padding: const EdgeInsets.all(10),
                    icon: ImageIcon(
                      const AssetImage("assets/images/doctor_staff.png"),
                      color: _currentIndex == 6 ? Colors.grey : Colors.white,
                    ),
                    selectedIcon: ImageIcon(
                      const AssetImage("assets/images/doctor_staff.png"),
                      color: _currentIndex == 6 ? Colors.grey : Colors.white,
                    ),
                    label: Text(
                      'Doctor Staff',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              _currentIndex == 6 ? Colors.grey : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: _pages[_currentIndex],
              ),
            ],
          );
        },
      ),
    );
  }
}
