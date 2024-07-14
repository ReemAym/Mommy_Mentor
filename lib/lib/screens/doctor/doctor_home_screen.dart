import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../component/doctor_navigation.dart';
import '../../component/grid_item.dart';
import '../../models/app_colors.dart';
import '../../models/doctor.dart';
import '../../providers/auth_provider.dart';
import '../../services/all_users_service.dart';
import '../signin_page.dart';
import 'addAppointment_screen.dart';
import 'upload_article_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  final String? doctorId;
  final String? password;
  final Doctor? doctor;
  const DoctorHomeScreen({super.key, this.doctorId, this.doctor, this.password});

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: AppColors.primaryColor,
            ),
            onPressed: () {},
          ),
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
                  await onlineService.updateDoctorStatus(widget.doctorId!, false,widget.doctor!.token);
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
            const Center(
              child: Column(
                children: [
                  Icon(Icons.medical_services,
                      size: 100, color: AppColors.primaryColor),
                  SizedBox(height: 8),
                  Text('Welcome', style: TextStyle(fontSize: 24)),
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
                  GridItem(context, Icons.article_outlined, 'Add Articles',
                      const UploadArticle()),
                  GridItem(
                      context,
                      Icons.medical_information_outlined,
                      'Add clinics',
                      AddAppointmentScreen(
                        doctorId: widget.doctorId,
                        token: widget.doctor!.token,
                      )), //********************** */
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DoctorNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        doctorID: widget.doctorId,
        doctor: widget.doctor,
        password: widget.password,
      ),
    );
  }
}
