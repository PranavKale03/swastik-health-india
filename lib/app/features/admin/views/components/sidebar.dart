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
                  activeIcon: Icons.business,
                  icon: Icons.business,
                  label: "Company Details",
                ),
                SelectionButtonData(
                  activeIcon: Icons.people,
                  icon: EvaIcons.people,
                  label: "Employees Management",
                ),
                SelectionButtonData(
                  activeIcon: Icons.assignment_turned_in,
                  icon: Icons.assignment_turned_in,
                  label: "Consent Management",
                  totalNotif: 20,
                ),
                 SelectionButtonData(
                  activeIcon: Icons.science,
                  icon: Icons.science,
                  label: "Lab Technicians Assignment",
                ),
                SelectionButtonData(
                  activeIcon: Icons.medical_services,
                  icon: Icons.medical_services,
                  label: "Doctors Management",
                ),
                SelectionButtonData(
                  activeIcon: Icons.upload_file,
                  icon: Icons.upload_file,
                  label: "Reports Upload",
                ),
                SelectionButtonData(
                  activeIcon: Icons.event,
                  icon: Icons.event,
                  label: "Camps Progress",
                ),
                SelectionButtonData(
                  activeIcon: Icons.receipt,
                  icon: Icons.receipt,
                  label: "Invoices Generation",
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