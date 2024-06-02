library dashboard;

import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_health_india/app/auth/login_screen.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';
import 'package:swastik_health_india/app/features/admin/models/company.dart';
import 'package:swastik_health_india/app/features/admin/views/screens/add_LabTech_screen.dart';
import 'package:swastik_health_india/app/features/admin/views/screens/employee_management.dart';
import 'package:swastik_health_india/app/features/dashboard/controllers/menu_controller.dart';
import 'package:swastik_health_india/app/features/dashboard/views/components/recent_employee.dart';
import 'package:swastik_health_india/app/shared_components/chatting_card.dart';
import 'package:swastik_health_india/app/shared_components/list_profil_image.dart';
import 'package:swastik_health_india/app/shared_components/progress_card.dart';
import 'package:swastik_health_india/app/shared_components/progress_report_card.dart';
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
import '../../../../config/themes/app_theme.dart';
import '../../models/lab_tech.dart';
import 'add_company_screen.dart';
import 'doctor_manage/add_doctor.dart';

// binding
part '../../bindings/dashboard_binding.dart';
part '../../controllers/admin_dashboard_controller.dart';
// models
part '../../models/profile.dart';
part '../components/header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';
part '../components/team_member.dart';

class AdminDashboardScreen extends GetView<AdminDashboardController> {
  const AdminDashboardScreen({Key? key}) : super(key: key);
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
                  // Other content based on selected menu item
                  Obx(() {
                    final selectedMenuItem =
                        controller.menuController.selectedIndex.value;
                    return Builder(
                      builder: (BuildContext context) {
                        switch (selectedMenuItem) {
                          case 0: // Dashboard
                            return _buildDashboardContent(context);
                          case 1: // Employees/Patients
                            return _buildAddCompanyContent(context);
                          case 2: // Employees/Patients
                            return _buildEmployeeContent(context);
                          case 4: // Employees/Patients
                            return _buildLabTechContent(context);
                          case 5: // Employees/Patients
                            return _buildDoctorContent(context);
                          case 8: // Add Admin
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

  Widget _buildDashboardContent(BuildContext context) {
    return SingleChildScrollView(
        child: ResponsiveBuilder(
      mobileBuilder: (context, constraints) {
        return Column(children: [
          const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
          _buildProgress(axis: Axis.vertical),
          const SizedBox(height: kSpacing),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: kSpacing),
          //   child: GetPremiumCard(onPressed: () {}),
          // ),
          const SizedBox(height: kSpacing * 2),
          _buildTaskOverview(
            data: controller.getAllTask(),
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
                  const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                  _buildProgress(
                    axis: (constraints.maxWidth < 950)
                        ? Axis.vertical
                        : Axis.horizontal,
                  ),
                  const SizedBox(height: kSpacing * 2),
                  _buildTaskOverview(
                    data: controller.getAllTask(),
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
                  _buildProgress(),
                  const SizedBox(height: kSpacing * 2),
                  _buildTaskOverview(
                    data: controller.getAllTask(),
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
                  const SizedBox(height: kSpacing),
                  _buildTeamMember(data: controller.getMember()),
                  const SizedBox(height: kSpacing),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                  //   child: GetPremiumCard(onPressed: () {}),
                  // ),
                  const SizedBox(height: kSpacing),
                  const Divider(thickness: 1),
                  const SizedBox(height: kSpacing),
                  _buildRecentMessages(data: controller.getChatting()),
                ],
              ),
            )
          ],
        );
      },
    ));
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

  Widget _buildAddCompanyContent(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return const Column(
            children: [
              SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              Padding(
                padding: EdgeInsets.only(left: kSpacing),
                child: AddCompanyScreen(),
              ),
              SizedBox(height: kSpacing * 2),
            ],
          );
        },
        tabletBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 950) ? 6 : 9,
                child: const Column(
                  children: [
                    SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: AddCompanyScreen(),
                    ),
                    SizedBox(height: kSpacing * 2),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                    FutureBuilder<List<CompanyData>>(
                        future: controller.fetchCompanies(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final companies = snapshot.data!;
                            return _buildcompanyList(
                              context: context,
                              data: companies.reversed.toList(),
                            );
                          }
                        }),
                  ],
                ),
              )
            ],
          );
        },
        desktopBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Flexible(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: kSpacing),
                      child: AddCompanyScreen(),
                    ),
                    SizedBox(height: kSpacing * 2),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing / 2),
                    FutureBuilder<List<CompanyData>>(
                        future: controller.fetchCompanies(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final companies = snapshot.data!;
                            return _buildcompanyList(
                              context: context,
                              data: companies.reversed.toList(),
                            );
                          }
                        }),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabTechContent(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return const Column(
            children: [
              SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              Padding(
                padding: EdgeInsets.only(left: kSpacing),
                child: AddLabTechScreen(),
              ),
              SizedBox(height: kSpacing * 2),
            ],
          );
        },
        tabletBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 950) ? 6 : 9,
                child: const Column(
                  children: [
                    SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: AddLabTechScreen(),
                    ),
                    SizedBox(height: kSpacing * 2),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                    FutureBuilder<List<LabTechData>>(
                        future: controller.fetchLabTechnicians(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // ignore: non_constant_identifier_names
                            final LabTech = snapshot.data!;
                            return _buildLabTechList(
                              context: context,
                              data: LabTech.reversed.toList(),
                            );
                          }
                        }),
                  ],
                ),
              )
            ],
          );
        },
        desktopBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Flexible(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: kSpacing),
                      child: AddLabTechScreen(),
                    ),
                    SizedBox(height: kSpacing * 2),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing / 2),
                    FutureBuilder<List<LabTechData>>(
                        future: controller.fetchLabTechnicians(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final companies = snapshot.data!;
                            return _buildLabTechList(
                              context: context,
                              data: companies.reversed.toList(),
                            );
                          }
                        }),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  
  Widget _buildDoctorContent(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return const Column(
            children: [
              SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              Padding(
                padding: EdgeInsets.only(left: kSpacing),
                child: AddDoctorScreen(),
              ),
              SizedBox(height: kSpacing * 2),
            ],
          );
        },
        tabletBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 950) ? 6 : 9,
                child: const Column(
                  children: [
                    SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: AddDoctorScreen(),
                    ),
                    SizedBox(height: kSpacing * 2),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                    FutureBuilder<List<LabTechData>>(
                        future: controller.fetchDoctors(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // ignore: non_constant_identifier_names
                            final LabTech = snapshot.data!;
                            return _buildDoctorList(
                              context: context,
                              data: LabTech.reversed.toList(),
                            );
                          }
                        }),
                  ],
                ),
              )
            ],
          );
        },
        desktopBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Flexible(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: kSpacing),
                      child: AddLabTechScreen(),
                    ),
                    SizedBox(height: kSpacing * 2),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing / 2),
                    FutureBuilder<List<LabTechData>>(
                        future: controller.fetchLabTechnicians(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final companies = snapshot.data!;
                            return _buildLabTechList(
                              context: context,
                              data: companies.reversed.toList(),
                            );
                          }
                        }),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
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

  Widget _buildProgress({Axis axis = Axis.horizontal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: (axis == Axis.horizontal)
          ? Row(
              children: [
                Flexible(
                  flex: 5,
                  child: ProgressCard(
                    data: const ProgressCardData(
                      totalEmployees: 2,
                    ),
                    onPressedCheck: () {},
                  ),
                ),
                const SizedBox(width: kSpacing / 2),
                const Flexible(
                  flex: 4,
                  child: ProgressReportCard(
                    data: ProgressReportCardData(
                      title: "Test Count",
                      doneTests: 10,
                      percent: .3,
                      totalTests: 15,
                      undoneTests: 5,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                ProgressCard(
                  data: const ProgressCardData(
                    totalEmployees: 2,
                  ),
                  onPressedCheck: () {},
                ),
                const SizedBox(height: kSpacing / 2),
                const ProgressReportCard(
                  data: ProgressReportCardData(
                    title: "Test Count",
                    doneTests: 10,
                    percent: .3,
                    totalTests: 15,
                    undoneTests: 5,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTaskOverview({
    required List<TaskCardData> data,
    int crossAxisCount = 6,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: crossAxisCount,
      itemCount: 1, // Only one item, which is the RecentFiles widget
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // Only return the RecentFiles widget
        return const Padding(
          padding: EdgeInsets.only(bottom: kSpacing),
          child: RecentFiles(),
        );
      },
      staggeredTileBuilder: (int index) {
        // RecentFiles widget occupies full width
        return StaggeredTile.fit(crossAxisCount);
      },
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
          child: CompanySelection(),
        );
      },
      staggeredTileBuilder: (int index) {
        // RecentFiles widget occupies full width
        return StaggeredTile.fit(crossAxisCount);
      },
    );
  }

  Widget _buildcompanyList(
      {required List<CompanyData> data, required context}) {
    return Material(
      elevation: 1,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.basic.canvasColor // Use canvasColor from dark theme
              : AppTheme.light.canvasColor, // Use canvasColor from light theme
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(kSpacing),
            child: AllLabTech(
              totalMember: data.length,
            ),
          ),
          const SizedBox(height: kSpacing / 2),
          ...data
              .map(
                (e) => CompanyList(
                  company: e,
                  onPressedNotification: () {},
                ),
              )
              .toList(),
        ]),
      ),
    );
  }

  Widget _buildLabTechList(
      {required List<LabTechData> data, required context}) {
    return Material(
      elevation: 1,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.basic.canvasColor // Use canvasColor from dark theme
              : AppTheme.light.canvasColor, // Use canvasColor from light theme
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(kSpacing),
            child: AllLabTech(
              totalMember: data.length,
            ),
          ),
          const SizedBox(height: kSpacing / 2),
          ...data
              .map(
                (e) => LabTechList(
                  labtech: e,
                  onPressedNotification: () {},
                ),
              )
              .toList(),
        ]),
      ),
    );
  }

  
  Widget _buildDoctorList(
      {required List<LabTechData> data, required context}) {
    return Material(
      elevation: 1,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.basic.canvasColor // Use canvasColor from dark theme
              : AppTheme.light.canvasColor, // Use canvasColor from light theme
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(kSpacing),
            child: AllLabTech(
              totalMember: data.length,
            ),
          ),
          const SizedBox(height: kSpacing / 2),
          ...data
              .map(
                (e) => LabTechList(
                  labtech: e,
                  onPressedNotification: () {},
                ),
              )
              .toList(),
        ]),
      ),
    );
  }

  Widget _buildTeamMember({required List<ImageProvider> data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeamMember(
            totalMember: data.length,
            onPressedAdd: () {},
          ),
          const SizedBox(height: kSpacing / 2),
          ListProfilImage(maxImages: 6, images: data),
        ],
      ),
    );
  }

  Widget _buildRecentMessages({required List<ChattingCardData> data}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: _RecentMessages(onPressedMore: () {}),
      ),
      const SizedBox(height: kSpacing / 2),
      ...data
          .map(
            (e) => ChattingCard(data: e, onPressed: () {}),
          )
          .toList(),
    ]);
  }
}
