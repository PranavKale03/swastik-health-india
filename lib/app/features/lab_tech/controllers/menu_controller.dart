import 'package:get/get.dart';

class SideMenuController extends GetxController {
  var selectedIndex = 0.obs;

  void selectMenu(int index) {
    selectedIndex.value = index;
  }
}