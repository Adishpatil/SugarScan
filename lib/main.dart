import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "screens/home_screen.dart";
import "services/language_service.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("history");
  LanguageService().load();
  runApp(const SugarScan1App());
}

class SugarScan1App extends StatefulWidget {
  const SugarScan1App({super.key});
  @override
  State<SugarScan1App> createState() => _SugarScan1AppState();
}

class _SugarScan1AppState extends State<SugarScan1App> {
  @override
  void initState() {
    super.initState();
    LanguageService().addListener(() { if (mounted) setState(() {}); });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SugarScan",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B4332)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
