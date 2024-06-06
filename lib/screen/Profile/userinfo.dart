import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  void initState() {
    super.initState();
    getontheload();
  }

  getontheload() async {
    kullaniciStream = await authService.tumKullanicilar();
    setState(() {});
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double genislik = MediaQuery.of(context).size.width;
    User? user = _auth.currentUser;
    String id = user?.uid ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Profilim',
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
      body: StreamBuilder(
        stream: kullaniciStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                if (ds.id == id) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/profil.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 75),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Email: ",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.purple.shade700,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${ds["email"]}",
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromARGB(230, 19, 10, 113),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Kullanıcı Adı: ",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.purple.shade700,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${ds["username"]}",
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromARGB(230, 19, 10, 113),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Telefon No: ",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.purple.shade700,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${ds["number"]}",
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromARGB(230, 19, 10, 113),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
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
