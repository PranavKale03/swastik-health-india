import 'package:flutter/material.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';

import '../../models/lab_tech.dart';

class LabTechList extends StatelessWidget {
  final LabTechData labTechData;
  final Function() onPressedNotification;

  const LabTechList({
    required this.labTechData,
    required this.onPressedNotification,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      // leading: CircleAvatar(backgroundImage: NetworkImage(labTechData.photoUrl)),
      title: Text(
        labTechData.name,
        style: const TextStyle(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        labTechData.email,
        style: const TextStyle(fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: screenWidth >= 600
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    // Manage admin logic
                  },
                  icon: const Icon(Icons.manage_accounts),
                  tooltip: "Manage",
                ),
                IconButton(
                  onPressed: () {
                    // Delete admin logic
                  },
                  icon: const Icon(Icons.delete),
                  tooltip: "Delete",
                ),
              ],
            )
          : null,
    );
  }
}

class AllLabTech extends StatelessWidget {
  const AllLabTech({
    required this.totalMember,
    Key? key,
  }) : super(key: key);

  final int totalMember;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kFontColorPallets[0],
            ),
            children: [
              const TextSpan(text: "All Admins"),
              TextSpan(
                text: "($totalMember)",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: kFontColorPallets[2],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}