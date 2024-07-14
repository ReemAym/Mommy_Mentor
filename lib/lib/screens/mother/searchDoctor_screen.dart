import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import the flutter_spinkit package

import '../../models/app_colors.dart';
import '../../models/appointment.dart';
import '../../providers/appointment_provider.dart';

class SearchAppointmentScreen extends StatefulWidget {
  SearchAppointmentScreen({super.key});

  @override
  _SearchAppointmentScreenState createState() =>
      _SearchAppointmentScreenState();
}

class _SearchAppointmentScreenState extends State<SearchAppointmentScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController feesController = TextEditingController();
  bool isLoading = false;
  bool searchInitiated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Appointments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchFields(context),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height *
                    0.6, // Set a specific height to avoid overflow
                child: isLoading
                    ?const Center(
                        child: SpinKitCircle(
                          color: AppColors.primaryColor,
                          size: 50.0,
                        ),
                      )
                    : searchInitiated
                        ? Consumer<AppointmentProvider>(
                            builder: (context, appointmentProvider, child) {
                              return appointmentProvider.appointments.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.event_busy,
                                            size: 100,
                                            color: Colors.grey[300],
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            'No appointments found',
                                            style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: appointmentProvider
                                          .appointments.length,
                                      itemBuilder: (context, index) {
                                        Appointment appointment =
                                            appointmentProvider
                                                .appointments[index];
                                        return _buildAppointmentCard(
                                            appointment);
                                      },
                                    );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 100,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Please enter search criteria',
                                  style: GoogleFonts.roboto(
                                      fontSize: 18, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFields(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Doctor Name',
                labelStyle: GoogleFonts.roboto(fontSize: 18),
                floatingLabelStyle: const TextStyle(color: AppColors.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    nameController.clear();
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                labelStyle: GoogleFonts.roboto(fontSize: 18),
                floatingLabelStyle: const TextStyle(color: AppColors.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder:const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    locationController.clear();
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: feesController,
              decoration: InputDecoration(
                labelText: 'Max Fees',
                labelStyle: GoogleFonts.roboto(fontSize: 18),
                floatingLabelStyle: const TextStyle(color: AppColors.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    feesController.clear();
                  },
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    searchInitiated = true;
                  });
                  double fees = double.tryParse(feesController.text) ?? 0.0;
                  Provider.of<AppointmentProvider>(context, listen: false)
                      .filterAppointment(
                    nameController.text,
                    locationController.text,
                    fees,
                  );
                  setState(() {
                    isLoading = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Search',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
          style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${appointment.location} - £${appointment.fees.toString()} pounds',
          style: GoogleFonts.roboto(fontSize: 16),
        ),
        // trailing: const Icon(Icons.arrow_forward_ios,
        //     color:  Color.fromARGB(255, 187, 133, 163)),
      ),
    );
  }
}
