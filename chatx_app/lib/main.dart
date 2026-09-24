import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/sms_confirmation_screen.dart';
import 'screens/sms_validation_screen.dart';
import 'screens/email_validation_screen.dart';
import 'screens/inbox_screen.dart';
import 'screens/contact_profile_screen.dart';
import 'screens/voice_call_screen.dart';
import 'screens/my_profile_screen.dart';
import 'screens/message_modification_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const SplashScreen(),
      // Routes nommées (optionnel)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/inbox': (context) => const InboxScreen(),
        '/profile': (context) => const MyProfileScreen(),
      },
    );
  }
}