// ignore_for_file: unnecessary_null_comparison, avoid_web_libraries_in_flutter
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:swastik_health_india/app/config/themes/app_theme.dart';
import '../../../../../constans/app_constants.dart';

class AudiometryForm extends StatefulWidget {
  final VoidCallback resetForm;
  final String employeeId;
  final VoidCallback saveEmployees;
  const AudiometryForm({
    Key? key,
    required this.resetForm,
    required this.saveEmployees,
    required this.employeeId,
  }) : super(key: key);

  @override
  _AudiometryFormState createState() => _AudiometryFormState();
}

class _AudiometryFormState extends State<AudiometryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _rightEarController = TextEditingController();
  final TextEditingController _leftEarController = TextEditingController();
  final TextEditingController _audiometryResultController =
      TextEditingController();

  void _resetForm() {
    _formKey.currentState?.reset();
    _rightEarController.clear();
    _leftEarController.clear();
    _audiometryResultController.clear();
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
    return Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme
                      .basic.canvasColor // Use canvasColor from dark theme
                  : AppTheme.light.canvasColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Complete Employee Form'),
                // actions: [
                //   IconButton(
                //     icon: const Icon(Icons.save),
                //     onPressed: () {
                //       _sendDataToApi(
                //           '/audiometry',
                //           {
                //             'rightEar': _rightEarController.text,
                //             'leftEar': _leftEarController.text,
                //             'result': _audiometryResultController.text,
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
                      // Audiometry Section
                      _buildAudiometrySection(),
                    ],
                  ),
                ),
              ),
            )));
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
                        'audiometry',
                        {
                          'rightEar': _rightEarController.text,
                          'leftEar': _leftEarController.text,
                          'result': _audiometryResultController.text,
                        },
                        widget.employeeId);
                  }
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
