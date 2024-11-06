import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_challenge/core/theme/theme.dart';
import 'package:frontend_challenge/features/auth/models/repositories/is_authenticated_provider.dart';
import 'package:frontend_challenge/features/auth/view/pages/login_page.dart';
import 'package:frontend_challenge/features/home/view/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(isAuthenticatedProvider);

    return MaterialApp(
      title: 'Tots challenge',
      theme: AppTheme.lightThemeMode,
      home: !(state.asData?.value ?? false)
          ? const LoginPage()
          : const HomePage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
