import 'package:etkinlik_takip_projesi/component/bottomnavigationbar.dart';
import 'package:etkinlik_takip_projesi/screen/CalendarPage/calendarpage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarScreen(),
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
