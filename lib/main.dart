import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/core.dart';
import 'firebase_options.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';
import 'services/services.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // On Android, this will automatically use the google-services.json file
    // without needing the DefaultFirebaseOptions.currentPlatform (which contains fake values).
    await Firebase.initializeApp();

    runApp(const TicTacToeApp());
  } catch (e) {
    debugPrint('Firebase Error: $e');
    runApp(const TicTacToeApp());
  }
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final historyService = HistoryService();

    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<HistoryService>.value(value: historyService),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider<GameProvider>(
          create: (_) => GameProvider(historyService: historyService),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Tic Tac Toe',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
