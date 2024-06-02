import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';

class ProgressCardData {
  final int totalEmployees;

  const ProgressCardData({
    required this.totalEmployees,
  });
}

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    required this.data,
    required this.onPressedCheck,
    Key? key,
  }) : super(key: key);

  final ProgressCardData data;
  final Function() onPressedCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(
                offset: const Offset(10, 30),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: SvgPicture.asset(
                    ImageVectorPath.happy2,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              top: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Employees/\nPatients",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28),
                ),
                SizedBox(height: 10,),
                Text(
                  "${data.totalEmployees}",
                  style: TextStyle(color: kFontColorPallets[1],fontSize: 24),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
