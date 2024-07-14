import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/appointment_provider.dart';
import 'screens/admin/admin_home_page.dart';
import 'screens/mother/searchDoctor_screen.dart';
import 'screens/start_page.dart';
import 'providers/navbar_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/mother/mother_home_screen.dart';
import 'screens/doctor/doctor_home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationModel()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()..checkLoginStatus()),
      ],
      child: const MommyMentor(),
    ),
  );
}

class MommyMentor extends StatelessWidget {
  const MommyMentor({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return MaterialApp(
          title: 'Sign Out',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: auth.isLoggedIn
          //     ? auth.mother != null
          //         ? MotherHomeScreen(
          //             mother: auth.mother,
          //             baby: auth.mother?.babies?[auth.mother!.currentIndex],
          //             motherID: auth.mother?.id,
          //             password: auth.password,
          //           )
          //         : DoctorHomeScreen(
          //             doctorId: auth.doctor?.id,
          //             password: auth.password,
          //             doctor: auth.doctor,
          //           )
          //     : StartPage(),
          home: AdminHomeScreen(),
          routes: {
            '/search-appointments': (context) => SearchAppointmentScreen(),
          },
        );
      },
    );
  }
}
