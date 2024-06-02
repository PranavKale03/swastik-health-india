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
                  label: "verification tasks",
                ),
                SelectionButtonData(
                  activeIcon: Icons.logout,
                  icon: Icons.logout,
                  label: "Logout",
                ),
                  ],
                  // ignore: avoid_types_as_parameter_names
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