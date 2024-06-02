part of dashboard;

class AdminDashboardController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SideMenuController menuController = Get.put(SideMenuController());

  void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  }

  Future<List<CompanyData>> fetchCompanies() async {
    final response =
        await http.get(Uri.parse('https://swastik-health-india-api.onrender.com/api/company/getAll'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => CompanyData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load admins');
    }
  }

  Future<List<LabTechData>> fetchLabTechnicians() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String id = pref.getString('id').toString();
    final response = await http
        .get(Uri.parse('https://swastik-health-india-api.onrender.com/api/admin/getuser?id=$id'));
    if (response.statusCode == 200) {
      final responceData = json.decode(response.body);
      final List<dynamic> jsonData = responceData['lab_technicians'];

      return jsonData.map((data) => LabTechData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load admins');
    }
  }


 Future<List<DoctorData>> fetchDoctors() async {
    final response = await http
        .get(Uri.parse('https://swastik-health-india-api.onrender.com/api/doctor/getall'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> jsonData = responseData;
      return jsonData.map((data) => DoctorData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load Doctors');
    }
  }



  Future<_Profile> getProfil() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name') ?? 'Master Login';
    String email = prefs.getString('email') ?? 'Masterlogin@gmail.com';

    return _Profile(
      photo: AssetImage(ImageRasterPath.avatar1),
      name: name,
      email: email,
    );
  }

  List<TaskCardData> getAllTask() {
    return [
      const TaskCardData(
        title: "Landing page UI Design",
        dueDay: 2,
        totalComments: 50,
        type: TaskType.todo,
        totalContributors: 30,
        profilContributors: [
          AssetImage(ImageRasterPath.avatar1),
          AssetImage(ImageRasterPath.avatar2),
          AssetImage(ImageRasterPath.avatar3),
          AssetImage(ImageRasterPath.avatar4),
        ],
      ),
      const TaskCardData(
        title: "Landing page UI Design",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          AssetImage(ImageRasterPath.avatar5),
          AssetImage(ImageRasterPath.avatar6),
          AssetImage(ImageRasterPath.avatar7),
          AssetImage(ImageRasterPath.avatar8),
        ],
      ),
      const TaskCardData(
        title: "Landing page UI Design",
        dueDay: 1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.done,
        profilContributors: [
          AssetImage(ImageRasterPath.avatar5),
          AssetImage(ImageRasterPath.avatar3),
          AssetImage(ImageRasterPath.avatar4),
          AssetImage(ImageRasterPath.avatar2),
        ],
      ),
    ];
  }

  Future<void> logout() async {
    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Clear navigation stack and navigate to login screen
    Get.offAll(const LoginScreen());
  }

  ProjectCardData getSelectedProject() {
    return ProjectCardData(
      percent: .3,
      projectImage: const AssetImage(ImageRasterPath.logo1),
      projectName: "Swastik Health India",
      releaseTime: DateTime.now(),
    );
  }

 
  List<ImageProvider> getMember() {
    return const [
      AssetImage(ImageRasterPath.avatar1),
      AssetImage(ImageRasterPath.avatar2),
      AssetImage(ImageRasterPath.avatar3),
      AssetImage(ImageRasterPath.avatar4),
      AssetImage(ImageRasterPath.avatar5),
      AssetImage(ImageRasterPath.avatar6),
    ];
  }

  List<ChattingCardData> getChatting() {
    return const [
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar6),
        isOnline: true,
        name: "Samantha",
        lastMessage: "i added my new tasks",
        isRead: false,
        totalUnread: 100,
      ),
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar3),
        isOnline: false,
        name: "John",
        lastMessage: "well done john",
        isRead: true,
        totalUnread: 0,
      ),
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar4),
        isOnline: true,
        name: "Alexander Purwoto",
        lastMessage: "we'll have a meeting at 9AM",
        isRead: false,
        totalUnread: 1,
      ),
    ];
  }
}
