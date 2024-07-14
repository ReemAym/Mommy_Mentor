import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';

class AppointmentProvider with ChangeNotifier {
  List<Appointment> _appointments = [];
  List<Appointment> _allAppointments = [];

  List<Appointment> get appointments => _appointments;

  Future<void> loadAppointments(String? token) async {
    _allAppointments = await AppointmentService().fetchAppointments(token);
    _appointments = _allAppointments;
    notifyListeners();
  }

  void filterAppointment(String name, String location, double fees) {
    _appointments = _allAppointments.where((appointment) {
      final appointmentName = appointment.name.toLowerCase();
      final appointmentLocation = appointment.location.toLowerCase();
      final filterName = name.toLowerCase();
      final filterLocation = location.toLowerCase();
      
      return (filterName.isEmpty || appointmentName.contains(filterName)) &&
             (filterLocation.isEmpty || appointmentLocation.contains(filterLocation)) &&
             (fees == 0.0 || appointment.fees <= fees);
    }).toList();
    notifyListeners();
  }


  void resetAppointments() {
    _appointments = _allAppointments;
    notifyListeners();
  }
}
