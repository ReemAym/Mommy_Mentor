import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../component/mother_navigation.dart';
import '../../models/mother.dart';

import '../../providers/auth_provider.dart';
import '../../screens/mother/show_doctor.dart';
import '../../screens/mother/vaccine_page.dart';

import '../../component/grid_item.dart';
import '../../models/app_colors.dart';
import '../../models/baby.dart';
import '../../services/all_users_service.dart';
import '../signin_page.dart';
import 'advice_page.dart';
import 'article_categories_page.dart';
import 'baby_tracker.dart';
import 'choose_model.dart';
import 'vaccine_center_page.dart';
import 'video_screen.dart';

class MotherHomeScreen extends StatefulWidget {
  final Mother? mother;
  final Baby? baby;
  final String? motherID;
  final String? password;

  const MotherHomeScreen(
      {super.key, this.baby, this.motherID, this.password, this.mother});

  @override
  _MotherHomeScreenState createState() => _MotherHomeScreenState();
}

class _MotherHomeScreenState extends State<MotherHomeScreen> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.mother!.babies![widget.mother!.babies!.length - 1].firstname);
    print('home screen ${widget.motherID}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        automaticallyImplyLeading: false,
        actions: [
          // IconButton(
          //   icon:const Icon(
          //     Icons.notifications,
          //     color: AppColors.primaryColor,
          //   ),
          //   onPressed: () {
          //     print(widget.baby?.firstname);
          //   },
          // ),
       
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: AppColors.primaryColor,
            ),
            onPressed: () async {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignIn()),
              );

               try {
                  AllUsersService onlineService = AllUsersService();
                  await onlineService.updateMotherStatus(widget.motherID!, false,widget.mother!.token);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update status')),
                  );
                }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.pregnant_woman,
                      size: 100, color: AppColors.primaryColor),
                  const SizedBox(height: 8),
                  Text('Welcome ${widget.mother!.name}',
                      style: const TextStyle(fontSize: 24)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  GridItem(
                    context,
                    Icons.arrow_forward,
                    'Age Related Advice',
                    AdvicePage(
                        baby: widget
                            .mother!.babies![widget.mother!.currentIndex],token: widget.mother!.token,),
                  ),
                  GridItem(
                    context,
                    Icons.show_chart,
                    'Baby Growth',
                    BabyGrowthTracker(
                        baby: widget
                            .mother!.babies![widget.mother!.currentIndex],token: widget.mother!.token,),
                  ),
                  GridItem(
                    context,
                    Icons.article,
                    'Articles',
                    ArticleCategories(token:widget.mother!.token),
                  ),
                  GridItem(
                    context,
                    Icons.video_library,
                    'Videos',
                    VideoScreen(),
                  ),
                  GridItem(
                    context,
                    Icons.local_hospital,
                    'Show Doctors',
                    AppointmentListScreen(token: widget.mother!.token,),
                  ),
                  GridItem(
                    context,
                    Icons.check,
                    'Check Disease',
                    const ChooseModel(),
                  ),
                  GridItem(
                    context,
                    Icons.vaccines,
                    'Show Vaccine',
                    VaccinePage(
                        baby: widget
                            .mother!.babies![widget.mother!.currentIndex],token:widget.mother!.token),
                  ),
                  GridItem(
                    context,
                    Icons.store,
                    'Vaccine Center',
                    VaccineCenterPage(
                      address: widget.mother!.address,
                      token:widget.mother!.token
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MotherNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        motherID: widget.motherID,
        mother: widget.mother,
        MpassWord: widget.password,
      ),
    );
  }
}
