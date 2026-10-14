import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_page.dart';
import 'theme/cores.dart';

void main() {
  runApp(const ControleLotacaoApp());
}

class ControleLotacaoApp extends StatelessWidget {
  const ControleLotacaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppCores.primaria,
        primary: AppCores.primaria,
      ),
      scaffoldBackgroundColor: AppCores.fundo,
    );

    return MaterialApp(
      title: 'Controle de Lotação',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(textTheme: GoogleFonts.robotoTextTheme(base.textTheme)),
      home: const HomePage(),
    );
  }
}
