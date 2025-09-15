import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int? userPoints;
  final bool showPoints;
  final bool showSettings;
  final bool showNotifications;
  final List<Widget>? extraActions;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onNotificationsTap;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.userPoints,
    this.showPoints = false,
    this.showSettings = false,
    this.showNotifications = false,
    this.extraActions,
    this.onSettingsTap,
    this.onNotificationsTap,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        if (showPoints && userPoints != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                "Điểm: $userPoints",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        if (showNotifications)
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: onNotificationsTap,
          ),
        if (showSettings)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: onSettingsTap,
          ),
        if (extraActions != null) ...extraActions!,
      ],
    );
  }
}
