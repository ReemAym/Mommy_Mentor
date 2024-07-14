import 'package:flutter/material.dart';


import '../models/app_colors.dart';
import '../models/mother.dart';
import '../screens/mother/mother_home_screen.dart';
import '../screens/mother/mother_profile_screen.dart';
import '../screens/online_users_screen.dart';

class MotherNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String? motherID;
  final Mother? mother;
  final String? MpassWord;
  // final String userModel = "Mother";
  const MotherNavigationBar(
      {super.key, required this.currentIndex,
      required this.onTap,
      this.motherID,
      this.mother,
      this.MpassWord});

  @override
  Widget build(BuildContext context) {
    

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
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
            pageBuilder: (context, animation1, animation2) => MotherHomeScreen(
              mother: mother,
              password: MpassWord,
              motherID: motherID,
            ),
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
              userId: motherID,
              mother: mother,
              userModel: "Mother",
              password: MpassWord,
              token: mother!.token,
            ), //**************************************** */
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MotherProfileScreen(
              mother: mother,
              password: MpassWord,
            ),
            transitionDuration: Duration.zero,
          ),
        );
        break;
    }
  }
}
