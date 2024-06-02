import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_health_india/app/auth/login_screen.dart';
import 'package:swastik_health_india/app/features/admin/views/screens/admin_dashboard_screen.dart';
import 'package:swastik_health_india/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:swastik_health_india/app/features/doctor/views/screens/doctor_dashboard_screen.dart';
import 'package:swastik_health_india/app/features/lab_tech/views/screens/labTech_dashboard_screen.dart';
import 'app/config/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(DashboardController());
  Get.put(AdminDashboardController());
  Get.put(LabTechDashboardController());
  Get.put(DoctorDashboardController());


  final prefs = await SharedPreferences.getInstance();
  final role = prefs.getString('role');

  runApp(MyApp(role: role));
}

class MyApp extends StatelessWidget {
  final String? role;

  const MyApp({Key? key, this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    Widget initialScreen = role != null ? const DashboardScreen() : const LoginScreen();
    
    // Define a mapping of roles to corresponding dashboard screens
    final Map<String, Widget> roleToDashboard = {
      'Master Admin': const DashboardScreen(),
      'Admin': const AdminDashboardScreen(),
      'Lab Technician': const LabTechDashboardScreen(),

      // Add more roles and corresponding screens as needed
    };

    // Navigate to the appropriate screen based on the role
    if (role != null && roleToDashboard.containsKey(role)) {
      initialScreen = roleToDashboard[role]!;
    }

    return GetMaterialApp(
      title: 'Swastik Health India',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.basic,
      home: initialScreen,
    );
  }
}
