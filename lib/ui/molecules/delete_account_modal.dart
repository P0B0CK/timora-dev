// lib/ui/molecules/delete_account_modal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import '../../services/user_repository.dart';

import 'package:timora/ui/atoms/button.dart';
import 'package:timora/ui/atoms/input_field.dart';
import 'package:timora/theme/colors_extension.dart';

import 'package:timora/ui/molecules/app_modal.dart';
import 'package:timora/ui/molecules/reauth_delete_modal.dart';

class DeleteAccountModal extends StatefulWidget {
  const DeleteAccountModal({super.key});

  @override
  State<DeleteAccountModal> createState() => _DeleteAccountModalState();
}

class _DeleteAccountModalState extends State<DeleteAccountModal> {
  final _formKey = GlobalKey<FormState>();
  final _confirmCtrl = TextEditingController();
  bool _deleting = false;

  @override
  void dispose() {
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool get _isConfirmed => _confirmCtrl.text.trim() == 'CONFIRMER';

  Future<void> _navigateToLanding() async {
    // Ferme toutes les modales/écrans et revient à la première route (AuthLoginPage via ton StreamBuilder).
    Navigator.of(context, rootNavigator: true).popUntil((r) => r.isFirst);
  }

  Future<void> _performDelete() async {
    if (!_isConfirmed) return;
    setState(() => _deleting = true);

    final auth = context.read<AuthService>();
    final repo = context.read<UserRepository>();
    final user = auth.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun utilisateur connecté')),
        );
      }
      setState(() => _deleting = false);
      return;
    }

    final uid = user.uid;

    try {
      // 1) Tentative de suppression immédiate (exige un login récent)
      await user.delete();

      // 2) Nettoyage Firestore
      await repo.deleteProfileDoc(uid);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte supprimé. Au revoir 👋')),
      );

      // 3) Retour à l’écran d’arrivée
      await _navigateToLanding();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'requires-recent-login') {
        // Ouvre la sous‑modale de réauthentification
        await showAppModal<void>(
          context: context,
          title: 'Confirmation de sécurité',
          content: const ReauthDeleteModal(),
          actions: const [],
          barrierDismissible: true,
          useRootNavigator: false, // garde l’accès aux Providers
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Suppression impossible : ${e.code}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final tokens = theme.extension<AppColors>();
    final error  = tokens?.error ?? theme.colorScheme.error;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titre en gras
          Text(
            'Souhaitez-vous vraiment supprimer votre compte ?',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Icône info + texte d'instruction
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_rounded, color: error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Veuillez taper "CONFIRMER" et appuyer sur Valider.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          CustomInputField(
            label: 'Confirmation',
            hint: 'Saisissez exactement : CONFIRMER',
            controller: _confirmCtrl,
            status: _isConfirmed ? InputStatus.success : InputStatus.warning,
            message: _isConfirmed ? 'OK' : 'La valeur doit être exactement "CONFIRMER".',
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Annuler
              AppButton(
                label: 'Annuler',
                type: ButtonType.outlined,
                onPressed: _deleting ? (){} : () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 12),
              // Valider
              AppButton(
                label: 'Valider',
                onPressed: (!_isConfirmed || _deleting) ? (){} : _performDelete,
                type: ButtonType.primary,
                isLoading: _deleting,
                isDisabled: !_isConfirmed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
