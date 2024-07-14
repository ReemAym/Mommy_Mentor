import 'package:flutter/material.dart';

import '../../component/modifiy_advice.dart';
import '../../models/advice.dart';
import '../../models/app_colors.dart';
import '../../services/advice_service.dart';
import 'add_advice_page.dart';

class AdviceModification extends StatefulWidget {
  const AdviceModification({Key? key}) : super(key: key);

  @override
  State<AdviceModification> createState() => _AdviceModificationState();
}

class _AdviceModificationState extends State<AdviceModification> {
  List<Advice> adviceList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAdvice();
  }

  void fetchAdvice() async {
    try {
      List<Advice> advices = await AdviceService().fetchAllAdvice();
      if (mounted) {
        setState(() {
          adviceList = advices;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to load advice: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteAdvice(String id) {
    setState(() {
      adviceList.removeWhere((advice) => advice.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Advice',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddAdviceScreen();
              }));
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : adviceList.isEmpty
              ?const Center(
                  child: Text(
                    'No advice yet',
                    style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: adviceList.length,
                  itemBuilder: (context, index) {
                    final advice = adviceList[index];
                    return ModifyAdvice(
                      title: advice.title,
                      content: advice.content,
                      age: advice.age,
                      id: advice.id,
                      onDelete: deleteAdvice,
                    );
                  },
                ),
    );
  }
}
