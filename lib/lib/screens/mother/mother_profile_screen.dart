import 'dart:io';
import 'package:flutter/material.dart';

import '../../component/button.dart';
import '../../component/mother_navigation.dart';
import '../../models/app_colors.dart';
import '../../models/mother.dart';
import '../../services/authantication_service.dart';
import 'mother_edit_profile_screen.dart';
import 'baby_sign_up_page.dart';

class MotherProfileScreen extends StatefulWidget {
  final File? image;
  Mother? mother;
  final String? password;

  MotherProfileScreen({super.key, this.image, this.mother, this.password});

  @override
  _MotherProfileScreenState createState() => _MotherProfileScreenState();
}

class _MotherProfileScreenState extends State<MotherProfileScreen> {
  int _currentIndex = 2;
  late File? _image;
  late String? accountName = widget.mother != null ? widget.mother!.name : "";
  int? _selectedBabyIndex;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
    _selectedBabyIndex = widget.mother?.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  // void _showDeleteDialog(BuildContext context, String babyId, String token, int index) {
  // final apiService = ApiauthanticateService(baseUrl: 'http://10.0.2.2:9000');

//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text(
//         'Delete Baby',
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: AppColors.primaryColor,
//         ),
//       ),
//       content: Text(
//         'Are you sure you want to delete this baby?',
//         style: TextStyle(
//           fontSize: 16,
//           color: Colors.black87,
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(
//             'Cancel',
//             style: TextStyle(
//               color: AppColors.primaryColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         TextButton(
//           onPressed: () async {
//             try {
//               final result = await apiService.deleteBaby(babyId, token);
//               if (result['success']) {
//                 setState(() {
//                   widget.mother = Mother.fromJson(result['mother']);
//                   _selectedBabyIndex = widget.mother!.currentIndex;
//                 });
//                 Navigator.pop(context);
//               } else {
//                 // Handle failure
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text('Failed to delete baby: ${result['message']}'),
//                 ));
//               }
//             } catch (e) {
//               // Handle error
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: Text('An error occurred: $e'),
//               ));
//             }
//           },
//           child: Text(
//             'Delete',
//             style: TextStyle(
//               color: Colors.red,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//     ),
//   );
// }


  void _showDeleteDialog(
      BuildContext context, String babyId, String token, int index) {
    final apiService = ApiauthanticateService();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:const Text(
          'Delete Baby',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        content:const Text(
          'Are you sure you want to delete this baby?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                final result = await apiService.deleteBaby(babyId, token);
                if (result['success']) {

                  setState(() {
                    widget.mother!.babies!.removeAt(index);
                    print('$_selectedBabyIndex&&&&&&&&&&&&&&&&&');
                    // Update the selected baby index
                    if (_selectedBabyIndex != null) {
                      if (_selectedBabyIndex! > index) {
                        _selectedBabyIndex = _selectedBabyIndex! - 1;
                      } else if (_selectedBabyIndex! == index) {
                        _selectedBabyIndex = null;
                      }
                    }
                  //   widget.mother = Mother.fromJson(result['mother']);
                  // _selectedBabyIndex = widget.mother!.currentIndex;
                    // widget.mother?.currentIndex=_selectedBabyIndex;
                  });
                  Navigator.pop(context);
                } else {
                  // Handle failure
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Failed to delete baby: ${result['message']}'),
                  ));
                }
              } catch (e) {
                // Handle error
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('An error occurred: $e'),
                ));
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('My Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        _image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.person_2,
                        color: Colors.grey.shade800,
                      ),
                    ),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(accountName!, style:const TextStyle(fontSize: 24)),
                 const SizedBox(height: 8),
                  Button(
                    text: 'Edit Profile',
                    background_color: AppColors.primaryColor,
                    text_color: Colors.white,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MotherEditProfile(
                          mother: widget.mother,
                          passWord: widget.password,
                        );
                      }));
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Babies\' files'),
            _buildChildFiles(),
          ],
        ),
      ),
      bottomNavigationBar: MotherNavigationBar(
        mother: widget.mother,
        currentIndex: _currentIndex,
        MpassWord: widget.password,
        motherID: widget.mother!.id,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style:const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildChildFiles() {
    return Column(
      children: [
        ListTile(
          leading:const CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.add, color: Colors.white),
          ),
          title: Text('Add Another Baby'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BabySignUp(
                  motherId: widget.mother?.id, mother: widget.mother!);
            }));
          },
        ),
        ...(widget.mother?.babies ?? []).asMap().entries.map((entry) {
          final index = entry.key;
          final baby = entry.value;
          final isSelected = _selectedBabyIndex == index;

          return ListTile(
            leading: CircleAvatar(
              child: Text(baby.firstname[0]),
            ),
            title: Text('${baby.firstname} ${baby.lastname}'),
            subtitle: Text('Age: ${calculateBabyAge(baby.birthdate)}'),
            tileColor: isSelected ? Colors.blue.shade100 : Colors.transparent,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  const Icon(Icons.check, color: AppColors.primaryColor),
                if (!isSelected)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteDialog(
                          context, baby.id, widget.mother!.token, index);
                    },
                  ),
              ],
            ),
            onTap: () async {
              final ApiauthanticateService apiService =
                  ApiauthanticateService();
              int selectedBabyIndex = index;

              final result = await apiService.editCurrentIndexForMother(
                  widget.mother!.id, selectedBabyIndex, widget.mother!.token);

              if (result['success']) {
                final Map<String, dynamic> data = result['data'];
                final Mother updatedMother = Mother.fromJson(data);

                setState(() {
                  widget.mother = updatedMother;
                  _selectedBabyIndex = selectedBabyIndex;
                });
              } else {
                print('Failed to update mother: ${result['message']}');
              }
            },
          );
        }).toList(),
      ],
    );
  }

  String calculateBabyAge(DateTime birthDate) {
    final today = DateTime.now();
    int years = today.year - birthDate.year;
    int months = today.month - birthDate.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    return '$years years, $months months';
  }
}