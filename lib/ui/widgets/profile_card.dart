import 'dart:io';
import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import '../screens/profile_setup_screen.dart';

class ProfileCard extends StatelessWidget {
  final SettingsProvider sp;

  const ProfileCard({super.key, required this.sp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            backgroundImage: sp.userImagePath != null
                ? FileImage(File(sp.userImagePath!))
                : null,
            child: sp.userImagePath == null
                ? Icon(Icons.person_rounded,
                    size: 32, color: Theme.of(context).colorScheme.primary)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sp.userName.isNotEmpty ? sp.userName : 'User Profile',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                    sp.userContact.isNotEmpty
                        ? sp.userContact
                        : 'Set up your profile',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 14)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProfileSetupScreen(isEditing: true)));
            },
          ),
        ],
      ),
    );
  }
}
