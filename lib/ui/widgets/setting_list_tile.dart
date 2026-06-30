import 'package:flutter/material.dart';
import 'custom_icon_box.dart';

class SettingListTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final VoidCallback onTap;

  const SettingListTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomIconBox(
        icon: icon,
        color: iconColor,
        size: 34,
        iconSize: 18,
        shape: BoxShape.rectangle,
      ),
      title: Text(
        title,
        style: titleColor != null ? TextStyle(color: titleColor) : null,
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}