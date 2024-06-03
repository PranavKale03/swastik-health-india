// ignore_for_file: unused_field, non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_health_india/app/config/themes/app_theme.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';
import 'package:swastik_health_india/app/features/admin/models/company.dart';
import 'package:swastik_health_india/app/features/admin/models/lab_tech.dart';
import 'package:swastik_health_india/app/features/admin/views/screens/admin_dashboard_screen.dart';
import 'package:swastik_health_india/app/utils/helpers/focuse_node.dart';

class AddLabTechScreen extends StatefulWidget {
  const AddLabTechScreen({Key? key}) : super(key: key);

  @override
  _AddLabTechScreenState createState() => _AddLabTechScreenState();
}

class _AddLabTechScreenState extends State<AddLabTechScreen> {
  final TextEditingController _drName = TextEditingController();
  final TextEditingController _dremail = TextEditingController();
  final TextEditingController _drpassword = TextEditingController();
  final TextEditingController _draddress = TextEditingController();
  final TextEditingController _drmobile = TextEditingController();
  final TextEditingController _drcnfpassword = TextEditingController();

  final _drNameFocusNode = FocusNode();
  final _dremailFocusNode = FocusNode();
  final _draddressFocusNode = FocusNode();
  final _drmobileFocusNode = FocusNode();
  final _drpasswordFocusNode = FocusNode();
  final _drpasswordcnfFocusNode = FocusNode();
  final _drsaveFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // List<Map<String, String>> employees = [];
  AdminDashboardController adminController = AdminDashboardController();
  final List<Map<String, dynamic>> _assignedCompanies = [];
  Map<String, dynamic> company = {};
  List<Map<String, String>> _availableCompanies = [];
  @override
  void dispose() {
    _drName.dispose();
    _draddress.dispose();
    _drmobile.dispose();
    _dremail.dispose();
    _drpassword.dispose();
    _drcnfpassword.dispose();

    super.dispose();
  }

