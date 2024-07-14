import 'package:flutter/material.dart';
import '../component/doctor_navigation.dart';
import '../component/mother_navigation.dart';
import '../models/doctor.dart';
import '../models/mother.dart';
import '../models/reciever.dart';
import '../services/chat_service.dart';
import 'chat_screen.dart';

class ReceiverSelectionScreen extends StatefulWidget {
  final String? token;
  final String? userId;
  final String? userModel;
  final Doctor? doctor;
  final Mother? mother;
  final String? password;
  const ReceiverSelectionScreen(
      {super.key,
      this.userId,
      this.userModel,
      this.doctor,
      this.mother,
      this.password, this.token});

  @override
  _ReceiverSelectionScreenState createState() =>
      _ReceiverSelectionScreenState();
}

class _ReceiverSelectionScreenState extends State<ReceiverSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ChatService _apiService = ChatService();
  List<Receiver> _receivers = [];
  List<Receiver> _filteredReceivers = [];
  bool _isLoading = true;
  String? userId;
  String? userModel;
  int _currentIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    userModel = widget.userModel;
    print('user model in receiver screen $userModel');
    _fetchReceivers();
  }

  Future<void> _fetchReceivers() async {
    try {
      final mothers = await _apiService.fetchReceivers('Mother', 100, 1,widget.token);
      final doctors = await _apiService.fetchReceivers('Doctor', 100, 1,widget.token);
      if (mounted) {
        setState(() {
          _receivers = [...mothers, ...doctors]
              .where((receiver) => receiver.id != userId)
              .toList();
          _filteredReceivers = _receivers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // Handle error (e.g., show a snackbar or a dialog)
    }
  }

  void _filterReceivers(String query) {
    final filtered = _receivers.where((receiver) {
      final nameLower = receiver.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredReceivers = filtered;
    });
  }

  void _selectReceiver(Receiver receiver) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userId: userId!,
          userModel: userModel!,
          contactId: receiver.id,
          contactModel: receiver.model,
          token: widget.token,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Select Receiver'),
        // automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ?const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search receiver...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon:const Icon(Icons.search),
                    ),
                    onChanged: _filterReceivers,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredReceivers.length,
                    itemBuilder: (context, index) {
                      final receiver = _filteredReceivers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: receiver.model == 'Mother'
                              ? Colors.pink
                              : Colors.blue,
                          child: Icon(
                            receiver.model == 'Mother'
                                ? Icons.child_friendly
                                : Icons.local_hospital,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(receiver.name),
                        subtitle: Text(receiver.model),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _selectReceiver(receiver),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: widget.userModel == "Doctor"
          ? DoctorNavigationBar(
              doctor: widget.doctor,
              doctorID: widget.userId,
              password: widget.password,
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
            )
          : MotherNavigationBar(
              mother: widget.mother,
              motherID: widget.userId,
              MpassWord: widget.password,
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
            ),
    );
  }
}