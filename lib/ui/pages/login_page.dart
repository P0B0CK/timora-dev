// lib/ui/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timora/ui/atoms/logo_full.dart';
import 'package:timora/ui/atoms/button.dart';
import 'package:timora/ui/atoms/input_field.dart';
import 'package:timora/ui/atoms/alert_message.dart';
import 'package:timora/theme/colors_extension.dart';
import 'package:timora/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailC = TextEditingController();
  final _passC  = TextEditingController();

  bool _loading = false;
  String? _globalMsg;
  AlertType? _globalType;

  // États des champs
  InputStatus _emailStatus = InputStatus.normal;
  String? _emailMsg;

  InputStatus _passStatus = InputStatus.normal;
  String? _passMsg;

  // email simple: "xxx@yyy.zz"
  final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  bool get _isEmailValid => _emailRe.hasMatch(_emailC.text.trim());
  bool get _isPassValid  => _passC.text.length >= 8;
  bool get _formValid    => _isEmailValid && _isPassValid;

  @override
  void initState() {
    super.initState();
    _validateEmail(_emailC.text);
    _validatePass(_passC.text);
  }

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  void _validateEmail(String v) {
    final ok = _emailRe.hasMatch(v.trim());
    setState(() {
      if (v.isEmpty) {
        _emailStatus = InputStatus.normal;
        _emailMsg = null;
      } else if (!ok) {
        _emailStatus = InputStatus.error;
        _emailMsg = 'Adresse e-mail invalide (ex: nom@domaine.com).';
      } else {
        _emailStatus = InputStatus.success;
        _emailMsg = null;
      }
    });
  }

  void _validatePass(String v) {
    final ok = v.length >= 8;
    setState(() {
      if (v.isEmpty) {
        _passStatus = InputStatus.normal;
        _passMsg = null;
      } else if (!ok) {
        _passStatus = InputStatus.error;
        _passMsg = 'Au moins 8 caractères requis.';
      } else {
        _passStatus = InputStatus.success;
        _passMsg = null;
      }
    });
  }

  Future<void> _submit() async {
    if (_loading) return;

    if (!_formValid) {
      setState(() {
        _globalMsg = "Veuillez corriger les champs en rouge.";
        _globalType = AlertType.warning;
      });
      return;
    }

    setState(() {
      _loading = true;
      _globalMsg = null;
    });

    try {
      await AuthService().login(email: _emailC.text.trim(), password: _passC.text);

      if (!mounted) return;

      // Feedback (optionnel)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion réussie ✔')),
      );

      // ✅ Redirection fiable : on remplace toute la pile par /home
      final nav = Navigator.of(context, rootNavigator: true);
      Future.microtask(() {
        nav.pushNamedAndRemoveUntil('/home', (route) => false);
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _globalMsg = e.message ?? 'Impossible de se connecter.';
        _globalType = AlertType.error;
      });
    } catch (_) {
      setState(() {
        _globalMsg = 'Une erreur est survenue.';
        _globalType = AlertType.error;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final tokens  = theme.extension<AppColors>();
    final shortest= MediaQuery.of(context).size.shortestSide;

    // Carte allongée responsive
    final cardWidth  = (shortest * 0.78).clamp(340.0, 560.0).toDouble();
    final baseCardHeight = (cardWidth * 1.42).clamp(440.0, 720.0).toDouble();

    // Header (logo ligne)
    final logo = LogoFull(height: (cardWidth * 0.10).clamp(40.0, 72.0).toDouble(), stacked: false, spacing: 8);

    // Ombre douce
    final BoxShadow softShadow = BoxShadow(
      color: (theme.brightness == Brightness.dark)
          ? Colors.black.withOpacity(0.45)
          : Colors.black.withOpacity(0.08),
      blurRadius: 30,
      offset: const Offset(0, 18),
    );

    const vPad = 34.0;
    const hPad = 28.0;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            final keyboardOpen = bottomInset > 0;

            // Hauteur dispo à l’écran une fois le clavier ouvert
            final verticalPadding = keyboardOpen ? (bottomInset + 16) : 24;
            final availableHeight = c.maxHeight - verticalPadding;

            // On “clampe” la carte pour qu’elle n’excède jamais l’espace dispo
            final cardHeight = baseCardHeight.clamp(380.0, availableHeight);

            final card = DecoratedBox(
              decoration: BoxDecoration(
                color: tokens?.surface ?? theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: tokens?.outline ?? theme.dividerColor, width: 1.2),
                boxShadow: [softShadow],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
                // ⬇️ wrap le contenu dans un scroll qui ne s’active que si nécessaire
                child: LayoutBuilder(
                  builder: (context, box) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: box.maxHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: logo ligne
                            logo,
                            const SizedBox(height: 20),
                            Divider(color: tokens?.divider ?? theme.dividerColor, height: 1, thickness: 1),
                            const SizedBox(height: 24),

                            // Message
                            Text(
                              "Bon retour, veuillez vous connecter.",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: (tokens?.onSurface ?? theme.colorScheme.onSurface).withOpacity(0.95),
                                letterSpacing: .4,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Form
                            CustomInputField(
                              label: 'Email',
                              hint: 'nom@domaine.com',
                              controller: _emailC,
                              keyboardType: TextInputType.emailAddress,
                              status: _emailStatus,
                              message: _emailMsg,
                              onChanged: _validateEmail,
                              onSubmitted: (_) => _submit(),
                            ),
                            const SizedBox(height: 16),
                            CustomInputField(
                              label: 'Mot de passe',
                              hint: 'Au moins 8 caractères',
                              controller: _passC,
                              isPassword: true,
                              status: _passStatus,
                              message: _passMsg,
                              onChanged: _validatePass,
                              onSubmitted: (_) => _submit(),
                            ),

                            const SizedBox(height: 18),

                            if (_globalMsg != null) ...[
                              AppAlertMessage(
                                message: _globalMsg!,
                                type: _globalType ?? AlertType.info,
                                dense: true,
                              ),
                              const SizedBox(height: 14),
                            ],

                            AppButton(
                              label: 'Se connecter',
                              type: ButtonType.primary,
                              isLoading: _loading,
                              isDisabled: !_formValid,
                              onPressed: _submit,
                            ),

                            // ⬇️ remplace le Spacer par un petit espace fixe (évite l’overflow)
                            const SizedBox(height: 16),

                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pushReplacementNamed('/register'),
                                child: const Text("Créer un compte"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );

            // Scroll-safe + centrage (ou top) + anim + hauteur adaptable
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: verticalPadding.toDouble()),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: availableHeight),
                child: AnimatedAlign(
                  // Quand le clavier est ouvert, on ancre la carte en haut pour éviter le “saut”
                  alignment: keyboardOpen ? Alignment.topCenter : Alignment.center,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    opacity: 1.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      width: cardWidth,
                      height: cardHeight.toDouble(), // ← hauteur responsive
                      child: card,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
