import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'client.dart';
import 'api/app_loop_api.dart';
import 'screens/builds_screen.dart';
import 'screens/export_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/wishes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const MyApp());
}

/// Builds a theme for the given [brightness].
ThemeData _buildTheme(Brightness brightness) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: brightness,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppLoop',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: SignInScreen(
        child: AppLoopHome(
          onSignOut: () async {
            await client.auth.signOutDevice();
          },
        ),
      ),
    );
  }
}

/// Bottom-navigation shell of the AppLoop loop. Stages that land in later
/// features show honest placeholders (see PLAN.md).
class AppLoopHome extends StatefulWidget {
  final Future<void> Function() onSignOut;

  const AppLoopHome({super.key, required this.onSignOut});

  @override
  State<AppLoopHome> createState() => _AppLoopHomeState();
}

class _AppLoopHomeState extends State<AppLoopHome> {
  int _index = 0;

  static const _tabs = [
    (icon: Icons.lightbulb, label: 'Wishes'),
    (icon: Icons.build, label: 'Builds'),
    (icon: Icons.rate_review, label: 'Feedback'),
    (icon: Icons.ios_share, label: 'Export'),
  ];

  @override
  Widget build(BuildContext context) {
    final api = ServerAppLoopApi(client);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppLoop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => widget.onSignOut(),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          WishesScreen(api: api),
          BuildsScreen(api: api),
          FeedbackScreen(api: api),
          ExportScreen(api: api),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}
