import 'package:flutter/material.dart';

import '../../models/doctor.dart';
import '../../models/mother.dart';
import '../../services/all_users_service.dart';

class ShowUsersScreen extends StatefulWidget {
  @override
  _ShowUsersScreenState createState() => _ShowUsersScreenState();
}

class _ShowUsersScreenState extends State<ShowUsersScreen> {
  late Future<Map<String, dynamic>> futureMothers;
  late Future<Map<String, dynamic>> futureDoctors;
  final AllUsersService apiService = AllUsersService();

  @override
  void initState() {
    super.initState();
    futureMothers = apiService.fetchMothers();
    futureDoctors = apiService.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Show All Users'),
      ),
      body: FutureBuilder(
        future: Future.wait([futureMothers, futureDoctors]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          } else {
            Map<String, dynamic> mothersMap =
                snapshot.data![0] as Map<String, dynamic>;
            Map<String, dynamic> doctorsMap =
                snapshot.data![1] as Map<String, dynamic>;

            List<Mother> mothers = (mothersMap['data'] as List)
                .map((item) => Mother.fromJson(item))
                .toList();
            List<Doctor> doctors = (doctorsMap['data'] as List)
                .map((item) => Doctor.fromJson(item))
                .toList();

            List<Map<String, dynamic>> allUsers = [
              ...mothers.map((mother) => {
                    'id': mother.id,
                    'name': mother.name,
                    'email': mother.email,
                    'type': 'Mother',
                  }),
              ...doctors.map((doctor) => {
                    'id': doctor.id,
                    'name': '${doctor.firstname} ${doctor.lastname}',
                    'email': doctor.email,
                    'type': 'Doctor',
                  }),
            ];

            return ListView.builder(
              itemCount: allUsers.length,
              itemBuilder: (context, index) {
                var user = allUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        user['type'] == 'Mother' ? Colors.pink : Colors.blue,
                    child: Icon(
                      user['type'] == 'Mother'
                          ? Icons.pregnant_woman
                          : Icons.local_hospital,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(user['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['type']),
                      Text(user['email']),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      try {
                        if (user['type'] == 'Mother') {
                          await apiService.deleteMother(user['id']);
                        } else if (user['type'] == 'Doctor') {
                          await apiService.deleteDoctor(user['id']);
                        }
                        // Refresh user list after deletion
                        setState(() {
                          futureMothers = apiService.fetchMothers();
                          futureDoctors = apiService.fetchDoctors();
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to delete user: $e'),
                          ),
                        );
                      }
                    },
                  ),
                 
                );
              },
            );
          }
        },
      ),
    );
  }
}
