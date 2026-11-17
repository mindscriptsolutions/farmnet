import 'package:flutter/material.dart';

import 'services/app_locale.dart';
import 'services/classifier.dart';
import 'screens/home_screen.dart';

final Classifier classifier = Classifier();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocale.load();
  runApp(const FarmNetApp());
}

class FarmNetApp extends StatelessWidget {
  const FarmNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLocale.code,
      builder: (context, _, __) {
        return MaterialApp(
          title: 'FarmNet',
          debugShowCheckedModeBanner: false,
          theme: _theme(),
          home: const HomeScreen(),
        );
      },
    );
  }

  ThemeData _theme() {
    const seed = Color(0xFF2E7D32); // agricultural green
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF4F7F2),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
