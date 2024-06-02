import 'package:flutter/material.dart';
import 'package:swastik_health_india/app/config/themes/app_theme.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';

Widget customButton({
  required double height,
  required String text,
  required BuildContext context,
  required VoidCallback onTap,
}) {
  return SizedBox(
    height: height,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ), backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.basic.primaryColorDark // Use canvasColor from dark theme
            : AppTheme.light.primaryColorLight,
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0), // Use canvasColor from light theme
      ),
      child: Text(
        text,
        style: ralewayStyle.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
    ),
  );
}
