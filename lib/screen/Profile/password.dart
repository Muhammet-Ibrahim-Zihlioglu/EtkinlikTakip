import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  Password({super.key});
  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final AuthService authService = AuthService();
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController newPassAgain = TextEditingController();
  String? oldPassError;
  bool isOldPassValid = false;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    oldPass;
    oldPassError;
  }

  void _validateOldPassword() async {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPass.text,
        );

        // Reauthenticate the user to check if the old password is correct
        await user.reauthenticateWithCredential(credential);
        setState(() {
          isOldPassValid = true;
          oldPassError = null;
        });
      } catch (e) {
        setState(() {
          oldPassError = 'Eski şifre yanlış';
          isOldPassValid = false;
        });
      }
    }
  }

  void _changePassword() async {
    if (newPass.text == newPassAgain.text) {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        try {
          // Update the password in Firebase Authentication
          await user.updatePassword(newPass.text);

          // Update the password in Firestore
          await authService.updateCompanyPassword(user.uid, newPass.text);
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Şifre başarıyla güncellendi')),
          );
        } catch (e) {
          print("Failed to change password: $e");
        }
      }
    } else {
      setState(() {
        oldPassError = 'Yeni şifreler eşleşmiyor';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Şifre Değiştirme Ekranı',
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: oldPass,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: isOldPassValid
                                ? Colors.green
                                : Colors.deepPurple,
                            width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.deepPurple,
                        ),
                        borderRadius: BorderRadius.circular(30)),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Eski Şifre",
                    errorText: oldPassError,
                    hintStyle: TextStyle(
                        color: Colors.deepPurple, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _validateOldPassword,
                child: Text(
                  "Eski Şifreyi Doğrula",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 10),
              if (isOldPassValid) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: TextField(
                    controller: newPass,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.deepPurple,
                          ),
                          borderRadius: BorderRadius.circular(30)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Yeni Şifre",
                      hintStyle: TextStyle(
                          color: Colors.deepPurple,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: newPassAgain,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.deepPurple,
                          ),
                          borderRadius: BorderRadius.circular(30)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Yeni Şifre Tekrar",
                      hintStyle: TextStyle(
                          color: Colors.deepPurple,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _changePassword,
                  child: Text(
                    "Şifreyi Değiştir",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
