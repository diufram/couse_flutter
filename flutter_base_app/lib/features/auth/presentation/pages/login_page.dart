import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/components/app_scaffold.dart';
import '../../../../core/components/app_form.dart';
import '../../../../core/components/app_text.dart';
import '../../../../core/components/app_text_field.dart';
import '../../../../core/components/app_button.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return AppScaffold(
      body: AppForm(
        // scroll + manejo de teclado + ancho máximo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_outline, size: 72),
            const SizedBox(height: 16),
            const AppTitle('Bienvenido', level: 2, align: TextAlign.center),
            const SizedBox(height: 8),
            const AppText(
              'Inicia sesión para continuar',
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),

            AppTextField(
              controller: emailCtrl,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: passCtrl,
              label: 'Password',
              obscure: true,
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Ingresar',
              loading: auth.loading,
              onPressed: () async {
                await auth.login(emailCtrl.text.trim(), passCtrl.text.trim());
                if (mounted && auth.user != null) context.go('/home');
              },
            ),

            if (auth.error != null) ...[
              const SizedBox(height: 8),
              AppText(
                auth.error!,
                align: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
