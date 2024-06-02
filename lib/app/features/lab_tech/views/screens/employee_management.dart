import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_health_india/app/config/themes/app_theme.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';
import 'package:swastik_health_india/app/features/admin/models/company.dart';
import 'package:swastik_health_india/app/features/admin/models/employee.dart';
import 'package:swastik_health_india/app/features/lab_tech/views/screens/EmployeeManagement/employee_form.dart';
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

  @override
  void initState() {
    super.initState();
    fetchAllCompanies();
  }

  Future<void> fetchAllCompanies() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? id = pref.getString('id');
    try {
      final url = Uri.parse('https://swastik-health-india-api.onrender.com/api/doctor/getuser?id=$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic userData = json.decode(response.body);
        if (userData != null) {
          final assignedCompanies =
              List<Map<String, dynamic>>.from(userData['assigned_companies']);
          setState(() {
            _companies = assignedCompanies
                .map((json) => CompanyData.fromJson(json))
                .toList();
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
    try {
      final url = Uri.parse(
          'https://swastik-health-india-api.onrender.com/api/company/getcompany?id=$companyId');
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

 void _navigateToEmployeeForm(String employeeId) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CompleteEmployeeForm(
        resetForm: () {},
        saveEmployees: () {},
        employeeId: employeeId, // Pass the employeeId directly
      ), 
    ),
  );
  // Handle navigation back
  fetchAllCompanies(); // Reload data after navigating back
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
                ],
              ),
              const SizedBox(height: 20),
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
                    (index) => DataRow(
                      onLongPress: () =>
                          _navigateToEmployeeForm(_employees[index].id.toString()),
                      cells: [
                        DataCell(GestureDetector(
                          onTap: (() =>
                              _navigateToEmployeeForm(_employees[index].id.toString())),
                          child: Row(
                            children: [
                              const Icon(Icons.person),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: Text(_employees[index].name!),
                              ),
                            ],
                          ),
                        )),
                        DataCell(GestureDetector(
                            onTap: (() =>
                                _navigateToEmployeeForm(_employees[index].id.toString())),
                            child: Text(_employees[index].age!))),
                        DataCell(GestureDetector(
                            onTap: (() =>
                                _navigateToEmployeeForm(_employees[index].id.toString())),
                            child: Text(_employees[index].email!))),
                        DataCell(GestureDetector(
                            onTap: (() =>
                                _navigateToEmployeeForm(_employees[index].id.toString())),
                            child: Text(_employees[index].gender!))),
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
