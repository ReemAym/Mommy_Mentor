import 'package:flutter/material.dart';
import '../../component/one_advice.dart';
import '../../models/app_colors.dart';
import '../../models/advice.dart';
import '../../models/baby.dart';
import '../../services/advice_service.dart';

class AdvicePage extends StatefulWidget {
  final Baby? baby;
  final String? token;
  const AdvicePage({super.key, this.baby, this.token});

  @override
  State<AdvicePage> createState() => _AdvicePageState();
}

class _AdvicePageState extends State<AdvicePage> {
  List<Advice> adviceList = [];
  bool isLoading = true;
  Baby? baby;
  DateTime? babyDate;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    baby = widget.baby;
    babyDate = baby != null ? baby!.birthdate : DateTime.now();
    fetchAdvice();
  }

  void fetchAdvice() async {
    AdviceService service = AdviceService();
    try {
      List<Advice> advices = await service.fetchAdviceByAgeLang(
          calculateAgeInMonths(babyDate!), _selectedLanguage, widget.token);
      if (mounted) {
        setState(() {
          adviceList = advices;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to load advice: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String languageCode = _selectedLanguage == 'Arabic' ? 'ar' : 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedText('advice', languageCode),
          style:const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
          backgroundColor: AppColors.primaryColor,

        iconTheme:const IconThemeData(color: Colors.white),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedLanguage = newValue;
                  fetchAdvice();
                });
              }
            },
            items: <String>['English', 'Arabic']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Container(
        child: isLoading
            ?const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      adviceList.isEmpty
                          ? Center(
                              child: Text(
                                  getTranslatedText('no_advice_yet', languageCode)))
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: ListView.builder(
                                itemCount: adviceList.length,
                                itemBuilder: (context, index) {
                                  return OneAdvice(
                                    advice: adviceList[index].title,
                                    content: adviceList[index].content,
                                    date: DateTime.now(),
                                    age: calculateAgeInMonths(babyDate!),
                                    languageCode: languageCode,
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

int calculateAgeInMonths(DateTime birthdate) {
  DateTime today = DateTime.now();
  int years = today.year - birthdate.year;
  int months = today.month - birthdate.month;

  if (months < 0) {
    years--;
    months += 12;
  }

  return years * 12 + months;
}

String getTranslatedText(String key, String languageCode) {
  return translations[languageCode]?[key] ?? key;
}

const Map<String, Map<String, String>> translations = {
  'en': {
    'advice': 'Advice',
    'no_advice_yet': 'No advice yet',
    'months': 'months',
    'years': 'years',
  },
  'ar': {
    'advice': 'النصائح',
    'no_advice_yet': 'لا توجد نصائح حتى الآن',
    'months': 'شهور',
    'years': 'سنوات',
  },
};
