import 'package:flutter/material.dart';
import '../main.dart';
import 'teams_screen.dart';
import 'scorecard_screen.dart';
import 'route_screen.dart';
import 'questions_screen.dart';
import 'powerups_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TeamsScreen(),
    ScorecardScreen(),
    RouteScreen(),
    QuestionsScreen(),
    PowerupsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        indicatorColor: kOrange.withOpacity(0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group, color: kOrange),
            label: 'Teams',
          ),
          NavigationDestination(
            icon: Icon(Icons.scoreboard_outlined),
            selectedIcon: Icon(Icons.scoreboard, color: kOrange),
            label: 'Scorecard',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map, color: kOrange),
            label: 'Route',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz, color: kOrange),
            label: 'Vragen',
          ),
          NavigationDestination(
            icon: Icon(Icons.bolt_outlined),
            selectedIcon: Icon(Icons.bolt, color: kOrange),
            label: 'Powerups',
          ),
        ],
      ),
    );
  }
}
