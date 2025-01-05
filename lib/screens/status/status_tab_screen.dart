import 'package:flutter/material.dart';

class StatusTabScreen extends StatefulWidget {
  const StatusTabScreen({super.key});

  @override
  State<StatusTabScreen> createState() => _StatusTabScreenState();
}

class _StatusTabScreenState extends State<StatusTabScreen> {
  final int _currentIndex = 3;

  final List<String> _routes = [
    '/projects',
    '/feedback',
    '/network',
    '/status',
    '/more',
  ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("This is Sample Status Screen"),
      ),
    );
  }
}
