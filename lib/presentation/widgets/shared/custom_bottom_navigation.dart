import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigation({super.key, required this.currentIndex});

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
      case 2:
        context.go('/home/2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex,
      onTap: (value) {
        onItemTapped(context, value);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Catalogo'),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up_rounded),
          label: 'Populares',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Favoritos',
        ),
      ],
    );
  }
}
