import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../component/button.dart';
import '../../models/baby.dart';
import '../../services/track_growth_service.dart';

class BabyGrowthTracker extends StatefulWidget {
  final Baby? baby;
  final String? token;
  const BabyGrowthTracker({super.key, this.baby,this.token});

  @override
  _BabyGrowthTrackerState createState() => _BabyGrowthTrackerState();
}

class _BabyGrowthTrackerState extends State<BabyGrowthTracker> {
  List<GrowthData> _growthDataList = [];
  List<NormalGrowthData> _normalGrowthData = [];
  
  int _age = 0;
  double _weight = 0.0;
  double _height = 0.0;
  double _headCircumference = 0.0;
  String _selectedChart = 'Weight';
  final _formKey = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
    _age = calculateAgeInMonths(widget.baby!.birthdate);
    _fetchMonthlyMeasurements();
    _fetchNormalGrowthData();
  }

  Future<void> _fetchMonthlyMeasurements() async {
    try {
      List<GrowthData> measurements = await GrowthTrackService.getAllMonthlyMeasurements(widget.baby!.id,widget.token);
      setState(() {
        _growthDataList = measurements;
      });
    } catch (e) {
      print('Error fetching measurements: $e');
    }
  }

  Future<void> _fetchNormalGrowthData() async {
    try {
      List<NormalGrowthData> normalGrowthData = await GrowthTrackService.getNormalGrowthData(widget.baby!.gender, _age,widget.token);
      print(normalGrowthData);
      setState(() {
        _normalGrowthData = normalGrowthData;
      });
    } catch (e) {
      print('Error fetching normal growth data: $e');
    }
  }

  void _updateWeight(double weight) {
    setState(() {
      _weight = weight;
    });
  }

  void _updateHeight(double height) {
    setState(() {
      _height = height;
    });
  }

  void _updateHeadCircumference(double headCircumference) {
    setState(() {
      _headCircumference = headCircumference;
    });
  }

