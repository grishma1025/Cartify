import 'package:flutter/material.dart';

import '../widgets/bottom_navbar.dart';
import 'buy_again_screen.dart';
import 'cart_screen.dart';
import 'categories_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState
    extends State<MainScreen> {

  int selectedIndex = 0;

  final List<Widget> screens = [

    const HomeScreen(),

    CategoriesScreen(),

    const OrdersScreen(),

    const BuyAgainScreen(),

    const CartScreen(),
  ];

  Future<bool> onWillPop() async {

    if (selectedIndex != 0) {

      setState(() {
        selectedIndex = 0;
      });

      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(

      onWillPop: onWillPop,

      child: Scaffold(

        body: screens[selectedIndex],

        bottomNavigationBar: BottomNavbar(

          currentIndex: selectedIndex,

          onTap: (index) {

            setState(() {
              selectedIndex = index;
            });

          },
        ),
      ),
    );
  }
}