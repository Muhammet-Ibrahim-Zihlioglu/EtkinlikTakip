import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/activityCard.dart';
import 'package:etkinlik_takip_projesi/component/provider.dart';
import 'package:etkinlik_takip_projesi/screen/GoogleMaps/mapNavigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesCard extends StatefulWidget {
  CategoriesCard({super.key, required this.categories});
  String categories;
  @override
  State<CategoriesCard> createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Stream? etkinlikStream;
  getontheload() async {
    String companyName = Provider.of<UserProvider>(context).userCompanyName;

    etkinlikStream = await firebaseFirestore
        .collection("Company")
        .doc(companyName)
        .collection("Etkinlik Listesi")
        .where("categories", isEqualTo: widget.categories)
        .snapshots();

    setState(() {});
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    getontheload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Text("${widget.categories} Etkinlik Listesi",
              style: TextStyle(
                  color: Color.fromARGB(230, 19, 10, 113),
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
        ),
        body: StreamBuilder(
          stream: etkinlikStream,
          builder: ((context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                  child: Text(
                'Bu kategoriye ait etkinlik bulunmamaktadır.',
                style: TextStyle(
                  color: Colors.indigo.shade900,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ));
            }
            return snapshot.hasData
                ? ListView.builder(
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
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ds["title"],
                                      style: TextStyle(
                                        color: Color.fromARGB(230, 19, 10, 113),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ds["description"],
                                  style: TextStyle(
                                    color: Color.fromARGB(230, 19, 10, 113),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.indigo.shade900,
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      ds["konumBaslik"],
                                      style: TextStyle(
                                        color: Colors.indigo.shade700,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.indigo.shade900,
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                      style: TextStyle(
                                        color: Colors.indigo.shade700,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.indigo.shade900,
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${dateTime.hour}:${dateTime.minute}",
                                      style: TextStyle(
                                        color: Colors.indigo.shade700,
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
                    })
                : Container(
                    child: Text(""),
                  );
          }),
        ));
  }
}
