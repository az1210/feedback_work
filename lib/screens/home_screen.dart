import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0; // Current tab index

  final List<String> _routes = [
    '/projects',
    '/feedback',
    '/network',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 90,
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedIconTheme: const IconThemeData(
              color: Color.fromARGB(255, 8, 102, 255), size: 30),
          unselectedIconTheme: const IconThemeData(
              color: Color.fromARGB(255, 101, 103, 107), size: 23),
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            color: Color.fromARGB(255, 8, 102, 255),
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            color: Color.fromARGB(255, 101, 103, 107),
          ),
          currentIndex: _currentIndex, // Current tab index
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            context.go(_routes[index]); // Navigate to the route
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
