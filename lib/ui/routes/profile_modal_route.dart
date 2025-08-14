// lib/ui/routes/profile_modal_route.dart
import 'package:flutter/material.dart';
import '../molecules/app_modal.dart';
import '../organisms/user_profile_modal.dart';

class ProfileModalRoute extends StatefulWidget {
  const ProfileModalRoute({super.key});

  @override
  State<ProfileModalRoute> createState() => _ProfileModalRouteState();
}

class _ProfileModalRouteState extends State<ProfileModalRoute> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showAppModal<void>(
        context: context,
        title: 'Mon profil',
        content: const UserProfileModal(),
        actions: const [],
        barrierDismissible: true,
        useRootNavigator: false,
      );
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
