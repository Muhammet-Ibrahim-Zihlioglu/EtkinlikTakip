import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';

enum MenuStateKullanici { home, activity, profile }

class BottomNavBarKullanici extends StatefulWidget {
  const BottomNavBarKullanici({
    Key? key,
    required this.selectedMenu,
    required this.color,
  }) : super(key: key);
  final MenuStateKullanici selectedMenu;
  final Color? color;

  @override
  State<BottomNavBarKullanici> createState() => _BottomNavBarKullaniciState();
}

class _BottomNavBarKullaniciState extends State<BottomNavBarKullanici> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: widget.color,
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.home_filled,
                    color: MenuStateKullanici.home == widget.selectedMenu
                        ? Colors.deepPurple.shade900
                        : inActiveIconColor,
                  ),
                  onPressed: () => {
                        Navigator.pushReplacementNamed(
                            context, "/homekullanici"),
                      }),
              IconButton(
                  icon: Icon(
                    Icons.local_activity,
                    color: MenuStateKullanici.activity == widget.selectedMenu
                        ? Colors.deepPurple.shade900
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, "/activitylistkullanici");
                  }),
              IconButton(
                  icon: Icon(
                    Icons.person,
                    color: MenuStateKullanici.profile == widget.selectedMenu
                        ? Colors.deepPurple.shade900
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/profile");
                  }),
            ],
          )),
    );
  }
}
