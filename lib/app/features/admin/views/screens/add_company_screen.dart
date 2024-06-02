// ignore_for_file: unused_field
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:swastik_health_india/app/config/themes/app_theme.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';
import 'package:swastik_health_india/app/features/admin/models/company.dart';
import 'package:swastik_health_india/app/utils/helpers/focuse_node.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({Key? key}) : super(key: key);

  @override
  _AddcompanyScreenState createState() => _AddcompanyScreenState();
}

class _AddcompanyScreenState extends State<AddCompanyScreen> {
  final TextEditingController _companyName = TextEditingController();
  final TextEditingController _companyemail = TextEditingController();
  final TextEditingController _companyaddress = TextEditingController();
  final TextEditingController _companymobile = TextEditingController();
  final _companyNameFocusNode = FocusNode();
  final _companyemailFocusNode = FocusNode();
  final _companyaddressFocusNode = FocusNode();
  final _companymobileFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // List<Map<String, String>> employees = [];

  @override
  void dispose() {
    _companyName.dispose();
    _companyaddress.dispose();
    _companymobile.dispose();
    _companyemail.dispose();

    super.dispose();
  }

  Future<void> sendDataToApi() async {
    DateTime now = DateTime.now();
    String formattedDate = now.toIso8601String();
    try {
      final url = Uri.parse(
          'https://swastik-health-india-api.onrender.com/api/company/create'); // Replace with your API URL
      final jsonData = {
        'name': _companyName.text,
        'email': _companyemail.text,
        'address': _companyaddress.text,
        'mobile': _companymobile.text,
        'employees': [],
        'last_login': formattedDate,
      };

      final response = await http.post(
        url,
        body: json.encode(jsonData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Company added successfully'),
            backgroundColor: Colors.green,
          ),
        );

        _formKey.currentState?.reset();
        _companyName.clear();
        _companyemail.clear();
        _companyaddress.clear();
        _companymobile.clear();
        setState(() {});
      } else {
        // Show error message if request fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to add company. Error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show error message if exception occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add company. Exe: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                  'Add Company',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  focusNode: _companyNameFocusNode,
                  // onFieldSubmitted: (value) {
                  //   fieldFocusChange(
                  //       context, _companyNameFocusNode, _companyemailFocusNode);
                  // },
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_companyemailFocusNode),
                  controller: _companyName,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
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
                  focusNode: _companyemailFocusNode,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _companyemailFocusNode,
                        _companymobileFocusNode);
                  },
                  controller: _companyemail,
                  decoration: const InputDecoration(
                    labelText: 'Company Email',
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
                  focusNode: _companymobileFocusNode,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _companymobileFocusNode,
                        _companyaddressFocusNode);
                  },
                  controller: _companymobile,
                  decoration: const InputDecoration(
                    labelText: 'Company Mobile No',
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
                  focusNode: _companyaddressFocusNode,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(context, _companyaddressFocusNode,
                        _companyaddressFocusNode);
                  },
                  controller: _companyaddress,
                  decoration: const InputDecoration(
                    labelText: 'Company Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Address';
                    }
                    return null;
                  },
                ),
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
                            _companyName.clear();
                            _companyemail.clear();
                            _companyaddress.clear();
                            _companymobile.clear();
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
                            'Add Company',
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

class CompanyList extends StatelessWidget {
  final CompanyData company;
  final Function() onPressedNotification;

  const CompanyList({
    required this.company,
    required this.onPressedNotification,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Function to generate a random color based on the name's first letter
    Color _generateRandomColor(String name) {
      // Choose a random hue value
      final int hue = name.codeUnitAt(0) % 360;
      // Create a color with the chosen hue
      final Color color =
          HSLColor.fromAHSL(1.0, hue.toDouble(), 0.5, 0.5).toColor();
      return color;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: CircleAvatar(
        backgroundColor: _generateRandomColor(company.name),
        child: Text(
          company.name.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        company.name,
        style: const TextStyle(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        company.email,
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
                    // Manage admin logic
                  },
                  icon: const Icon(Icons.manage_accounts),
                  tooltip: "Manage",
                ),
                IconButton(
                  onPressed: () {
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

class AllCompanies extends StatelessWidget {
  const AllCompanies({
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
              const TextSpan(text: "All Companies"),
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
