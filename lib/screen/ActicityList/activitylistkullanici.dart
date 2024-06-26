import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/activityCard.dart';
import 'package:etkinlik_takip_projesi/component/bottomnavbarkullanici.dart';
import 'package:etkinlik_takip_projesi/component/provider.dart';
import 'package:etkinlik_takip_projesi/screen/GoogleMaps/mapNavigation.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DocumentReference? id;
  bool height = true;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Stream? etkinlikStream;
  getontheload() async {
    String companyName = Provider.of<UserProvider>(context).userCompanyName;

    etkinlikStream = await AuthService().kullaniciTumEtkinlikler(companyName);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getontheload();
    allActivityDetails();
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            SizedBox(
              height: 2,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: allActivityDetails(),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
      bottomNavigationBar: const BottomNavBarKullanici(
          color: Color.fromARGB(255, 248, 246, 255),
          selectedMenu: MenuStateKullanici.activity),
    );
  }

  Widget allActivityDetails() {
    String companyName = Provider.of<UserProvider>(context).userCompanyName;
    User? user = firebaseAuth.currentUser;

    return StreamBuilder(
      stream: etkinlikStream,
      builder: ((context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                Timestamp timestamp = ds["date"];
                DateTime dateTime = timestamp.toDate();
                GeoPoint geoPoint = ds["konum"];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityCard(
                            title: ds["title"] ?? '',
                            description: ds["description"] ?? '',
                            categories: ds["categories"] ?? '',
                            companyName: ds["companyName"] ?? '',
                            konumBaslik: ds["konumBaslik"] ?? '',
                            geoPoint: ds["konum"] ?? GeoPoint(0, 0),
                            datetime: dateTime,
                          ),
                        ));
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ds["title"],
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  authService
                                      .kullaniciEtkinlikSil(ds.reference);
                                  authService.etkinlikKullaniciSil(
                                      companyName, ds.id);
                                },
                                icon: Icon(
                                  Icons.cancel_rounded,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            ds["description"],
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.deepPurple,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                ds["konumBaslik"],
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.deepPurple,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.deepPurple,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "${dateTime.hour}:${dateTime.minute}",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              });
        } else {
          return Center(
            child: Text(
              "Katıldığınız etkinlik yok",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      }),
    );
  }
}
