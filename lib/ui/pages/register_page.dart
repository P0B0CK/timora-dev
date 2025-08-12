// lib/ui/organisms/register_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timora/ui/atoms/logo_full.dart';
import 'package:timora/ui/atoms/button.dart';
import 'package:timora/ui/atoms/input_field.dart';
import 'package:timora/ui/atoms/alert_message.dart';
import 'package:timora/theme/colors_extension.dart';
import 'package:timora/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailC = TextEditingController();
  final _passC  = TextEditingController();
  final _confC  = TextEditingController();

  bool _loading = false;
  String? _globalMsg;
  AlertType? _globalType;

  // états UI des champs
  InputStatus _emailStatus = InputStatus.normal;
  String? _emailMsg;

  InputStatus _passStatus = InputStatus.normal;
  String? _passMsg;

  InputStatus _confStatus = InputStatus.normal;
  String? _confMsg;

  // REGLES
  final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  bool get _isEmailValid => _emailRe.hasMatch(_emailC.text.trim());
  bool get _isPassValid  => _passC.text.length >= 8;
  bool get _isConfValid  => _confC.text == _passC.text && _confC.text.isNotEmpty;

  bool get _formValid => _isEmailValid && _isPassValid && _isConfValid;

  @override
  void initState() {
    super.initState();
    _validateEmail(_emailC.text);
    _validatePass(_passC.text);
    _validateConf(_confC.text);
  }

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    _confC.dispose();
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
      _validateConf(_confC.text); // revalide la conf
    });
  }

  void _validateConf(String v) {
    final match = v == _passC.text && v.isNotEmpty;
    setState(() {
      if (v.isEmpty) {
        _confStatus = InputStatus.normal;
        _confMsg = null;
      } else if (!match) {
        _confStatus = InputStatus.error;
        _confMsg = 'La confirmation ne correspond pas.';
      } else {
        _confStatus = InputStatus.success;
        _confMsg = null;
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
      await AuthService().register(email: _emailC.text.trim(), password: _passC.text);

      if (!mounted) return;
      // 👉 redirige vers Home et nettoie la stack
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _globalMsg = e.message ?? 'Inscription impossible.';
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

    final cardWidth  = (shortest * 0.78).clamp(340.0, 560.0).toDouble();
    final cardHeight = (cardWidth * 1.70).clamp(460.0, 760.0).toDouble();

    final logo = LogoFull(height: (cardWidth * 0.10).clamp(40.0, 72.0).toDouble(), stacked: false, spacing: 8);

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

            final card = DecoratedBox(
              decoration: BoxDecoration(
                color: tokens?.surface ?? theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: tokens?.outline ?? theme.dividerColor, width: 1.2),
                boxShadow: [softShadow],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    logo,
                    const SizedBox(height: 20),
                    Divider(color: tokens?.divider ?? theme.dividerColor, height: 1, thickness: 1),
                    const SizedBox(height: 24),

                    // Message
                    Text(
                      "Bienvenue dans l'agenda Timora.",
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
                    const SizedBox(height: 16),
                    CustomInputField(
                      label: 'Confirmer le mot de passe',
                      hint: 'Répétez le mot de passe',
                      controller: _confC,
                      isPassword: true,
                      status: _confStatus,
                      message: _confMsg,
                      onChanged: _validateConf,
                      onSubmitted: (_) => _submit(),
                    ),

                    const SizedBox(height: 18),

                    if (_globalMsg != null) ...[
                      AppAlertMessage(message: _globalMsg!, type: _globalType ?? AlertType.info, dense: true),
                      const SizedBox(height: 14),
                    ],

                    AppButton(
                      label: 'Créer mon compte',
                      type: ButtonType.primary,
                      isLoading: _loading,
                      isDisabled: !_formValid,
                      onPressed: _submit,
                    ),

                    const Spacer(),

                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                        child: const Text("J’ai déjà un compte"),
                      ),
                    ),
                  ],
                ),
              ),
            );

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset + 16 : 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: c.maxHeight - 24),
                child: Center(
                  child: AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      opacity: 1.0,
                      child: SizedBox(width: cardWidth, height: cardHeight, child: card),
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
