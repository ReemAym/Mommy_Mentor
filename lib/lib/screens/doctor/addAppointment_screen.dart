import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../models/app_colors.dart';
import '../../models/appointment.dart';
import '../../services/appointment_service.dart';

class AddAppointmentScreen extends StatefulWidget {
  final String? doctorId;
  final String? token;

  const AddAppointmentScreen({super.key, this.doctorId, this.token});

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _feeController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  String?
      doctorId; // Declare doctorId variable to access the doctorId passed from AddAppointmentScreen

  @override
  void initState() {
    super.initState();
    doctorId = widget.doctorId; // Initialize doctorId in initState
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final DateTime appointmentDateTime = DateFormat('yyyy-MM-dd hh:mm a')
          .parse('${_dateController.text} ${_timeController.text}');

      final appointment = Appointment(
        name: 'Doctor Name', // Replace with actual doctor's name
        location: _addressController.text,
        fees: double.parse(_feeController.text),
        time: appointmentDateTime.toIso8601String(),
        doctorId: doctorId!,
      );

      try {
        await AppointmentService().addAppointment(appointment, widget.token);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Appointment added successfully!'),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add appointment: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          'Add Appointment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme:const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                    labelText: 'Address',
                floatingLabelStyle: const TextStyle(color: AppColors.primaryColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon:const Icon(Icons.location_on),
                    focusedBorder:const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _feeController,
                decoration: InputDecoration(
                    labelText: 'Fee',
                floatingLabelStyle:const TextStyle(color: AppColors.primaryColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.currency_pound),
                    focusedBorder:const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    )),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a fee';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                    labelText: 'Date (YYYY-MM-DD)',
                floatingLabelStyle: const TextStyle(color: AppColors.primaryColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.calendar_today),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    )),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                    labelText: 'Time (HH:MM AM/PM)',
                    labelStyle: GoogleFonts.roboto(fontSize: 18),
                                    floatingLabelStyle: TextStyle(color: AppColors.primaryColor),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.access_time),
                    focusedBorder:const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    )),
                readOnly: true,
                onTap: () => _selectTime(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Add Appointment',
                    style:
                        GoogleFonts.roboto(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
