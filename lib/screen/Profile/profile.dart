import 'package:etkinlik_takip_projesi/component/bottomnavbarkullanici.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            const Text('Etkinlik Takip Projesi',
                style: TextStyle(
                    color: Color.fromARGB(230, 19, 10, 113),
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            SizedBox(
              height: 2,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromARGB(255, 218, 188, 255),
        child: ListView(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Color.fromARGB(255, 138, 72, 237),
                    ),
                    onPressed: () => Navigator.pushNamed(context, "/userinfo"),
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Color.fromARGB(230, 19, 10, 113),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                                child: Text(
                              "Profile",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Color.fromARGB(230, 19, 10, 113),
                              ),
                            )),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color.fromARGB(230, 19, 10, 113),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Color.fromARGB(255, 138, 72, 237),
                    ),
                    onPressed: () {
                      authService.signOut();
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Color.fromARGB(230, 19, 10, 113),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                                child: Text(
                              "Çıkış Yap",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Color.fromARGB(230, 19, 10, 113),
                              ),
                            )),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color.fromARGB(230, 19, 10, 113),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarKullanici(
          color: Color.fromARGB(255, 248, 246, 255),
          selectedMenu: MenuStateKullanici.profile),
    );
  }
}
