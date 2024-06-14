import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habituo/firebase_options.dart';
import 'package:habituo/pages/auth_page.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      // home: const HomePage(),
      home: const AuthPage(),
    );
  }
}
