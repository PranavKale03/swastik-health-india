// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:swastik_health_india/app/config/themes/app_theme.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';
import 'package:swastik_health_india/app/features/admin/models/company.dart';
import 'package:swastik_health_india/app/features/admin/models/employee.dart';
import 'package:http/http.dart' as http;
import 'package:swastik_health_india/app/features/admin/views/screens/EmployeeManagement/employee_form.dart';

DataRow recentFileDataRow(EmployeesModel fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            const Icon(Icons.person),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.name!),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.age!)),
      DataCell(Text(fileInfo.email!)),
      DataCell(Text(fileInfo.gender!)),
    ],
  );
}

class CompanySelection extends StatefulWidget {
  const CompanySelection({Key? key}) : super(key: key);

  @override
  _CompanySelectionState createState() => _CompanySelectionState();
}

class _CompanySelectionState extends State<CompanySelection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<CompanyData> _companies = [];
  String? _selectedCompany;
  List<EmployeesModel> _employees = [];
  List<EmployeeForm> _employeeForms = [];
  bool _isFormOpened = false;

  @override
  void initState() {
    super.initState();
    fetchAllCompanies();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _employeeForms.clear();
      _employeeForms.add(EmployeeForm(
        saveEmployees: () {},
        resetForm: () {},
      ));
    });
  }

  void _saveEmployees(BuildContext context) async {
    for (var form in _employeeForms) {
      final newEmployee = form.getEmployeeData();
      final newEmployeeJson = json.encode(newEmployee);
      final url = Uri.parse('http://localhost:5500/api/employee/create');
      try {
        final response = await http.post(url,
            body: newEmployeeJson,
            headers: {'Content-Type': 'application/json'});
        if (response.statusCode == 200) {
          final employeeId = json.decode(response.body)['_id'];
          addEmployeeToCompany(_selectedCompany!, employeeId);
          _resetForm();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'somthing Went Wrong Status code: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        // print(error.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add employee. Exception: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> fetchAllCompanies() async {
    try {
      final url = Uri.parse(
          'http://localhost:5500/api/company/getAll'); // Replace with your API URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> companyList = json.decode(response.body);
        setState(() {
          _companies =
              companyList.map((json) => CompanyData.fromJson(json)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to load companies. Status code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load companies. Exception: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchEmployeesByCompanyId(String companyId) async {
    try {
      final url = Uri.parse(
          'http://localhost:5500/api/company/getcompany?id=$companyId');
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final dynamic companyData = json.decode(response.body);
        if (companyData != null) {
          final List<dynamic> employeeList = companyData['employees'];
          setState(() {
            _employees = employeeList
                .map((json) => EmployeesModel.fromJson(json))
                .toList();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No employees found for this company.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to load employees. Status code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load employees. Exception: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> addEmployeeToCompany(String companyId, String employeeId) async {
    try {
      final url = Uri.parse('http://localhost:5500/api/company/addemployee');
      final response = await http.post(url,
          body:
              json.encode({'company_id': companyId, 'employee_id': employeeId}),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Employee added to the company successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _isFormOpened =
              false; // Set _isFormOpened to false when the form is closed
          _employeeForms.removeLast();
          fetchEmployeesByCompanyId(_selectedCompany!);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to add employee to the company. Status code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add employee to the company. Exception: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addEmployeeForm() {
    setState(() {
      _isFormOpened = true;
      _employeeForms.add(EmployeeForm(
        resetForm: _resetForm,
        saveEmployees: () {
          _saveEmployees(context);
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1, // Set the elevation value as needed
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16.0), // Assuming defaultPadding is 16.0
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.basic.canvasColor // Use canvasColor from dark theme
              : AppTheme.light.canvasColor, // Use canvasColor from light theme
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Employee Management',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Select Company',
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
                            horizontal: 24.0,
                            vertical: 14.0), // Adjust as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppTheme.basic
                                  .primaryColorDark // Use primaryColorDark from dark theme
                              : AppTheme.light
                                  .primaryColorLight, // Use primaryColorLight from light theme
                        ),
                        child: const Center(
                          child: Text(
                            'Search',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Material(
                    child: InkWell(
                      onTap: () {
                        final form = _formKey.currentState;
                        if (form!.validate()) {
                          _addEmployeeForm();
                        }
                      },
                      borderRadius: BorderRadius.circular(16.0),
                      child: Ink(
                        width: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                            vertical: 14.0), // Adjust as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppTheme.basic
                                  .primaryColorDark // Use primaryColorDark from dark theme
                              : AppTheme.light
                                  .primaryColorLight, // Use primaryColorLight from light theme
                        ),
                        child: const Center(
                          child: Text(
                            'Add Employees',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_isFormOpened)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Employee Form',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    // Conditionally show the close button
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _isFormOpened =
                              false; // Set _isFormOpened to false when the form is closed
                          _employeeForms.removeLast();
                        });
                      },
                    ),
                  ],
                ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _employeeForms.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: _employeeForms[index]),
                          if (_employeeForms.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _employeeForms.removeAt(index);
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (index == _employeeForms.length - 1 &&
                          _employeeForms.length < 20)
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _employeeForms.add(EmployeeForm(
                                  resetForm: () {},
                                  saveEmployees: () {},
                                ));
                              });
                            },
                            child: const Text('Add More'),
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              if (_isFormOpened)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _resetForm,
                      child: const Text('Reset'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveEmployees(context);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              Text(
                "Recent Employees/Patients",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: defaultPadding,
                  columns: const [
                    DataColumn(
                      label: Text("Name"),
                    ),
                    DataColumn(
                      label: Text("Age"),
                    ),
                    DataColumn(
                      label: Text("Email"),
                    ),
                    DataColumn(
                      label: Text("Gender"),
                    ),
                  ],
                  rows: List.generate(
                    _employees.length,
                    (index) => recentFileDataRow(_employees[index]),
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
