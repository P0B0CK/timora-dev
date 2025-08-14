// lib/ui/organisms/user_profile_modal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/user_repository.dart';

import 'package:timora/ui/atoms/button.dart';
import 'package:timora/ui/atoms/input_field.dart';
import 'package:timora/theme/colors_extension.dart';

import 'package:timora/ui/molecules/app_modal.dart';
import 'package:timora/ui/molecules/delete_account_modal.dart';

class UserProfileModal extends StatefulWidget {
  const UserProfileModal({super.key});

  @override
  State<UserProfileModal> createState() => _UserProfileModalState();
}

class _UserProfileModalState extends State<UserProfileModal> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _displayNameCtrl;
  late final TextEditingController _emailCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _displayNameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final auth = context.read<AuthService>();
    final repo = context.read<UserRepository>();
    final user = auth.currentUser;

    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun utilisateur connecté')),
        );
      }
      setState(() => _saving = false);
      return;
    }

    try {
      final newName = _displayNameCtrl.text.trim();
      await auth.updateDisplayName(newName);
      await repo.updateMe(user.uid, {'displayName': newName});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour')),
        );
        Navigator.of(context).maybePop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _sendReset() async {
    final auth = context.read<AuthService>();
    final email = auth.currentUser?.email;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email introuvable sur le compte')),
      );
      return;
    }

    try {
      await auth.sendPasswordReset(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email de réinitialisation envoyé à $email')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth   = context.watch<AuthService>();
    final repo   = context.watch<UserRepository>();
    final user   = auth.currentUser;

    if (user == null) {
      return const Center(child: Text('Non connecté'));
    }

    final theme  = Theme.of(context);
    final tokens = theme.extension<AppColors>();
    final linkColor = tokens?.primary ?? theme.colorScheme.primary;

    return StreamBuilder(
      stream: repo.listenMe(user.uid),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final displayName = (data?['displayName'] as String?) ?? user.displayName ?? '';
        final email = user.email ?? '';

        if (_displayNameCtrl.text.isEmpty) _displayNameCtrl.text = displayName;
        if (_emailCtrl.text.isEmpty) _emailCtrl.text = email;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Semantics(
              label: 'Édition du profil utilisateur',
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomInputField(
                      label: 'Votre pseudo',
                      hint: 'Votre nom visible',
                      controller: _displayNameCtrl,
                      status: InputStatus.normal,
                      onSubmitted: (_) => _save(),
                    ),

                    const SizedBox(height: 12),

                    CustomInputField(
                      label: 'Email',
                      hint: '',
                      controller: _emailCtrl,
                      enabled: false,
                      status: InputStatus.info,
                      message: null,
                    ),

                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: _sendReset,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_reset_rounded, size: 18, color: linkColor),
                              const SizedBox(width: 6),
                              Text(
                                'Réinitialiser le mot de passe',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: linkColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: linkColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          label: 'Enregistrer',
                          onPressed: _saving ? () {} : _save,
                          type: ButtonType.primary,
                          isLoading: _saving,
                          isDisabled: false,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Astuce : le changement d’email ou la suppression de compte nécessite votre mot de passe (réauthentification).',
                      style: theme.textTheme.bodySmall,
                    ),

                    const SizedBox(height: 16),

                    Builder(
                      builder: (ctx) {
                        final theme  = Theme.of(ctx);
                        final tokens = theme.extension<AppColors>();
                        final danger = tokens?.error ?? theme.colorScheme.error;

                        return Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              showAppModal<void>(
                                context: ctx,
                                title: 'Supprimer mon compte',
                                content: const DeleteAccountModal(),
                                actions: const [],
                                barrierDismissible: true,
                                useRootNavigator: false,
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.delete_outline_rounded, size: 18, color: danger),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Supprimer mon compte',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: danger,
                                      decoration: TextDecoration.underline,
                                      decorationColor: danger,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
