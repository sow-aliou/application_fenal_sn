import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'utils/theme.dart';

void main() {
  runApp(
    // ProviderScope is needed by Riverpod
    const ProviderScope(
      child: FenalApp(),
    ),
  );
}

class FenalApp extends StatelessWidget {
  const FenalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FÉÑAL',
      debugShowCheckedModeBanner: false,
      theme: FenalTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
