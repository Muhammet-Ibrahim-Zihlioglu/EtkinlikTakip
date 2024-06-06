import 'package:etkinlik_takip_projesi/screen/LoginPage/loginpage.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';

enum MenuState { home, activity, employee, profile }

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);
  final MenuState selectedMenu;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.home_filled,
                    color: MenuState.home == widget.selectedMenu
                        ? Colors.black
                        : inActiveIconColor,
                  ),
                  onPressed: () => {
                        Navigator.pushReplacementNamed(context, "/home"),
                      }),
              IconButton(
                icon: Icon(
                  Icons.local_activity,
                  color: MenuState.activity == widget.selectedMenu
                      ? Colors.black
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/activitylist"),
              ),
              IconButton(
                icon: Icon(
                  Icons.person_pin_outlined,
                  color: MenuState.employee == widget.selectedMenu
                      ? Colors.black
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/employeelist"),
              ),
              IconButton(
                  icon: Icon(
                    Icons.logout_sharp,
                    color: MenuState.profile == widget.selectedMenu
                        ? Colors.black
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    authService.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ));
                  }),
            ],
          )),
    );
  }
}
