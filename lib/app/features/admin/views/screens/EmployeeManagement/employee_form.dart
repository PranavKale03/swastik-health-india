import 'package:flutter/material.dart';
import 'dart:html' as html;

class EmployeeForm extends StatefulWidget {
  final VoidCallback resetForm;
  final VoidCallback saveEmployees;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  String _selectedImageURL = "";

  EmployeeForm({Key? key, required this.resetForm, required this.saveEmployees})
      : super(key: key) {
    genderController.text = '';
  }

  @override
  _EmployeeFormState createState() => _EmployeeFormState();

  bool isValid() {
    return nameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        genderController.text.isNotEmpty;
  }

  Map<String, dynamic> getEmployeeData() {
    return {
      'name': nameController.text,
      'age': ageController.text,
      'email': emailController.text,
      'gender': genderController.text,
      'mobile': mobileController.text,
      'employee_id': employeeIdController.text,
      'profile_image': _selectedImageURL
    };
  }
}

class _EmployeeFormState extends State<EmployeeForm> {
  void _handleImageUpload() {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*'; // accept only image files
    input.click();

    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = html.FileReader();

      reader.onLoadEnd.listen((loadEndEvent) {
        setState(() {
          widget._selectedImageURL = reader.result as String;
        });
      });

      reader.onError.listen((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });

      reader.readAsDataUrl(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _handleImageUpload,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                    image: widget._selectedImageURL.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(widget._selectedImageURL),
                            fit: BoxFit.cover,
                            onError: (_, __) {
                              setState(() {
                                widget._selectedImageURL = '';
                              });
                            },
                          )
                        : null,
                  ),
                  child: widget._selectedImageURL.isEmpty
                      ? const Icon(Icons.person, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: widget.ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the age';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: widget.mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the mobile number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid Mobile Number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.employeeIdController,
                  decoration: const InputDecoration(
                    labelText: 'Employee Id',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Employee Id';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: widget.genderController.text,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      widget.genderController.text = newValue!;
                    });
                  },
                  items: ['Male', 'Female', 'Other', '']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
