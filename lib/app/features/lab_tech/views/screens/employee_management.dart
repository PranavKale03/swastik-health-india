import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_health_india/app/config/themes/app_theme.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';
import 'package:swastik_health_india/app/features/admin/models/company.dart';
import 'package:swastik_health_india/app/features/lab_tech/models/employee.dart';
import 'package:swastik_health_india/app/features/lab_tech/views/screens/EmployeeTestForms/audiometry_test_form.dart';
import 'package:swastik_health_india/app/features/lab_tech/views/screens/EmployeeTestForms/body_mass_index_form.dart';
import 'package:swastik_health_india/app/features/lab_tech/views/screens/EmployeeTestForms/lung_function_test_form.dart';
import 'package:swastik_health_india/app/features/lab_tech/views/screens/EmployeeTestForms/vision_test_form.dart';

class AssignedCompanySelection extends StatefulWidget {
  const AssignedCompanySelection({Key? key}) : super(key: key);

  @override
  _AssignedCompanySelectionState createState() =>
      _AssignedCompanySelectionState();
}

class _AssignedCompanySelectionState extends State<AssignedCompanySelection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<CompanyData> _companies = [];
  String? _selectedCompany;
  List<EmployeesModel> _employees = [];
  bool _audiometryTest = false;
  bool _visionTest = false;
  bool _lungFunctionTest = false;
  bool _bodyCompositionTest = false;
  // ignore: prefer_final_fields
  List<Map<String, dynamic>> _assignedCompanies = [];

  @override
  void initState() {
    super.initState();
    fetchAssignedCompanies();
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

  Future<void> fetchAssignedCompanies() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? id = pref.getString('id');
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID is not available.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final url = Uri.parse(
          'https://swastik-health-india-api.onrender.com/api/labtech/getuser?id=$id');
      final response = await http.get(url);
      // print(response.body);
      if (response.statusCode == 200) {
        final dynamic userData = json.decode(response.body);
        // print(userData); // Ensure this output matches expected structure

        if (userData != null && userData['assigned_companies'] != null) {
          final assignedCompanies =
              List<Map<String, dynamic>>.from(userData['assigned_companies']);
          // print('dsfszdd');

          // print(assignedCompanies);
          setState(() {
            _companies = assignedCompanies
                .map((companyAssignment) =>
                    CompanyData.fromJson(companyAssignment['company']))
                .toList();
            _assignedCompanies = assignedCompanies;
            // print('hhhhhhhhhhhhhhhhhhh')  ;

            // print(_assignedCompanies)  ;
            if (_companies.isNotEmpty) {
              _updateTestVisibility(_companies.first.id);
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No companies assigned.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to load user details. Status code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load user details. Exception: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchEmployeesByCompanyId(String companyId) async {
    showLoadingDialog(context);

    try {
      final url = Uri.parse(
          'https://swastik-health-india-api.onrender.com/api/company/getcompany?id=$companyId');
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        dismissLoadingDialog(context);

        final dynamic companyData = json.decode(response.body);
        if (companyData != null && companyData['employees'] != null) {
          final List<dynamic> employeeList = companyData['employees'];
          setState(() {
            _employees = employeeList
                .map((json) => EmployeesModel.fromJson(json))
                .toList();
          });
        } else {
          dismissLoadingDialog(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No employees found for this company.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        dismissLoadingDialog(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to load employees. Status code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      dismissLoadingDialog(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load employees. Exception: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateTestVisibility(String? companyId) {
    if (companyId != null) {
      final company = _assignedCompanies.firstWhere(
          (element) => element['company']['_id'] == companyId,
          orElse: () => {});
      setState(() {
        _audiometryTest = company['audiometry_test'] ?? false;
        _visionTest = company['vision_test'] ?? false;
        _lungFunctionTest = company['lungfunction_test'] ?? false;
        _bodyCompositionTest = company['body_composition_test'] ?? false;
      });
      // print("Audiometry Test: $_audiometryTest");
      // print("Vision Test: $_visionTest");
      // print("Lung Function Test: $_lungFunctionTest");
      // print("Body Composition Test: $_bodyCompositionTest");
    }
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
              ? AppTheme.basic.canvasColor // Use canvasColor from dark theme
              : AppTheme.light.canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assigned Work',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Assigned Companies',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Company Name',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedCompany,
                      items: _companies
                          .map<DropdownMenuItem<String>>((CompanyData company) {
                        return DropdownMenuItem<String>(
                          value: company.id,
                          child: Text(company.name),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCompany = newValue;
                          _updateTestVisibility(newValue);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a company';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Material(
                    child: InkWell(
                      onTap: () {
                        final form = _formKey.currentState;
                        if (form!.validate()) {
                          fetchEmployeesByCompanyId(_selectedCompany!);
                        }
                      },
                      borderRadius: BorderRadius.circular(16.0),
                      child: Ink(
                        width: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 14.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: const Text(
                          'Fetch Employees',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    const DataColumn(
                      label: Text("Name"),
                    ),
                    const DataColumn(
                      label: Text("Age"),
                    ),
                    const DataColumn(
                      label: Text("Gender"),
                    ),
                    if (_audiometryTest)
                      const DataColumn(
                        label: Text("Audiometry Test"),
                      ),
                    if (_visionTest)
                      const DataColumn(
                        label: Text("Vision Test"),
                      ),
                    if (_lungFunctionTest)
                      const DataColumn(
                        label: Text("Lung Function Test"),
                      ),
                    if (_bodyCompositionTest)
                      const DataColumn(
                        label: Text("Body Composition Test"),
                      ),
                  ],
                  rows: List.generate(
                    _employees.length,
                    (index) => DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              const Icon(Icons.person),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: Text(_employees[index].name!),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(_employees[index].age!)),
                        DataCell(Text(_employees[index].gender!)),
                        if (_bodyCompositionTest)
                          DataCell(
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _employees[index].visionTest
                                      ? const Color.fromARGB(255, 22, 111, 25)
                                      : const Color.fromARGB(255, 211, 127, 0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BodyMassIndexForm(
                                        resetForm: () {},
                                        saveEmployees: () {},
                                        employeeId:
                                            _employees[index].id.toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Body Composition Test')),
                          ),
                        if (_audiometryTest)
                          DataCell(
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _employees[index].visionTest
                                      ? const Color.fromARGB(255, 22, 111, 25)
                                      : const Color.fromARGB(255, 211, 127, 0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AudiometryForm(
                                        resetForm: () {},
                                        saveEmployees: () {},
                                        employeeId:
                                            _employees[index].id.toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Audiometry Test')),
                          ),
                        if (_lungFunctionTest)
                          DataCell(
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _employees[index].visionTest
                                      ? const Color.fromARGB(255, 22, 111, 25)
                                      : const Color.fromARGB(255, 211, 127, 0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LungFunctionForm(
                                        resetForm: () {},
                                        saveEmployees: () {},
                                        employeeId:
                                            _employees[index].id.toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Lung Function Test')),
                          ),
                        if (_visionTest)
                          DataCell(
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _employees[index].visionTest
                                      ? const Color.fromARGB(255, 22, 111, 25)
                                      : const Color.fromARGB(255, 211, 127, 0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VisionTestForm(
                                        resetForm: () {},
                                        saveEmployees: () {},
                                        employeeId:
                                            _employees[index].id.toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Vision Test')),
                          ),
                      ],
                    ),
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
