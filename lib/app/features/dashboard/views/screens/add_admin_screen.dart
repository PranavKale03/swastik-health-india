// ignore_for_file: unused_field
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:swastik_health_india/app/config/themes/app_theme.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';
import 'package:swastik_health_india/app/features/dashboard/models/adminlist.dart';

class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({Key? key}) : super(key: key);

  @override
  _AddAdminScreenState createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cnfpasswordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> createAdmin(_fullName, _email, _mobile, _password) async {
    DateTime now = DateTime.now();
    String formattedDate = now.toIso8601String();
   
    try {
      final url = Uri.parse('https://swastik-health-india-api.onrender.com/api/admin/create');
      final jsonData = {
        'name': _fullName,
        'email': _email,
        'mobile': _mobile,
        'password': _password,
        'companies': [],
        'lab_technicians': [],
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
            content: Text('Admin added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _passwordController.clear();
        _emailController.clear();
        _fullNameController.clear();
        _mobileController.clear();
        _cnfpasswordController.clear();

      } else {
        // Show error message if request fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add admin. Error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show error message if exception occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add admin. Exe: $e'),
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
                  'Add Admin',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile No',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
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
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cnfpasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final password = _passwordController.text;
                    if (value != password) {
                      return 'Passwords do not match';
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
                            form.reset();
                            // Clear text controller values
                            _passwordController.clear();
                            // Optionally, you can also clear other text controller values here
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
                    const SizedBox(
                        width: 16), // Add some spacing between buttons

                    Material(
                      child: InkWell(
                        onTap: () {
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            createAdmin(_fullNameController.text, _emailController.text,
                                _mobileController.text, _passwordController.text);
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
                            'Add',
                            style: ralewayStyle.copyWith(
                              color: Colors.white,
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

class AdminList extends StatelessWidget {
  final AdminData admins;
  final Function() onPressedNotification;

  const AdminList({
    required this.admins,
    required this.onPressedNotification,
    Key? key,
  }) : super(key: key);
   void _deleteAdmin(BuildContext context, String adminId) async {
      final url = Uri.parse('https://swastik-health-india-api.onrender.com/api/admin/delete');
      try {
        final response = await http.post(url,body: {"_id":adminId});
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Admin deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete Admin. Status code: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete company. Exception: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Function to generate a random color based on the name's first letter
    Color _generateRandomColor(String name) {
      // Choose a random hue value
      final int hue = name.codeUnitAt(0) % 360;
      // Create a color with the chosen hue
      final Color color = HSLColor.fromAHSL(1.0, hue.toDouble(), 0.5, 0.5).toColor();
      return color;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: CircleAvatar(
        backgroundColor:_generateRandomColor(admins.name),
        child: Text(
                admins.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
      ),
      title: Text(
        admins.name,
        style: const TextStyle(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        admins.email,
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
                     _deleteAdmin(context, admins.id); 
                    // Delete admin logic
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


class AllAdmins extends StatelessWidget {
  const AllAdmins({
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
              const TextSpan(text: "All Admins"),
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
