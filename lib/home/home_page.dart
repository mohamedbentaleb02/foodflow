import 'package:flutter/material.dart';
import 'package:pfefinal/home/profil.dart';
import 'list_saved.dart';
import 'main_recipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int _selectedIndex = 0;
  List pages = [
    const MainRecipePage(),
    const ListSaved(),
    Profil(),
  ];
  void onTapNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 235, 129, 102),
        //type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 219, 219, 219),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: onTapNav,
        items:  const [
          
          BottomNavigationBarItem(
            label: '',
            icon: ImageIcon(AssetImage('assets/icons/home.png')),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: ImageIcon(AssetImage('assets/icons/saved-list.png')),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: ImageIcon(AssetImage('assets/icons/profile.png')),
          ),
        ],
      ),
    );
  }
}
