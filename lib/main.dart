import 'package:flutter/material.dart';
import 'routes/index.dart';

void main() {
  runApp(const FruitScanApp());
}

class FruitScanApp extends StatelessWidget {
  const FruitScanApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
