

import 'package:flutter/material.dart';
import 'package:swastik_health_india/app/config/themes/app_theme.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';
import 'package:swastik_health_india/app/features/dashboard/models/RecentEmployee.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration:  BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.basic.canvasColor // Use canvasColor from dark theme
              : AppTheme.light.canvasColor, // Use canvasColor from light theme
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Employees/Patients",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: defaultPadding,
                // minWidth: 600,
                columns: const [
                  DataColumn(
                    label: Text("File Name"),
                  ),
                  DataColumn(
                    label: Text("Date"),
                  ),
                  DataColumn(
                    label: Text("Size"),
                  ),
                ],
                rows: List.generate(
                  demoRecentFiles.length,
                  (index) => recentFileDataRow(demoRecentFiles[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DataRow recentFileDataRow(RecentFile fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            const Icon(Icons.person),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.title!),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.date!)),
      DataCell(Text(fileInfo.size!)),
    ],
  );
}
