import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/savedbutton.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';
import '../../Component/mytextfield.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final AuthService authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final email = TextEditingController();
  final username = TextEditingController();
  final number = TextEditingController();
  final password = TextEditingController();
  final passwordagain = TextEditingController();
  final selectedCompany = TextEditingController();

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<List<String>> fetchCompanies() async {
    List<String> companyNames = [];
    await _firestore
        .collection('Company')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        companyNames.add(doc[
            'companyName']); // Assuming 'companyName' is the field for company names
      });
    });
    return companyNames;
  }

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
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
                      FutureBuilder<List<String>>(
                        future: fetchCompanies(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Text('No companies available');
                          } else {
                            List<String> companies = snapshot.data!;
                            if (companies.length == 1) {
                              selectedCompany.text = companies[0];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: TextField(
                                  controller: selectedCompany,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade600),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color:
                                              Color.fromARGB(255, 33, 25, 184),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    fillColor: Colors.grey.shade300,
                                    filled: true,
                                    hintText: "Şirket",
                                    hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: DropdownButtonFormField<String>(
                                  value: selectedCompany.text.isNotEmpty
                                      ? selectedCompany.text
                                      : null,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade600),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color:
                                              Color.fromARGB(255, 33, 25, 184),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    fillColor: Colors.grey.shade300,
                                    filled: true,
                                    hintText: "Lütfen Bir Şirket Seçiniz",
                                    hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic),
                                  ),
                                  items: companies.map((String company) {
                                    return DropdownMenuItem<String>(
                                      value: company,
                                      child: Text(company),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    selectedCompany.text = newValue!;
                                  },
                                  hint: const Text('Şirket Seçin'),
                                ),
                              );
                            }
                          }
                        },
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
                            selectedCompany.text.isNotEmpty) {
                          if (password.text == passwordagain.text) {
                            RegExp gmailRegex =
                                RegExp(r'^[\w-\.]+@gmail\.com$');
                            if (gmailRegex.hasMatch(email.text)) {
                              if (password.text.length >= 6) {
                                authService.createPerson(
                                    selectedCompany.text,
                                    context,
                                    email.text,
                                    username.text,
                                    selectedCompany.text,
                                    number.text,
                                    password.text);
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
