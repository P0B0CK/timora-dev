import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import '../../services/user_repository.dart';

import 'package:timora/ui/atoms/input_field.dart';
import 'package:timora/ui/atoms/button.dart';
import 'package:timora/theme/colors_extension.dart';

class ReauthDeleteModal extends StatefulWidget {
  const ReauthDeleteModal({super.key});

  @override
  State<ReauthDeleteModal> createState() => _ReauthDeleteModalState();
}

class _ReauthDeleteModalState extends State<ReauthDeleteModal> {
  final _formKey  = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl   = TextEditingController();
  bool _working = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl.text = FirebaseAuth.instance.currentUser?.email ?? '';
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _navigateToLanding() async {
    Navigator.of(context, rootNavigator: true).popUntil((r) => r.isFirst);
  }

  Future<void> _reauthAndDelete() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _working = true);

    final auth = context.read<AuthService>();
    final repo = context.read<UserRepository>();
    final user = auth.currentUser;

    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun utilisateur connecté')),
        );
      }
      setState(() => _working = false);
      return;
    }

    final uid = user.uid;

    try {
      // 1) Réauthentifier
      await auth.reauthenticate(_emailCtrl.text.trim(), _pwdCtrl.text);

      // 2) Supprimer le compte
      await user.delete();

      // 3) Supprimer le doc Firestore
      await repo.deleteProfileDoc(uid);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte supprimé. Au revoir 👋')),
      );

      // 4) Fermer la modale et revenir à l’écran d’arrivée
      Navigator.of(context).pop(); // ferme ReauthDeleteModal
      await _navigateToLanding();
    } on FirebaseAuthException catch (e) {
      String msg = 'Erreur : ${e.code}';
      if (e.code == 'wrong-password') msg = 'Mot de passe incorrect.';
      if (e.code == 'user-mismatch' || e.code == 'user-not-found') msg = 'Utilisateur introuvable.';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final tokens = theme.extension<AppColors>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pour des raisons de sécurité, veuillez vous reconnecter.',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          CustomInputField(
            label: 'Email',
            hint: '',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            enabled: true, // mets false si tu veux empêcher l’édition
          ),
          const SizedBox(height: 12),

          CustomInputField(
            label: 'Mot de passe',
            hint: 'Votre mot de passe',
            controller: _pwdCtrl,
            isPassword: true,
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Annuler',
                type: ButtonType.outlined,
                onPressed: _working ? (){} : () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 12),
              AppButton(
                label: 'Valider',
                onPressed: _working ? (){} : _reauthAndDelete,
                type: ButtonType.primary,
                isLoading: _working,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
