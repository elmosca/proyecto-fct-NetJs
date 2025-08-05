import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBottomNavigation extends ConsumerStatefulWidget {
  const AppBottomNavigation({super.key});

  @override
  ConsumerState<AppBottomNavigation> createState() =>
      _AppBottomNavigationState();
}

class _AppBottomNavigationState extends ConsumerState<AppBottomNavigation> {
  int _currentIndex = 0;

  final List<BottomNavigationBarItem> _items = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.work),
      label: 'Proyectos',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.task),
      label: 'Tareas',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'Usuarios',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        _navigateToPage(index);
      },
      items: _items,
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        context.router.pushNamed('/app/dashboard');
        break;
      case 1:
        context.router.pushNamed('/app/projects');
        break;
      case 2:
        context.router.pushNamed('/app/tasks');
        break;
      case 3:
        context.router.pushNamed('/app/users');
        break;
    }
  }
}
