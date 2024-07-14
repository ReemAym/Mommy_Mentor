import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';


import '../models/app_colors.dart';
import '../models/doctor.dart';
import '../screens/doctor/doctor_edit_profile.dart';
import '../screens/doctor/doctor_home_screen.dart';
import '../screens/online_users_screen.dart';

class DoctorNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String? doctorID;
  final String? password;
  final Doctor? doctor;

  const DoctorNavigationBar(
      {super.key,
      required this.currentIndex,
      required this.onTap,
      this.doctorID,
      this.doctor,
      this.password});


  @override
  Widget build(BuildContext context) {
    // int unreadCount = 5; //come from back
    return BottomNavigationBar(
      items:  const[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
          
        ),
//        BottomNavigationBarItem(
//   icon: Stack(
//     children: [
//       Icon(Icons.chat),
//       // Conditionally show the notification dot
//       if (unreadCount > 0)
//         Positioned(
//           right: 0,
//           child: Container(
//             padding: EdgeInsets.all(1),
//             decoration: BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             constraints: BoxConstraints(
//               minWidth: 12,
//               minHeight: 12,
//             ),
//             child: Text(
//               unreadCount.toString(),
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 8,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//     ],
//   ),
//   label: 'Chat',
// ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primaryColor,
      onTap: (index) {
        onTap(index);
        navigateTo(context, index);
      },
    );
  }

  void navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                DoctorHomeScreen(doctor: doctor,doctorId: doctorID,password: password,),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                OnlineUsersScreen(
              userId: doctorID,
              userModel: "Doctor",
              password: password,
              doctor: doctor,
              token: doctor?.token,
            ), //**************************************** */
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => DoctorEditProfile(
              doctor: doctor,
              password: password,
            ),
            transitionDuration: Duration.zero,
          ),
        );
        break;
    }
  }
}
