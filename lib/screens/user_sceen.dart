import 'package:flutter/material.dart';

import '../pages/finans_page.dart';
import '../pages/profile_page.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  final List<Widget> pages = [const HistoryPage(), const ProfilePage()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(160, 200, 300, 400),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Записи'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль')
        ],
        backgroundColor: Color.fromARGB(160, 200, 300, 400),
        selectedItemColor: Color.fromARGB(160, 200, 300, 400),
        unselectedItemColor: Colors.black,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() => currentIndex = value);
        },
      ),
    );
  }
}
