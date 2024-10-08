import 'package:flutter/material.dart';
import 'package:flutter_todo/ui/page/tasks_completed_list_page.dart';
import 'tasks_opened_list_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TasksOpenedListPage(title: 'Tarefas Abertas'),
    TasksCompletedListPage(title: 'Tarefas Concluídas'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Abertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Concluídas',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        unselectedItemColor: Theme.of(context).colorScheme.inverseSurface,
        onTap: _onItemTapped,
      ),
    );
  }
}
