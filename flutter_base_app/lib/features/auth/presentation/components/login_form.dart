// lib/features/auth/presentation/components/login_form.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/components/app_button.dart';
import '../../../../core/components/app_text_field.dart';
import '../providers/auth_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(controller: emailCtrl, label: 'Email'),
        const SizedBox(height: 12),
        AppTextField(controller: passCtrl, label: 'Password', obscure: true),
        const SizedBox(height: 24),
        AppButton(
          label: 'Ingresar',
          loading: auth.loading,
          onPressed: () async {
            await auth.login(emailCtrl.text.trim(), passCtrl.text.trim());
            if (mounted && auth.user != null) context.go('/home');
          },
        ),
        if (auth.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              auth.error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
