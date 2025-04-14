import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dsjgeqomxalpsijffovp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRzamdlcW9teGFscHNpamZmb3ZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ0MDI3NzAsImV4cCI6MjA1OTk3ODc3MH0.xINcR1SATP_NaK_6OkbVYojJFURN-xyJEYQLUyJUigI',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prince of Peace Songs',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
