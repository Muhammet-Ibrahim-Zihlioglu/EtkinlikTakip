import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/bottomnavbarkullanici.dart';
import 'package:etkinlik_takip_projesi/screen/GoogleMaps/mapNavigation.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';

class ActivityListKullanici extends StatefulWidget {
  const ActivityListKullanici({
    Key? key,
  }) : super(key: key);

  @override
  State<ActivityListKullanici> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityListKullanici> {
  AuthService authService = AuthService();
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController time = TextEditingController();
  DocumentReference? id;
  bool height = true;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Stream? etkinlikStream;
  getontheload() async {
    etkinlikStream = await AuthService().tumKullaniciEtkinlikler();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    allActivityDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            const Text('Katıldığım Etkinlikler',
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
        child: allActivityDetails(),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/a.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarKullanici(
          color: Color.fromARGB(255, 248, 246, 255),
          selectedMenu: MenuStateKullanici.activity),
    );
  }

  Widget allActivityDetails() {
    return StreamBuilder(
      stream: etkinlikStream,
      builder: ((context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  Timestamp timestamp = ds["date"];
                  DateTime dateTime = timestamp.toDate();
                  GeoPoint geoPoint = ds["konum"];
                  return Column(
                    children: [
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 211, 207, 255),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25, right: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        "Etkinlik Başlığı: ",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.purple.shade700,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        ds["title"],
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(230, 19, 10, 113),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        "Konum Başlığı: ",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.purple.shade700,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        ds["konumBaslik"],
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(230, 19, 10, 113),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        "Lokasyon Bilgileri: ",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.purple.shade700,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Enlem: ",
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            "${geoPoint.latitude}",
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            "Boylam: ",
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            "${geoPoint.longitude}",
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Açıklama: ",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.purple.shade700,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        ds["description"],
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(230, 19, 10, 113),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Tarih: ",
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.purple.shade700,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Saat: ",
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.purple.shade700,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            "${dateTime.hour}:${dateTime.minute}",
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MapsNavigation(
                                                        geoPointLast:
                                                            ds["konum"]),
                                              ));
                                        },
                                        child: Row(children: [
                                          Icon(Icons.location_on_rounded,
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                              size: 25),
                                          Text(
                                            "Konum",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                            ),
                                          )
                                        ]),
                                      ),
                                      IconButton(
                                        iconSize: 30,
                                        onPressed: () {
                                          authService.kullaniciEtkinlikSil(
                                              ds.reference);
                                          authService
                                              .etkinlikKullaniciSil(ds.id);
                                        },
                                        icon: const Icon(
                                          Icons.cancel_rounded,
                                          color:
                                              Color.fromARGB(230, 19, 10, 113),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })
            : Container(
                child: Text(""),
              );
      }),
    );
  }
}
