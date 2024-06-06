import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';

class ParticiPantList extends StatefulWidget {
  ParticiPantList({super.key, required this.id, required this.title});
  final String id;
  final String title;

  @override
  State<ParticiPantList> createState() => _ParticiPantListState();
}

class _ParticiPantListState extends State<ParticiPantList> {
  Stream? eKullaniciStream;
  getontheload() async {
    eKullaniciStream =
        await AuthService().etkinligeKatilanKullanicilar(widget.id);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Etkinliğe Katılan Kullanıcılar",
          style: TextStyle(
            color: Color.fromARGB(230, 19, 10, 113),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Etkinlik Başlığı:   ",
                      style: TextStyle(
                          color: Color.fromARGB(255, 40, 119, 255),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.underline),
                    ),
                    Text(
                      "${widget.title}",
                      style: TextStyle(
                          color: Color.fromARGB(230, 19, 10, 113),
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                ),
              ],
            )),
        body: StreamBuilder(
          stream: eKullaniciStream,
          builder: ((context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.94,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 168, 200, 255),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(
                                          "Email: " + ds["email"],
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                230, 19, 10, 113),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Kullanıcı Adı: " + ds["username"],
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                230, 19, 10, 113),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Telefon Numarası: " + ds["number"],
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                230, 19, 10, 113),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      );
                    })
                : Container(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(""),
                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
