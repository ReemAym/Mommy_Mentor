import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_colors.dart';
import '../../providers/appointment_provider.dart';
import '../../models/appointment.dart';

class AppointmentListScreen extends StatefulWidget {
  final String? token;

  const AppointmentListScreen({super.key, this.token});

  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppointmentProvider>(context, listen: false)
        .loadAppointments(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Appointments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search-appointments').then((_) {
                Provider.of<AppointmentProvider>(context, listen: false)
                    .resetAppointments();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<AppointmentProvider>(context, listen: false)
            .loadAppointments(widget.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading appointments'));
          } else {
            return Consumer<AppointmentProvider>(
              builder: (context, appointmentProvider, child) {
                return ListView.builder(
                  itemCount: appointmentProvider.appointments.length,
                  itemBuilder: (context, index) {
                    Appointment appointment =
                        appointmentProvider.appointments[index];
                    return _buildAppointmentCard(appointment);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          appointment.name,
          style:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${appointment.location} - ${appointment.fees.toString()} pounds',
          style: const TextStyle(fontSize: 16),
        ),
        // trailing:const Icon(Icons.arrow_forward_ios,
        //     color:  Color.fromARGB(255, 187, 133, 163)),
      ),
    );
  }
}
