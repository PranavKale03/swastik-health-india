// ignore_for_file: unnecessary_null_comparison, avoid_web_libraries_in_flutter
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompleteEmployeeForm extends StatefulWidget {
  final VoidCallback resetForm;
  final String employeeId;
  final VoidCallback saveEmployees;
  const CompleteEmployeeForm({
    Key? key,
    required this.resetForm,
    required this.saveEmployees,
    required this.employeeId,
  }) : super(key: key);

  @override
  _CompleteEmployeeFormState createState() => _CompleteEmployeeFormState();
}

class _CompleteEmployeeFormState extends State<CompleteEmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bmiResultController = TextEditingController();
  final TextEditingController _bmiReadingController = TextEditingController();
  final TextEditingController _pathologyReportController =
      TextEditingController();
  final TextEditingController _rightEarController = TextEditingController();
  final TextEditingController _leftEarController = TextEditingController();
  final TextEditingController _audiometryResultController =
      TextEditingController();
  final TextEditingController _fvcController = TextEditingController();
  final TextEditingController _fvc1Controller = TextEditingController();
  final TextEditingController _fvcpercentController = TextEditingController();
  final TextEditingController _fvcresultController = TextEditingController();
  final TextEditingController _lungsResultController = TextEditingController();
  final TextEditingController _snellenRightEyeController =
      TextEditingController();
  final TextEditingController _snellenLeftEyeController =
      TextEditingController();
  final TextEditingController _nearVisionRightEyeController =
      TextEditingController();
  final TextEditingController _nearVisionLeftEyeController =
      TextEditingController();
  final TextEditingController _visionResultController = TextEditingController();

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
    _pathologyReportController.clear();
    _rightEarController.clear();
    _leftEarController.clear();
    _audiometryResultController.clear();
    _fvcController.clear();
    _fvc1Controller.clear();
    _lungsResultController.clear();
    _snellenRightEyeController.clear();
    _snellenLeftEyeController.clear();
    _nearVisionRightEyeController.clear();
    _nearVisionLeftEyeController.clear();
    _visionResultController.clear();
  }

  void _sendDataToApi(
      String uri, Map<String, dynamic> data, String employeeId) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        var response = await http.post(
          Uri.parse('https://swastik-health-india-api.onrender.com/api/employee$uri'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              {...data, 'id': employeeId}), // Include employeeId in the data
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data sent successfully to $uri'),
              backgroundColor: Colors.green,
            ),
          );
          _resetForm();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send data to $uri')),
          );
        }
      } catch (e) {
        print('Error sending data to $uri: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending data to $uri')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Employee Form'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _sendDataToApi(
                  '/vitals',
                  {
                    'id': widget.employeeId,
                    'height': _heightController.text,
                    'weight': _weightController.text,
                    'bmi_reading': _bmiReadingController.text,
                    'bmi_result': _bmiResultController.text,
                  },
                  widget.employeeId);
              _sendDataToApi(
                  '/audiometry',
                  {
                    'rightEar': _rightEarController.text,
                    'leftEar': _leftEarController.text,
                    'result': _audiometryResultController.text,
                  },
                  widget.employeeId);
              _sendDataToApi(
                  '/lungfunction',
                  {
                    'FVC': _fvcController.text,
                    'FEV1': _fvc1Controller.text,
                    'percent': _fvcpercentController.text,
                    'result': _fvcresultController.text,
                  },
                  widget.employeeId);
              _sendDataToApi(
                  '/vision',
                  {
                    'snellen_chart': {
                      'right_eye': _snellenRightEyeController.text,
                      'left_eye': _snellenLeftEyeController.text,
                    },
                    'near_vision': {
                      'right_eye': _nearVisionRightEyeController.text,
                      'left_eye': _nearVisionLeftEyeController.text,
                    },
                    'result': _visionResultController.text,
                  },
                  widget.employeeId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetForm,
          ),
        ],
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

              // Audiometry Section
              _buildAudiometrySection(),

              // Lungs Function Test Section
              _buildLungsFunctionTestSection(),

              // Vision Test Section
              _buildVisionTestSection(),
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
      ],
    );
  }

  Widget _buildAudiometrySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Audiometry (Pure Tone)'),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _rightEarController,
                decoration: const InputDecoration(
                  labelText: 'Right Ear',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Reading For Right Ear';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                controller: _leftEarController,
                decoration: const InputDecoration(
                  labelText: 'Left Ear',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Reading For Left Ear';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                controller: _audiometryResultController,
                decoration: const InputDecoration(
                  labelText: 'Result',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Reading For Right & Left Ear';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLungsFunctionTestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Lungs Function Test'),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _fvcController,
                decoration: const InputDecoration(
                  labelText: 'FVC (ltr)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter FVC';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                controller: _fvc1Controller,
                decoration: const InputDecoration(
                  labelText: 'FVC1 (ltr)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter FVC1';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                controller: _lungsResultController,
                decoration: const InputDecoration(
                  labelText: '%',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter %';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                controller: _lungsResultController,
                decoration: const InputDecoration(
                  labelText: 'Result',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Values';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildVisionTestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Vision Test'),
        Row(
          children: [
            _buildVisionColumn('Test', [
              'Snellen Chart',
              'Near Vision',
              'Result',
            ]),
            _buildVisionColumn('Right Eye', [
              _snellenRightEyeController,
              _nearVisionRightEyeController,
              _visionResultController,
            ]),
            _buildVisionColumn('Left Eye', [
              _snellenLeftEyeController,
              _nearVisionLeftEyeController,
              _visionResultController,
            ]),
          ],
        ),
      ],
    );
  }

  Widget _buildVisionColumn(String title, List<dynamic> items) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          for (var item in items)
            if (item is String)
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Text(item),
              )
            else if (item is TextEditingController)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, left: 10),
                child: TextFormField(
                  controller: item,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Value';
                    }
                    return null;
                  },
                ),
              ),
        ],
      ),
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
