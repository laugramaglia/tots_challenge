import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_challenge/core/extensions/context.dart';
import 'package:frontend_challenge/core/mixins/loading_mixin.dart';
import 'package:frontend_challenge/core/theme/theme.dart';
import 'package:frontend_challenge/core/widgets/custom_field.dart';
import 'package:frontend_challenge/core/widgets/custom_scaffold.dart';
import 'package:frontend_challenge/features/auth/models/user_model.dart';
import 'package:frontend_challenge/features/auth/viewmodel/auth_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with LoadingMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    ref.listen(authViewModelProvider, (previous, next) {
      if (next is AsyncData<UserModel?>) {
        if (next.value != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
        }
      }
    });
    return CustomScaffold(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo.png'),
              const SizedBox(height: 50),
              Text(
                'LOG IN',
                style: context.textTheme.bodyLarge?.copyWith(
                    wordSpacing: 8,
                    letterSpacing: 7,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 34),
              CustomField(
                hintText: 'Mail',
                controller: emailController,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                validators: const [TextValidator.required, TextValidator.email],
              ),
              const SizedBox(height: 15),
              CustomField(
                hintText: 'Password',
                controller: passwordController,
                suffixIcon: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.remove_red_eye)),
                isObscureText: true,
                validators: const [TextValidator.required],
              ),
              const SizedBox(height: 29),
              authState.maybeWhen(
                orElse: () => const SizedBox.shrink(),
                error: (error, stackTrace) => Text(
                  error.toString(),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: 29),
              SizedBox(
                width: 395,
                height: 60,
                child: ElevatedButton(
                  style: context.theme.elevatedBlackPill,
                  child: const Text('Log in'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      insetOverlay(
                        () async => await ref
                            .read(authViewModelProvider.notifier)
                            .loginUser(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