Future<void> _addGrowthData() async {
  if (_formKey.currentState!.validate()) {
    GrowthData newGrowthData = GrowthData(
      month: _age,
      weight: _weight,
      height: _height,
      headCircumference: _headCircumference,
    );

    bool success = await GrowthTrackService.addGrowthData(widget.baby!.id, newGrowthData,widget.token);

    if (success) {
      setState(() {
        _growthDataList.add(newGrowthData);
        _fetchMonthlyMeasurements(); // Optional: Refresh the chart with new data
      });

      // Call checkNormalGrowth API service
      try {
        Map<String, dynamic> result = await GrowthTrackService.checkNormalGrowth(
          gender: widget.baby!.gender,
          ageInMonths: _age.toString(),
          weight: _weight,
          height: _height,
          headCircumference: _headCircumference,
          token:widget.token,
        );
        print(result);

        // Display result (you can update state variables or show a dialog)
showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: const Center(
        child: Text(
          'Normal Growth Check Result',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.blueAccent,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                result['weightNormal'] 
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          : const Icon(
              Icons.warning,
              color: Colors.red,
            ),
        const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${result['weight']}.',
                    style:const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
               result['heightNormal'] 
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          : const Icon(
              Icons.warning,
              color: Colors.red,
            ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${result['height']}.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                result['headCircumferenceNormal'] 
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          : const Icon(
              Icons.warning,
              color: Colors.red,
            ),
               const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${result['headCircumference']}.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Center(
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child:const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  },
);



      } catch (e) {
        print('Error checking normal growth: $e');
        // Handle error state or show error message to user
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:const Row(
          children: [
            // Icon(Icons.baby_changing_station),
            // SizedBox(width: 10),
            Text('Baby Growth Tracker'),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGrowthForm(),
            const SizedBox(height: 20.0),
            Expanded(child: _buildGrowthChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildTextField('Weight (in kg)', (value) {
                    double weight = double.tryParse(value) ?? 0.0;
                    _updateWeight(weight);
                  }, (value) => value!.isEmpty ? 'Please enter weight' : null),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: _buildTextField('Height (in cm)', (value) {
                    double height = double.tryParse(value) ?? 0.0;
                    _updateHeight(height);
                  }, (value) => value!.isEmpty ? 'Please enter height' : null),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: _buildTextField('Head Circumference (in cm)', (value) {
                    double headCircumference = double.tryParse(value) ?? 0.0;
                    _updateHeadCircumference(headCircumference);
                  }, (value) => value!.isEmpty ? 'Please enter head circumference' : null),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Button(
              onTap: _addGrowthData,
              text: 'Add Growth Data',
              background_color: Colors.blue,
              text_color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, void Function(String) onChangedCallback, String? Function(String?)? validator) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChangedCallback,
      validator: validator,
    );
  }

Widget _buildGrowthChart() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _buildDropdownMenu(),
      Expanded(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: charts.LineChart(
                  _createSeries(),
                  animate: true,
                  defaultRenderer: charts.LineRendererConfig(includePoints: true),
                  domainAxis: const charts.NumericAxisSpec(
                    tickProviderSpec: charts.StaticNumericTickProviderSpec(
                      <charts.TickSpec<num>>[
                        charts.TickSpec<num>(0, label: '0 mos'),
                        charts.TickSpec<num>(6, label: '6 mos'),
                        charts.TickSpec<num>(12, label: '12 mos'),
                        charts.TickSpec<num>(18, label: '18 mos'),
                        charts.TickSpec<num>(24, label: '24 mos'),
                      ],
                    ),
                  ),
                  primaryMeasureAxis: _selectedChart == 'Height'
                      ? const charts.NumericAxisSpec(
                          tickProviderSpec: charts.StaticNumericTickProviderSpec(
                            <charts.TickSpec<num>>[
                              charts.TickSpec<num>(45, label: '45 cm'),
                              charts.TickSpec<num>(50, label: '50 cm'),
                              charts.TickSpec<num>(55, label: '55 cm'),
                              charts.TickSpec<num>(60, label: '60 cm'),
                              charts.TickSpec<num>(65, label: '65 cm'),
                              charts.TickSpec<num>(70, label: '70 cm'),
                              charts.TickSpec<num>(75, label: '75 cm'),
                              charts.TickSpec<num>(80, label: '80 cm'),
                              charts.TickSpec<num>(85, label: '85 cm'),
                              charts.TickSpec<num>(90, label: '90 cm'),
                              charts.TickSpec<num>(95, label: '95 cm'),
                            ],
                          ),
                        )
                      : _selectedChart == 'Weight'
                          ? const charts.NumericAxisSpec(
                              tickProviderSpec: charts.StaticNumericTickProviderSpec(
                                <charts.TickSpec<num>>[
                                  charts.TickSpec<num>(2, label: '2 kg'),
                                  charts.TickSpec<num>(4, label: '4 kg'),
                                  charts.TickSpec<num>(6, label: '6 kg'),
                                  charts.TickSpec<num>(8, label: '8 kg'),
                                  charts.TickSpec<num>(10, label: '10 kg'),
                                  charts.TickSpec<num>(12, label: '12 kg'),
                                  charts.TickSpec<num>(14, label: '14 kg'),
                                  charts.TickSpec<num>(16, label: '16 kg'),
                                  charts.TickSpec<num>(18, label: '18 kg'),
                                ],
                              ),
                            )
                          : const charts.NumericAxisSpec(
                              tickProviderSpec: charts.StaticNumericTickProviderSpec(
                                <charts.TickSpec<num>>[
                                  charts.TickSpec<num>(30, label: '30 cm'),
                                  charts.TickSpec<num>(34, label: '34 cm'),
                                  charts.TickSpec<num>(38, label: '38 cm'),
                                  charts.TickSpec<num>(42, label: '42 cm'),
                                  charts.TickSpec<num>(46, label: '46 cm'),
                                  charts.TickSpec<num>(50, label: '50 cm'),
                                  charts.TickSpec<num>(54, label: '54 cm'),
                                  charts.TickSpec<num>(58, label: '58 cm'),
                                ],
                              ),
                            ),
                            behaviors: [
                      charts.SeriesLegend(
                        position: charts.BehaviorPosition.bottom,
                        horizontalFirst: false,
                        cellPadding: const EdgeInsets.all(0),
                        outsideJustification: charts.OutsideJustification.end
                      ),
                      
                    ],
                ),
              ),
               
              
            ],
          ),
        ),
      ),
    ],
  );
}

  Widget _buildDropdownMenu() {
    return DropdownButton<String>(
      value: _selectedChart,
      onChanged: (String? newValue) {
        setState(() {
          _selectedChart = newValue!;
        });
      },
      items: <String>['Height', 'Weight', 'Head Circumference']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  List<charts.Series<DataPoint, int>> _createSeries() {
    List<DataPoint> growthDataPoints = _growthDataList.map((growthData) {
      return DataPoint(
        growthData.month,
        _selectedChart == 'Height'
            ? growthData.height
            : _selectedChart == 'Weight'
                ? growthData.weight
                : growthData.headCircumference,
      );
    }).toList();

    List<DataPoint> fromnormalGrowthDataPoints =
        _normalGrowthData.map((growthData) {
      return DataPoint(
        int.parse(growthData.month),
        _selectedChart == 'Height'
            ? growthData.fromNormalHeight
            : _selectedChart == 'Weight'
                ? growthData.fromNormalWeight
                : growthData.fromNormalHeadCircumference,
      );
    }).toList();
    List<DataPoint> tonormalGrowthDataPoints =
        _normalGrowthData.map((growthData) {
      return DataPoint(
        int.parse(growthData.month),
        _selectedChart == 'Height'
            ? growthData.toNormalHeight
            : _selectedChart == 'Weight'
                ? growthData.toNormalWeight
                : growthData.toNormalHeadCircumference,
      );
    }).toList();

    return [
      charts.Series<DataPoint, int>(
        id: 'Baby Growth',
        data: growthDataPoints,
        domainFn: (DataPoint point, _) => point.ageMonths,
        measureFn: (DataPoint point, _) => point.value,
        colorFn: (_, __) => charts.MaterialPalette.black,
      ),
      charts.Series<DataPoint, int>(
        id: 'Minimum Normal Growth',
        data: fromnormalGrowthDataPoints,
        domainFn: (DataPoint point, _) => point.ageMonths,
        measureFn: (DataPoint point, _) => point.value,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      ),
      charts.Series<DataPoint, int>(
        id: 'Maximum Normal Growth',
        data: tonormalGrowthDataPoints,
        domainFn: (DataPoint point, _) => point.ageMonths,
        measureFn: (DataPoint point, _) => point.value,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      ),
    ];
  }
}

class GrowthData {
  final int month;
  final double weight;
  final double height;
  final double headCircumference;

  GrowthData({
    required this.month,
    required this.weight,
    required this.height,
    required this.headCircumference,
  });

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'weight': weight,
      'height': height,
      'headCircumference': headCircumference,
    };
  }

  factory GrowthData.fromJson(Map<String, dynamic> json) {
    return GrowthData(
      month: json['month'],
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      headCircumference: json['headCircumference'].toDouble(),
    );
  }
}

class DataPoint {
  final int ageMonths;
  final double value;

  DataPoint(this.ageMonths, this.value);
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

class NormalGrowthData {
  final String month;
  final double fromNormalWeight;
  final double toNormalWeight;
  final double fromNormalHeight;
  final double toNormalHeight;
  final double fromNormalHeadCircumference;
  final double toNormalHeadCircumference;

  NormalGrowthData({
    required this.month,
    required this.fromNormalWeight,
    required this.toNormalWeight,
    required this.fromNormalHeight,
    required this.toNormalHeight,
    required this.fromNormalHeadCircumference,
    required this.toNormalHeadCircumference,
  });

  factory NormalGrowthData.fromJson(Map<String, dynamic> json) {
    return NormalGrowthData(
      month: json['month'].toString(),
      fromNormalWeight: json['fromNormalWeight'].toDouble(),
      toNormalWeight: json['toNormalWeight'].toDouble(),
      fromNormalHeight: json['fromNormalHeight'].toDouble(),
      toNormalHeight: json['toNormalHeight'].toDouble(),
      fromNormalHeadCircumference: json['fromNormalHeadCircumference'].toDouble(),
      toNormalHeadCircumference: json['toNormalHeadCircumference'].toDouble(),
    );
  }
}


