import 'package:flutter/material.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';

class SelectionButtonData {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  final int? totalNotif;

  SelectionButtonData({
    required this.activeIcon,
    required this.icon,
    required this.label,
    this.totalNotif,
  });
}

class SelectionButton extends StatefulWidget {
  const SelectionButton({
    this.initialSelected = 0,
    required this.data,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final int initialSelected;
  final List<SelectionButtonData> data;
  final Function(int index, ) onSelected;

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  late int selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.data.asMap().entries.map((e) {
        final index = e.key;
        final data = e.value;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _Button(
            selected: selected == index,
            onPressed: () {
              widget.onSelected(index);
              setState(() {
                selected = index;
              });
            },
            data: data,
          ),
        );
      }).toList(),
    );
  }
}


class _Button extends StatelessWidget {
  const _Button({
    required this.selected,
    required this.data,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final bool selected;
  final SelectionButtonData data;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: (!selected)
          ? Theme.of(context).cardColor
          : Theme.of(context).primaryColor.withOpacity(.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(kSpacing),
          child: Row(
            children: [
              Icon(
                selected ? data.activeIcon : data.icon,
                size: 20,
                color: selected ? Theme.of(context).primaryColor : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  data.label,
                  style: TextStyle(
                    color: selected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .8,
                    fontSize: 16,
                  ),
                ),
              ),
              if (data.totalNotif != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: _buildNotification(data.totalNotif!),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotification(int total) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        (total >= 100) ? "99+" : "$total",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


