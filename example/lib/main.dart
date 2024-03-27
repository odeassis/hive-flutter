import 'package:bacon/bacon.dart';
import 'package:example/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData.light().copyWith(extensions: <ThemeExtension<dynamic>>[
        BaconTheme(tokens: BaconTokens.light)
      ]),
      darkTheme: ThemeData.dark().copyWith(
          extensions: <ThemeExtension<dynamic>>[
            BaconTheme(tokens: BaconTokens.dark)
          ]),
      themeMode: ThemeMode.dark,
    );
  }
}

class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go('/primitives/avatar'),
            child: const Text('Go to the Avatar screen'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/primitives/badge'),
            child: const Text('Go to the Details screen'),
          ),
        ],
      ),
    );
  }
}
