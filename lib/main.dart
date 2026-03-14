import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('history');
  runApp(const SugarScan1App());
}

class SugarScan1App extends StatelessWidget {
  const SugarScan1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SugarScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B4332),
          primary: const Color(0xFF1B4332),
          secondary: const Color(0xFF2ECC71),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
