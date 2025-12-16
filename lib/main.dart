import 'package:flutter/material.dart';
import 'package:shop/screens/deal_monitor/deal_monitor_screen.dart';
import 'package:shop/theme/app_theme.dart';

void main() {
  runApp(const DealMonitorApp());
}

class DealMonitorApp extends StatelessWidget {
  const DealMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deal Trigger Early-Warning Monitor',
      theme: AppTheme.lightTheme(context),
      home: const DealMonitorScreen(),
    );
  }
}
