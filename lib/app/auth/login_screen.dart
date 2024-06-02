import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_health_india/app/auth/responsive_widget.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:swastik_health_india/app/features/admin/views/screens/admin_dashboard_screen.dart';
import 'package:swastik_health_india/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:swastik_health_india/app/features/doctor/views/screens/doctor_dashboard_screen.dart';
import 'package:swastik_health_india/app/features/lab_tech/views/screens/labTech_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String selectedRole = "Admin";

  Future<void> login() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters long'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String uri;
      if (selectedRole == 'Master Admin') {
        uri = 'https://swastik-health-india-api.onrender.com/api/master/login';
      } else if (selectedRole == 'Admin') {
        uri = 'https://swastik-health-india-api.onrender.com/api/admin/login';
      } else if (selectedRole == 'Lab Technician') {
        uri = 'https://swastik-health-india-api.onrender.com/api/labtech/login';
      } else if (selectedRole == 'Doctor') {
        uri = 'https://swastik-health-india-api.onrender.com/api/doctor/login';
      } else {
        uri = 'https://swastik-health-india-api.onrender.com/api/login';
      }

      final url = Uri.parse(uri);

      final jsonData = {
        'email': emailController.text,
        'password': passwordController.text,
      };

      final response = await http.post(
        url,
        body: json.encode(jsonData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Login Successful...(:',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
          ),
        );
        prefs.setBool('isLoggedIn', true);
        prefs.setString('role', selectedRole);
        prefs.setString('id', responseData['user']['_id']);
        prefs.setString('name', responseData['user']['name']);
        prefs.setString('email', responseData['user']['email']);
        prefs.setString('mobile', responseData['user']['mobile']);

        if (selectedRole == "Master Admin") {
          Get.to(const DashboardScreen());
        } else if (selectedRole == "Admin") {
          Get.to(const AdminDashboardScreen());
        } else if (selectedRole == "Lab Technician") {
          Get.to(const LabTechDashboardScreen());
        } else if (selectedRole == "Doctor") {
          Get.to(const DoctorDashboardScreen());
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json.decode(response.body)['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveWidget.isSmallScreen(context)
                ? const SizedBox()
                : Expanded(
                    child: Container(
                      height: height,
                      color: const Color.fromRGBO(0, 91, 224, 1),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            ImageRasterPath.swastiklogo,
                            height: 200,
                            width: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: Container(
                height: height,
                margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveWidget.isSmallScreen(context)
                        ? height * 0.032
                        : height * 0.12),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.2),
                      const Text(
                        'Let\'s Sign In 👇',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'Hey, Enter your details to get sign in \nto your account.',
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Choose Role to Login'),
                      DropdownButton<String>(
                        value: selectedRole,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRole = newValue!;
                          });
                        },
                        items: <String>[
                          'Master Admin',
                          'Admin',
                          'Lab Technician',
                          'Doctor'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Email',
                          style: ralewayStyle.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff252B5C),
                            fontSize: 16.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Color.fromRGBO(0, 0, 0, 0.541),
                              size: 20,
                            ),
                            contentPadding: const EdgeInsets.only(top: 16.0),
                            hintText: 'Enter Email',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(37, 43, 92, 1)
                                  .withOpacity(0.5),
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.014),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Password',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(37, 43, 92, 1),
                            fontSize: 16.0,
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.black54,
                                size: 20,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black54,
                              size: 20,
                            ),
                            contentPadding: const EdgeInsets.only(top: 16.0),
                            hintText: 'Enter Password',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(37, 43, 92, 1)
                                  .withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: ralewayStyle.copyWith(
                              fontSize: 12.0,
                              color: const Color.fromRGBO(0, 91, 224, 1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      Material(
                        color: const Color.fromRGBO(0, 0, 0, 0),
                        child: InkWell(
                          onTap: () {
                            login();
                          },
                          borderRadius: BorderRadius.circular(16.0),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70.0, vertical: 18.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: const Color.fromRGBO(0, 91, 224, 1),
                            ),
                            child: Text(
                              'Sign In',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
