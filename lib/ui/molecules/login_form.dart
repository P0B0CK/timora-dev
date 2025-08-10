import 'package:flutter/material.dart';
import 'package:timora/services/auth_service.dart';
import 'package:timora/ui/atoms/input_field.dart';
import 'package:timora/ui/atoms/button.dart'; // ⬅️ ton fichier commun

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  void _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // TODO : navigation ou feedback visuel
    } catch (e) {
      setState(() {
        _errorMessage = "Connexion échouée. Vérifie tes identifiants.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInputField(
          label: 'Email',
          hint: 'exemple@mail.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'Mot de passe',
          hint: '********',
          controller: _passwordController,
          isPassword: true,
        ),
        const SizedBox(height: 16),
        if (_errorMessage != null) ...[
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
        ],
        AppButton(
          label: 'Connexion',
          onPressed: _submit,
          isLoading: _isLoading,
          type: ButtonType.primary,
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Créer un compte',
          onPressed: () {
            // TODO : logique de navigation ou action
          },
          type: ButtonType.secondary,
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Mot de passe oublié ?',
          onPressed: () {
            // TODO : mot de passe oublié
          },
          type: ButtonType.outlined,
        ),
      ],
    );
  }
}
