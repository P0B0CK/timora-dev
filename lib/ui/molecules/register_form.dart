import 'package:flutter/material.dart';
import 'package:timora/services/auth_service.dart';
import 'package:timora/ui/atoms/input_field.dart';
import 'package:timora/ui/atoms/button.dart'; // ✅ ton composant AppButton unifié

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
      await _authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        _errorMessage = "Inscription échouée. Vérifie ton email.";
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
          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
        ],
        AppButton(
          label: 'Créer mon compte',
          onPressed: _submit,
          isLoading: _isLoading,
          type: ButtonType.primary, // ✅ explicite
        ),
      ],
    );
  }
}
