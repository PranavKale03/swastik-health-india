// ignore_for_file: unnecessary_null_comparison, avoid_web_libraries_in_flutter
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:swastik_health_india/app/config/themes/app_theme.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';

class LungFunctionForm extends StatefulWidget {
  final VoidCallback resetForm;
  final String employeeId;
  final VoidCallback saveEmployees;
  const LungFunctionForm({
    Key? key,
    required this.resetForm,
    required this.saveEmployees,
    required this.employeeId,
  }) : super(key: key);

  @override
  _LungFunctionFormState createState() => _LungFunctionFormState();
}

class _LungFunctionFormState extends State<LungFunctionForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fvcController = TextEditingController();
  final TextEditingController _fvc1Controller = TextEditingController();
  final TextEditingController _fvcpercentController = TextEditingController();
  final TextEditingController _fvcresultController = TextEditingController();
  final TextEditingController _lungsResultController = TextEditingController();

  void _resetForm() {
    _formKey.currentState?.reset();
    _fvcController.clear();
    _fvc1Controller.clear();
    _fvcpercentController.clear();
    _fvcresultController.clear();
    _lungsResultController.clear();
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
        title: const Text('Lung Function Form'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.save),
        //     onPressed: () {
        //       _sendDataToApi(
        //           '/lungfunction',
        //           {
        //             'FVC': _fvcController.text,
        //             'FEV1': _fvc1Controller.text,
        //             'percent': _fvcpercentController.text,
        //             'result': _fvcresultController.text,
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
              // Lungs Function Test Section
              _buildLungsFunctionTestSection(),
            ],
          ),
        ),
      ),
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
                  labelText: 'Percent',
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
                        'lungfunction',
                        {
                          'FVC': _fvcController.text,
                          'FEV1': _fvc1Controller.text,
                          'percent': _fvcpercentController.text,
                          'result': _fvcresultController.text,
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
