import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bottom_bar/bottom_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const PowerFluxApp());
}

class PowerFluxApp extends StatelessWidget {
  const PowerFluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerFlux',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF000000),
          primary: Color(0xFFFFFFFF),
        ),
      ),
      home: const BottomBarShell(),
    );
  }
}
