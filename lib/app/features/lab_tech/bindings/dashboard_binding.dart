part of dashboard;
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LabTechDashboardController());

  }
}
