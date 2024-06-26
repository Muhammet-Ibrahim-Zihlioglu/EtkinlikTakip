import 'package:etkinlik_takip_projesi/component/bottomnavbarkullanici.dart';
import 'package:etkinlik_takip_projesi/screen/Profile/password.dart';
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
        title: const Text(
          'Etkinlik Takip Projesi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 25),
            _buildProfileOption(
              context,
              icon: Icons.person,
              label: 'Profil',
              onTap: () => Navigator.pushNamed(context, "/userinfo"),
            ),
            const SizedBox(height: 20),
            _buildProfileOption(
              context,
              icon: Icons.key_rounded,
              label: 'Parola Değiştir',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Password(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileOption(
              context,
              icon: Icons.logout,
              label: 'Çıkış Yap',
              onTap: () {
                authService.signOut();
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarKullanici(
          color: Color.fromARGB(255, 248, 246, 255),
          selectedMenu: MenuStateKullanici.profile),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.deepPurple.shade100,
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.deepPurple,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.deepPurple.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
