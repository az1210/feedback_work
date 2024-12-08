import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StatusTabScreen extends StatefulWidget {
  const StatusTabScreen({super.key});

  @override
  State<StatusTabScreen> createState() => _StatusTabScreenState();
}

class _StatusTabScreenState extends State<StatusTabScreen> {
  int _currentIndex = 3;

  final List<String> _routes = [
    '/projects',
    '/feedback',
    '/network',
    '/status',
    '/more',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("This is Sample Status Screen"),
      ),
      bottomNavigationBar: SizedBox(
        height: 82,
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedIconTheme: const IconThemeData(size: 30),
          unselectedIconTheme: const IconThemeData(size: 23),
          selectedLabelStyle: const TextStyle(fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          selectedItemColor: const Color.fromARGB(255, 8, 102, 255),
          unselectedItemColor: const Color.fromARGB(255, 101, 103, 107),
          currentIndex: _currentIndex, // Current tab index
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            context.go(_routes[index]);
          },
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage(
                  'assets/images/icons/nav-tab/tabIcon2.png',
                ),
              ),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/icons/feedback-tab.png'),
              ),
              label: 'Feedback',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/icons/network-tab.png'),
              ),
              label: 'Network',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/icons/status-tab.png'),
              ),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/icons/more-tab.png'),
              ),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
