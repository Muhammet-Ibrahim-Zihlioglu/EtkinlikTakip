import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/mytextfield.dart';
import 'package:etkinlik_takip_projesi/component/provider.dart';
import 'package:etkinlik_takip_projesi/component/registerbutton.dart';
import 'package:etkinlik_takip_projesi/component/signbutton.dart';
import 'package:etkinlik_takip_projesi/screen/Home/homepagekullanici.dart';
import 'package:etkinlik_takip_projesi/screen/Register/register.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final AuthService authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? companyName;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        child: Text(
                          "Etkinlik Takip",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 94, 39, 176),
                              fontSize: 36,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Etkinlik Takip Sistemimize',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        'Hoşgeldiniz',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade600,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Şifre',
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RegisterButton(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => Register(),
                                )))
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  SignButton(onTap: () async {
                    RegExp gmailRegex = RegExp(r'^[\w-\.]+@gmail\.com$');
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      bool isCompany = await authService.companySignIn(
                          emailController.text,
                          passwordController.text,
                          context);
                      if (isCompany) {
                        Provider.of<UserProvider>(context, listen: false)
                            .setAdminCompanyName(emailController.text);
                        authService.companySignIn(emailController.text,
                            passwordController.text, context);
                      } else {
                        if (gmailRegex.hasMatch(emailController.text)) {
                          authService
                              .signIn(emailController.text,
                                  passwordController.text, context)
                              .then((user) async {
                            if (user != null) {
                              DocumentSnapshot docSnapshot =
                                  await firebaseFirestore
                                      .collection("Users")
                                      .doc(user.uid)
                                      .get();

                              if (docSnapshot.exists) {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .setuserCompanyName(
                                        docSnapshot["companyName"]);
                              }
                              return Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePageKullanici(),
                                  ));
                            }
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('HATA'),
                                    content: const Text(
                                        'Geçerli bir eposta giriniz.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Ok'))
                                    ],
                                  ));
                        }
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('HATA'),
                                content: const Text(
                                    'Lütfen Bütün Bilgileri Boş Alan Kalmayacak Şekilde Doldurunuz'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Ok'))
                                ],
                              ));
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
