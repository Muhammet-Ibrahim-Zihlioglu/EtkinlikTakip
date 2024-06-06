import 'package:etkinlik_takip_projesi/component/savedbutton.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../Component/mytextfield.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final AuthService authService = AuthService();

  final email = TextEditingController();
  final username = TextEditingController();
  final number = TextEditingController();
  final password = TextEditingController();
  final passwordagain = TextEditingController();

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 194, 213, 207),
          title: const Text(
            'KAYIT EKRANI',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(230, 19, 10, 113),
                fontSize: 25),
          ),
        ),
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
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      MyTextField(
                        controller: email,
                        hintText: 'E-mail',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: username,
                        hintText: 'Kullanıcı Adı',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: number,
                        hintText: 'Telefon Numarası',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: password,
                        hintText: 'Şifre',
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: passwordagain,
                        hintText: 'Şifre Tekrarı',
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      SavedButton(onTap: () {
                        if (email.text.isNotEmpty &&
                            username.text.isNotEmpty &&
                            number.text.isNotEmpty &&
                            password.text.isNotEmpty &&
                            password.text.isNotEmpty) {
                          if (password.text == passwordagain.text) {
                            RegExp gmailRegex =
                                RegExp(r'^[\w-\.]+@gmail\.com$');
                            if (gmailRegex.hasMatch(email.text)) {
                              if (password.text.length >= 6) {
                                authService.createPerson(context, email.text,
                                    username.text, number.text, password.text);
                                Navigator.pushNamed(context, "/login");
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('HATA'),
                                          content: const Text(
                                              'Girilen Şifre En Az 6 Haneli Olmalıdır.'),
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
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
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
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('HATA'),
                                      content: const Text(
                                          'Girilen Şifreler Aynı Değil'),
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
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('HATA'),
                                    content: const Text(
                                        'Lütfen Bütün Bilgileri Boş Alan Kalmayacak Şekilde Doldurunuz'),
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
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
