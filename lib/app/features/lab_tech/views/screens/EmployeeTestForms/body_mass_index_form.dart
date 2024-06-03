// ignore_for_file: unnecessary_null_comparison, avoid_web_libraries_in_flutter
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:swastik_health_india/app/config/themes/app_theme.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';

class BodyMassIndexForm extends StatefulWidget {
  final VoidCallback resetForm;
  final String employeeId;
  final VoidCallback saveEmployees;
  const BodyMassIndexForm({
    Key? key,
    required this.resetForm,
    required this.saveEmployees,
    required this.employeeId,
  }) : super(key: key);

  @override
  _BodyMassIndexFormState createState() => _BodyMassIndexFormState();
}

class _BodyMassIndexFormState extends State<BodyMassIndexForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bmiResultController = TextEditingController();
  final TextEditingController _bmiReadingController = TextEditingController();

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height != null && weight != null && height > 0) {
      final bmi = weight / (height * height);
      setState(() {
        _bmiReadingController.text = bmi.toStringAsFixed(2);
        _bmiResultController.text = _getBmiResult(bmi);
      });
    }
  }

  String _getBmiResult(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _heightController.clear();
    _weightController.clear();
    _bmiReadingController.clear();
    _bmiResultController.clear();
  }

  void _sendDataToApi(
      String uri, Map<String, dynamic> data, String employeeId) async {
    if (_formKey.currentState?.validate() ?? false) {
      showLoadingDialog(context);

      try {
        var response = await http.post(
          Uri.parse(
              'https://swastik-health-india-api.onrender.com/api/employee/$uri'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              {...data, 'id': employeeId}), // Include employeeId in the data
        );

        if (response.statusCode == 200) {
          dismissLoadingDialog(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data sent successfully to $uri'),
              backgroundColor: Colors.green,
            ),
          );
          _resetForm();
          Navigator.pop(context);
        } else {
          dismissLoadingDialog(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send data to $uri')),
          );
        }
      } catch (e) {
        dismissLoadingDialog(context);

        // print('Error sending data to $uri: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending data to $uri')),
        );
      }
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents user from dismissing the dialog
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Make the background transparent
          elevation: 0, // Remove shadow
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lotties/loader.json',
                height: 250,
                width: 250,
              ),
            ],
          ),
        );
      },
    );
  }

  void dismissLoadingDialog(BuildContext context) {
    Navigator.pop(context); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Mass Index Form'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.save),
        //     onPressed: () {
        //       _sendDataToApi(
        //           '/vitals',
        //           {
        //             'id': widget.employeeId,
        //             'height': _heightController.text,
        //             'weight': _weightController.text,
        //             'bmi_reading': _bmiReadingController.text,
        //             'bmi_result': _bmiResultController.text,
        //           },
        //           widget.employeeId);
        //     },
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     onPressed: _resetForm,
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vital Section
              _buildVitalsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVitalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Vital'),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (m)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Height';
                  }
                  return null;
                },
                onChanged: (value) => _calculateBMI(),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Weight';
                  }
                  return null;
                },
                onChanged: (value) => _calculateBMI(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('Body Mass Index (BMI)'),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _bmiReadingController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'BMI Reading',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Height and Weight';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                controller: _bmiResultController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'BMI Result',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Height and Weight';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Align buttons to the end of the row
          children: [
            Material(
              child: InkWell(
                onTap: () {
                  final form = _formKey.currentState;
                  if (form != null) {
                    _formKey.currentState?.reset();
                    _resetForm();
                    setState(() {});
                  }
                },
                borderRadius: BorderRadius.circular(16.0),
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 14.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.basic
                            .primaryColorDark // Use canvasColor from dark theme
                        : AppTheme.light
                            .primaryColorLight, // Use canvasColor from light theme
                  ),
                  child: Text(
                    'Reset',
                    style: ralewayStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      // color: const Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Material(
              child: InkWell(
                onTap: () {
                  final form = _formKey.currentState;
                  if (form!.validate()) {
                    _sendDataToApi(
                        'vitals',
                        {
                          'id': widget.employeeId,
                          'height': _heightController.text,
                          'weight': _weightController.text,
                          'bmi_reading': _bmiReadingController.text,
                          'bmi_result': _bmiResultController.text,
                        },
                        widget.employeeId);
                  }
                  ;
                },
                borderRadius: BorderRadius.circular(16.0),
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60.0, vertical: 14.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.basic
                            .primaryColorDark // Use canvasColor from dark theme
                        : AppTheme.light
                            .primaryColorLight, // Use canvasColor from light theme
                  ),
                  child: Text(
                    'Save',
                    style: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
