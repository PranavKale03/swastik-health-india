part of dashboard;


class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.data,
    Key? key,
  }) : super(key: key);

  final ProjectCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(kSpacing),
              child: ProjectCard(
                data: data,
              ),
            ),
            const Divider(thickness: 1),
            GetBuilder<SideMenuController>(
              init: SideMenuController(),
              builder: (menuController) {  
                return SelectionButton(
                  initialSelected: menuController.selectedIndex.value,
                  data: [
                    SelectionButtonData(
                      activeIcon: EvaIcons.grid,
                      icon: EvaIcons.gridOutline,
                      label: "Dashboard",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.archive,
                      icon: Icons.person,
                      label: "Employees/Patients",
                    ),
                    SelectionButtonData(
                      activeIcon: Icons.credit_card,
                      icon: EvaIcons.calendarOutline,
                      label: "SmartCards",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.email,
                      icon: Icons.description,
                      label: "Reports",
                      totalNotif: 20,
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.person,
                      icon: Icons.analytics,
                      label: "Test Counts",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.person,
                      icon: Icons.person_add,
                      label: "Add Admin",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.settings,
                      icon: EvaIcons.settingsOutline,
                      label: "Setting",
                    ),
                  ],
                  onSelected: (index) {
                    menuController.selectMenu(index); 
                  },
                );
              },
            ),
            const Divider(thickness: 1),
            const SizedBox(height: kSpacing * 2),
            UpgradePremiumCard(
              backgroundColor: Theme.of(context).canvasColor.withOpacity(.4),
              onPressed: () {},
            ),
            const SizedBox(height: kSpacing * 20),
          ],
        ),
      ),
    );
  }
}