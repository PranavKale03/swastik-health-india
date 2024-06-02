import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';

class UpgradePremiumCard extends StatelessWidget {
  const UpgradePremiumCard({
    required this.onPressed,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final Color? backgroundColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(kBorderRadius),
      color: backgroundColor ?? Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius),
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 150,
            maxWidth: 250,
            minHeight: 150,
            maxHeight: 250,
          ),
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 80,
                ),
                child: Image.asset(
                  ImageRasterPath.swastiklogo,
                  fit: BoxFit.contain,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: _Info(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        const SizedBox(height: 2),
        _subtitle(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _title() {
    return const Text(
      "Swastik Health India",
    );
  }

  Widget _subtitle() {
    return Text(
      "Health is a Gratest Wealth",
      style: Theme.of(Get.context!).textTheme.bodySmall,
    );
  }
}
