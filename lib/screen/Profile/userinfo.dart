import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/provider.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

// Gereksiz setState çağrısını kaldırabiliriz
class _UserInfoState extends State<UserInfo> {
  Stream? kullaniciStream;
  AuthService authService = AuthService();

  // Bu metot initState içine taşınabilir
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getontheload();
  }

  getontheload() async {
    String companyName = Provider.of<UserProvider>(context).userCompanyName;

    kullaniciStream = await authService.tumKullanicilar(companyName);
    setState(() {});
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String id = user?.uid ?? "";
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text(
          'Profilim',
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
      body: StreamBuilder(
        stream: kullaniciStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                if (ds.id == id) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 4),
                    child: Card(
                      elevation: 40,
                      color: Colors.deepPurple.shade50,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 10, top: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  ds["companyName"],
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.purple.shade800,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                    decorationColor:
                                        Color.fromARGB(230, 19, 10, 113),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    " Şirket Çalışanı",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                      color: Colors.purple.shade800,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Email: ",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.purple.shade700,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${ds["email"]}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromARGB(230, 19, 10, 113),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Kullanıcı Adı: ",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.purple.shade700,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "${ds["username"]}",
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color.fromARGB(230, 19, 10, 113),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Telefon No: ",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.purple.shade700,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${ds["number"]}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromARGB(230, 19, 10, 113),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(); // Alternatif olarak bir widget döndürebilirsiniz
                }
              },
            );
          } else {
            return Container(); // Yükleme durumunda alternatif bir widget döndür
          }
        },
      ),
    );
  }
}
