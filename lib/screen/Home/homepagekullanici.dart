import 'package:etkinlik_takip_projesi/component/bottomnavbarkullanici.dart';
import 'package:etkinlik_takip_projesi/screen/CalendarPage/calenderpagekullanici.dart';
import 'package:flutter/material.dart';

class HomePageKullanici extends StatelessWidget {
  HomePageKullanici({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarScreenKullanici(),
      bottomNavigationBar: const BottomNavBarKullanici(
        selectedMenu: MenuStateKullanici.home,
        color: Color.fromARGB(255, 248, 246, 255),
      ),
    );
  }
}