  Future<void> sendDataToApi() async {
    // DateTime now = DateTime.now();
    // String formattedDate = now.toIso8601String();
    SharedPreferences pref = await SharedPreferences.getInstance();
    // print("bbbbbbbbbbbbbbbbbbbbb"+pref.getString('id').toString());
    try {
      final url = Uri.parse('https://swastik-health-india-api.onrender.com/api/labtech/create');
      final jsonData = {
        'name': _drName.text,
        'email': _dremail.text,
        'password': _drpassword.text,
        'address': _draddress.text,
        'mobile': _drmobile.text,
        'admin_id': pref.getString('id'),
        'assigned_companies': [],
      };

      final response = await http.post(
        url,
        body: json.encode(jsonData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final labTechId = responseData['_id'];

        // Assign companies to the lab technician
        await assignCompaniesToLabTech(labTechId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lab Tech added successfully'),
            backgroundColor: Colors.green,
          ),
        );

        _formKey.currentState?.reset();
        _drName.clear();
        _dremail.clear();
        _draddress.clear();
        _drmobile.clear();
        _drpassword.clear();
        _drcnfpassword.clear();
        setState(() {});
      } else {
        // Show error message if request fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to add Lab Tech. Error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show error message if exception occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add Lab Tech. Exe: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> assignCompaniesToLabTech(String labTechId) async {
    final url = Uri.parse('https://swastik-health-india-api.onrender.com/api/labtech/assign');
    for (var company in _assignedCompanies) {
      final jsonData = {
        'company_id': company['company_id'],
        'lab_technician_id': labTechId,
      };

      final response = await http.post(
        url,
        body: json.encode(jsonData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to assign company ${company['company']} to Lab Tech.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addCompanyField() {
    if (_assignedCompanies.length < 4) {
      adminController.fetchCompanies().then((companies) {
        setState(() {
          _availableCompanies.clear();
          _availableCompanies = companies.map((company) {
            return {
              'id': company.id,
              'name': company.name,
            };
          }).toList();
          _assignedCompanies.add({
            'company': null,
            'audiometry_test': false,
            'vision_test': false,
            'lungfunction_test': false,
            'body_composition_test': false,
          });
        });
      }).catchError((error) {
        // Handle errors if any
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch companies: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot assign more than 4 companies'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeCompanyField(int index) {
    setState(() {
      _assignedCompanies.removeAt(index);
    });
  }

  Widget _buildCompanyAssignment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Assign Companies:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addCompanyField,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._assignedCompanies.asMap().entries.map((entry) {
          int index = entry.key;
          company = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        // value: _selectedValue,
                        decoration: InputDecoration(
                          labelText: 'Select Company',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 2.0),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (String? newValue) {
                          setState(() {
                            company["company_id"] = newValue;
                          });
                        },
                        items: _availableCompanies.map((company) {
                          return DropdownMenuItem<String>(
                            value: company['id'],
                            child: Text(company['name'] ?? ''),
                          );
                        }).toList(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeCompanyField(index),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCheckbox(
                      'Audiometry Test',
                      company['audiometry_test'],
                      (value) {
                        setState(() {
                          company['audiometry_test'] = value;
                        });
                      },
                    ),
                    _buildCheckbox(
                      'Vision Test',
                      company['vision_test'],
                      (value) {
                        setState(() {
                          company['vision_test'] = value;
                        });
                      },
                    ),
                    _buildCheckbox(
                      'Lung Function Test',
                      company['lungfunction_test'],
                      (value) {
                        setState(() {
                          company['lungfunction_test'] = value;
                        });
                      },
                    ),
                    _buildCheckbox(
                      'Body Composition Test',
                      company['body_composition_test'],
                      (value) {
                        setState(() {
                          company['body_composition_test'] = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCheckbox(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(title),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1, // Set the elevation value as needed
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.basic.canvasColor // Use canvasColor from dark theme
              : AppTheme.light.canvasColor,
          // Use canvasColor from light theme
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Lab Tech',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  focusNode: _drNameFocusNode,
                  // onFieldSubmitted: (value) {
                  //   fieldFocusChange(
                  //       context, _companyNameFocusNode, _companyemailFocusNode);
                  // },
                  onEditingComplete: () => FocusScope.of(context)
                      .requestFocus(_dremailFocusNode),
                  controller: _drName,
                  decoration: const InputDecoration(
                    labelText: 'Lab Tech Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Company Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  focusNode: _dremailFocusNode,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _dremailFocusNode,
                        _drmobileFocusNode);
                  },
                  controller: _dremail,
                  decoration: const InputDecoration(
                    labelText: 'Lab Tech Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  focusNode: _drmobileFocusNode,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _drmobileFocusNode,
                        _draddressFocusNode);
                  },
                  controller: _drmobile,
                  decoration: const InputDecoration(
                    labelText: 'Lab Tech Mobile No',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Mobile Number';
                    }
                    if (value.length > 10 || value.length < 10) {
                      return 'Please enter Mobile Number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  focusNode: _draddressFocusNode,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _draddressFocusNode,
                        _drpasswordFocusNode);
                  },
                  controller: _draddress,
                  decoration: const InputDecoration(
                    labelText: 'Lab Tech Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  focusNode: _drpasswordFocusNode,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _drpasswordFocusNode,
                        _drpasswordcnfFocusNode);
                  },
                  controller: _drpassword,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  focusNode: _drpasswordcnfFocusNode,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _drpasswordcnfFocusNode,
                        _drsaveFocusNode);
                  },
                  controller: _drcnfpassword,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password again';
                    }
                    if (value != _drpassword.text) {
                      return 'Password doesn\'t match';
                    }
                    return null;
                  },
                ),
                _buildCompanyAssignment(),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Align buttons to the end of the row
                  children: [
                    Material(
                      child: InkWell(
                        onTap: () {
                          final form = _formKey.currentState;
                          if (form != null) {
                            _formKey.currentState?.reset();
                            _drName.clear();
                            _dremail.clear();
                            _draddress.clear();
                            _drmobile.clear();
                            _drpassword.clear();
                            _drcnfpassword.clear();
                            _assignedCompanies.clear();
                            setState(() {});
                          }
                        },
                        borderRadius: BorderRadius.circular(16.0),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 14.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
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
                        focusNode: _drsaveFocusNode,
                        onTap: () {
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            sendDataToApi();
                          }
                        },
                        borderRadius: BorderRadius.circular(16.0),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60.0, vertical: 14.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? AppTheme.basic
                                    .primaryColorDark // Use canvasColor from dark theme
                                : AppTheme.light
                                    .primaryColorLight, // Use canvasColor from light theme
                          ),
                          child: Text(
                            'Add Lab Tech',
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
              ]
                  .expand((widget) => [widget, const SizedBox(height: 10)])
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class LabTechList extends StatelessWidget {
  final LabTechData labtech;
  final Function() onPressedNotification;
  final List<String>?
      availableCompanies; // Optional list of available companies
  final int?
      maxCompanies; // Optional maximum number of companies that can be assigned

  const LabTechList({
    required this.labtech,
    required this.onPressedNotification,
    this.availableCompanies,
    this.maxCompanies,
    Key? key,
  }) : super(key: key);

  void _openManageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ManageLabTechDialog(
          labtech: labtech,
          availableCompanies: availableCompanies ?? [],
          maxCompanies: maxCompanies ?? 4,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Color _generateRandomColor(String name) {
      final int hue = name.codeUnitAt(0) % 360;
      return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.5, 0.5).toColor();
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: CircleAvatar(
        backgroundColor: _generateRandomColor(labtech.name),
        child: Text(
          labtech.name.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        labtech.name,
        style: const TextStyle(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        labtech.email,
        style: const TextStyle(fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: screenWidth >= 600
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _openManageDialog(context);
                  },
                  icon: const Icon(Icons.manage_accounts),
                  tooltip: "Manage",
                ),
                IconButton(
                  onPressed: () {
                    // Add logic for deleting Lab Tech
                  },
                  icon: const Icon(Icons.delete),
                  tooltip: "Delete",
                ),
              ],
            )
          : null,
    );
  }
}

class ManageLabTechDialog extends StatefulWidget {
  final LabTechData labtech;
  final List<String> availableCompanies;
  final int maxCompanies;

  const ManageLabTechDialog({
    required this.labtech,
    this.availableCompanies = const [],
    this.maxCompanies = 3,
    Key? key,
  }) : super(key: key);

  @override
  _ManageLabTechDialogState createState() => _ManageLabTechDialogState();
}

class _ManageLabTechDialogState extends State<ManageLabTechDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController,
      _addressController,
      _passwordController;
  late List<String> _selectedCompanies = [];
  List<CompanyData> _assignedCompaniesData = [];
  final List<Map<String, dynamic>> _assignedCompanies = [];
  Map<String, dynamic> company = {};
  AdminDashboardController adminController = AdminDashboardController();
  List<Map<String, String>> _availableCompanies = [];
  late String lab_technician_id;
  @override
  void initState() {
    super.initState();
    lab_technician_id = widget.labtech.id;
    _nameController = TextEditingController(text: widget.labtech.name);
    _emailController = TextEditingController(text: widget.labtech.email);
    _mobileController = TextEditingController(text: widget.labtech.mobile);
    _addressController = TextEditingController(text: widget.labtech.address);
    _passwordController = TextEditingController(text: widget.labtech.password);
    _selectedCompanies = List.from(widget.labtech.assignedCompanies);
    _fetchAssignedCompanies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _fetchAssignedCompanies() async {
    final List<CompanyData> companies = [];
    for (String companyId in _selectedCompanies) {
      try {
        final response = await http.get(Uri.parse(
            'https://swastik-health-india-api.onrender.com/api/company/getcompany?id=$companyId'));
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          companies.add(CompanyData.fromJson(responseData));
        }
      } catch (e) {
        // print('Error fetching company details: $e');
      }
    }
    setState(() {
      _assignedCompaniesData = companies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildFieldRow('Name', _nameController),
          const SizedBox(height: 10),
          _buildFieldRow('Email', _emailController),
          const SizedBox(height: 10),
          _buildFieldRow('Mobile', _mobileController),
          const SizedBox(height: 20),
          _buildFieldRow('address', _addressController),
          const SizedBox(height: 20),
          _buildFieldRow('password', _passwordController),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Assign Companies',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  _addCompanyField(); // Add company field dynamically
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _assignedCompaniesData.length,
            itemBuilder: (context, index) {
              final company = _assignedCompaniesData[index];
              return _buildCompanyRow(company.name, index);
            },
          ),
          const SizedBox(height: 20),
          ..._assignedCompanies.asMap().entries.map((entry) {
            int index = entry.key;
            company = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          // value: _selectedValue,
                          decoration: InputDecoration(
                            labelText: 'Select Company',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (String? newValue) {
                            setState(() {
                              company["company_id"] = newValue;
                            });
                          },
                          items: _availableCompanies.map((company) {
                            return DropdownMenuItem<String>(
                              value: company['id'],
                              child: Text(company['name'] ?? ''),
                            );
                          }).toList(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeCompanyField(index),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCheckbox(
                        'Audiometry Test',
                        company['audiometry_test'],
                        (value) {
                          setState(() {
                            company['audiometry_test'] = value;
                          });
                        },
                      ),
                      _buildCheckbox(
                        'Vision Test',
                        company['vision_test'],
                        (value) {
                          setState(() {
                            company['vision_test'] = value;
                          });
                        },
                      ),
                      _buildCheckbox(
                        'Lung Function Test',
                        company['lungfunction_test'],
                        (value) {
                          setState(() {
                            company['lungfunction_test'] = value;
                          });
                        },
                      ),
                      _buildCheckbox(
                        'Body Composition Test',
                        company['body_composition_test'],
                        (value) {
                          setState(() {
                            company['body_composition_test'] = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        assignCompaniesToLabTech(lab_technician_id);
                      }, child: const Text("Assign Company")),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          }).toList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Perform actions like saving edited data
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ])));
  }
  Future<void> assignCompaniesToLabTech(String labTechId) async {
    final url = Uri.parse('https://swastik-health-india-api.onrender.com/api/labtech/assign');
    // print(_assignedCompanies);
    for (var company in _assignedCompanies) {
      final jsonData = {
        'company_id': company['company_id'],
        'lab_technician_id': labTechId,
      };

      final response = await http.post(
        url,
        body: json.encode(jsonData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to assign company ${company['company']} to Lab Tech.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
       setState(() {
         _selectedCompanies.clear();
         Navigator.pop(context);
       });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'company successfully assigned ${company['company']} to Lab Tech.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
  Widget _buildCheckbox(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(title),
      ],
    );
  }

  void _addCompanyField() {
    if (_assignedCompanies.isEmpty) {
      adminController.fetchCompanies().then((companies) {
        setState(() {
          _availableCompanies.clear();
          _availableCompanies = companies.map((company) {
            return {
              'id': company.id,
              'name': company.name,
            };
          }).toList();
          _assignedCompanies.add({
            'company': null,
            'audiometry_test': false,
            'vision_test': false,
            'lungfunction_test': false,
            'body_composition_test': false,
          });
        });
      }).catchError((error) {
        // Handle errors if any
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch companies: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot assign more than 1 company at a time'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeCompanyField(int index) {
    setState(() {
      _assignedCompanies.removeAt(index);
    });
  }

  Widget _buildCompanyRow(String companyName, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5), // Adjust border color here
          width: 1.0, // Adjust border width here
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              companyName,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _removeCompany(index);
            },
          ),
        ],
      ),
    );
  }

  void _removeCompany(int index) {
    setState(() {
      _selectedCompanies.removeAt(index);
    });
  }

  Widget _buildFieldRow(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class AllLabTech extends StatelessWidget {
  const AllLabTech({
    required this.totalMember,
    Key? key,
  }) : super(key: key);

  final int totalMember;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kFontColorPallets[0],
            ),
            children: [
              const TextSpan(text: "All Lab Technicians"),
              TextSpan(
                text: "($totalMember)",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: kFontColorPallets[2],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}