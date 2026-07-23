import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {

  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(

      currentIndex: currentIndex,

      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF4B5563),
      unselectedItemColor: const Color(0xFF9CA3AF),

      selectedFontSize: 11,
      unselectedFontSize: 11,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),

      onTap: onTap,

      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Home",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          activeIcon: Icon(Icons.grid_view),
          label: "Categories",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: "Orders",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.replay_outlined),
          activeIcon: Icon(Icons.replay),
          label: "Buy Again",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: "Cart",
        ),
      ],
    );
  }
}