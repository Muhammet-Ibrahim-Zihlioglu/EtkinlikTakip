import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/provider.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticiPantList extends StatefulWidget {
  ParticiPantList({Key? key, required this.id, required this.title})
      : super(key: key);
  final String id;

  final String title;

  @override
  State<ParticiPantList> createState() => _ParticiPantListState();
}

class _ParticiPantListState extends State<ParticiPantList> {
  Stream? eKullaniciStream;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    getParticipants();
  }

  void getParticipants() async {
    String companyName =
        Provider.of<UserProvider>(context, listen: false).adminCompanyName;
    eKullaniciStream = await AuthService()
        .etkinligeKatilanKullanicilar(companyName, widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String companyName =
        Provider.of<UserProvider>(context, listen: false).adminCompanyName;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
          "Etkinliğe Katılan Kullanıcılar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: eKullaniciStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return Center(child: Text("Katılımcı bulunamadı."));
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.deepPurple.withOpacity(0.5)),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email: ${ds["email"]}",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Kullanıcı Adı: ${ds["username"]}",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Telefon Numarası: ${ds["number"]}",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                  shape: LinearBorder(),
                                  backgroundColor: Colors.deepPurple),
                              onPressed: () {
                                authService.kullaniciEtkinlikSil(ds.reference);
                                authService.etkinligeKatilanKullaniciyiCikarma(
                                    companyName, ds["email"], widget.id);
                              },
                              child: Text(
                                "Kullanıcıyı Etkinlikten Çıkar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
