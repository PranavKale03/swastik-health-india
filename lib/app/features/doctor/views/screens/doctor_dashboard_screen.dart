// ignore: file_names
library dashboard;

import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_health_india/app/auth/login_screen.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';
import 'package:swastik_health_india/app/features/admin/models/company.dart';
import 'package:swastik_health_india/app/features/dashboard/controllers/menu_controller.dart';
import 'package:swastik_health_india/app/features/lab_tech/views/screens/employee_management.dart';
import 'package:swastik_health_india/app/shared_components/chatting_card.dart';
import 'package:swastik_health_india/app/shared_components/responsive_builder.dart';
import 'package:swastik_health_india/app/shared_components/upgrade_premium_card.dart';
import 'package:swastik_health_india/app/shared_components/project_card.dart';
import 'package:swastik_health_india/app/shared_components/search_field.dart';
import 'package:swastik_health_india/app/shared_components/selection_button.dart';
import 'package:swastik_health_india/app/shared_components/task_card.dart';
import 'package:swastik_health_india/app/shared_components/today_text.dart';
import 'package:swastik_health_india/app/utils/helpers/app_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

// binding
part '../../bindings/dashboard_binding.dart';
part '../../controllers/doctor_dashboard_controller.dart';
// models
part '../../models/profile.dart';
part '../components/header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';
part '../components/team_member.dart';

class DoctorDashboardScreen extends GetView<DoctorDashboardController> {
  const DoctorDashboardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : Drawer(
              child: Padding(
                padding: const EdgeInsets.only(top: kSpacing),
                child: _Sidebar(data: controller.getSelectedProject()),
              ),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar
          if (ResponsiveBuilder.isDesktop(context))
            Flexible(
              flex: 2.5.toInt(),
              child: _Sidebar(data: controller.getSelectedProject()),
            ),
          // Main content area
          Expanded(
            flex: 7, // Adjust the flex value as needed
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<_Profile>(
                future: controller.getProfil(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return _buildHeader(
                      onPressedMenu: () => controller.openDrawer(),
                      data: snapshot.data!,
                    );
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
                  Obx(() {
                    final selectedMenuItem =
                        controller.menuController.selectedIndex.value;
                    return Builder(
                      builder: (BuildContext context) {
                        switch (selectedMenuItem) {
                          case 0: // Dashboard
                            return _buildEmployeeContent(context);
                          // case 1: // Employees/Patients
                          //   return _buildAddAdminContent(context);
                          // case 2: // Employees/Patients
                          //   return _buildEmployeeContent(context);
                          case 1: // Add Admin
                            return _buildSettingContent(context);

                          // Add cases for other menu items
                          default:
                            return Container(); // Placeholder for unknown menu items
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          // Right flex
          // Flexible(
          //   flex: 2.5.toInt(),
          //   child: Column(
          //     children: [
          //       const SizedBox(height: kSpacing),
          //       _buildProfile(data: controller.getProfil()),
          //       const Divider(thickness: 1),
          //       const SizedBox(height: kSpacing),
          //       _buildTeamMember(data: controller.getMember()),
          //       const SizedBox(height: kSpacing),
          //       // Padding(
          //       //   padding: const EdgeInsets.symmetric(horizontal: kSpacing),
          //       //   child: GetPremiumCard(onPressed: () {}),
          //       // ),
          //       const SizedBox(height: kSpacing),
          //       const Divider(thickness: 1),
          //       const SizedBox(height: kSpacing),
          //       _buildRecentMessages(data: controller.getChatting()),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSettingContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          onPressed: () {
            controller.logout();
          },
          child: const Text("Log Out"),
        )
      ]),
    );
  }

  Widget _buildEmployeeContent(BuildContext context) {
    return SingleChildScrollView(
        child: ResponsiveBuilder(
      mobileBuilder: (context, constraints) {
        return Column(children: [
          const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
          _buildEmployeeList(
            crossAxisCount: 6,
          ),
          // const SizedBox(height: kSpacing * 2),
        ]);
      },
      tabletBuilder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: (constraints.maxWidth < 950) ? 6 : 9,
              child: Column(
                children: [
                  const SizedBox(height: kSpacing * 2),
                  _buildEmployeeList(
                    crossAxisCount: 6,
                  ),
                  const SizedBox(height: kSpacing),
                ],
              ),
            ),
          ],
        );
      },
      desktopBuilder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 9,
              child: Column(
                children: [
                  _buildEmployeeList(
                    crossAxisCount: 6,
                  ),
                  const SizedBox(height: kSpacing * 2),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: Column(
                children: [
                  const SizedBox(height: kSpacing / 2),
                  _buildEmployeeList(
                    crossAxisCount: 6,
                  ),
                ],
              ),
            )
          ],
        );
      },
    ));
  }

  

  Widget _buildHeader({Function()? onPressedMenu, required _Profile data}) {
    return AppBar(
      automaticallyImplyLeading: false, // Disable the default back button
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (onPressedMenu != null)
            Padding(
              padding: const EdgeInsets.only(right: kSpacing),
              child: IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.menu),
                tooltip: "Menu",
              ),
            ),
          const Expanded(flex: 5, child: _Header()),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              flex: 1,
              child: _ProfilTile(data: data, onPressedNotification: () {}))
        ],
      ),
    );
  }


  Widget _buildEmployeeList({
    int crossAxisCount = 6,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: crossAxisCount,
      itemCount: 1,
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: kSpacing),
          child: AssignedCompanySelection(),
        );
      },
      staggeredTileBuilder: (int index) {
        // RecentFiles widget occupies full width
        return StaggeredTile.fit(crossAxisCount);
      },
    );
  }
}
