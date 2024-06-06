import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/bottomnavigationbar.dart';
import 'package:etkinlik_takip_projesi/screen/ActicityList/activityUpdate.dart';
import 'package:etkinlik_takip_projesi/screen/ActicityList/participantList.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({
    Key? key,
  }) : super(key: key);

  @override
  State<ActivityList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<ActivityList> {
  AuthService authService = AuthService();

  DocumentReference? id;
  bool height = true;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Stream? etkinlikStream;
  getontheload() async {
    etkinlikStream = await AuthService().tumEtkinlikler();
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
        title: const Text('Etkinlik Listesi',
            style: TextStyle(
                color: Color.fromARGB(230, 19, 10, 113),
                fontWeight: FontWeight.bold,
                fontSize: 25)),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/lacivert.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: allActivityDetails(),
      ),
      bottomNavigationBar: const BottomNavBar(selectedMenu: MenuState.activity),
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

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 27, vertical: 25),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 187, 234, 255),
                            borderRadius: BorderRadius.circular(10),
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
                                      SizedBox(height: 10),
                                      Text(
                                        "Başlık: ",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                230, 19, 10, 113),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      Text(
                                        ds["title"],
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 0, 17, 255),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Konum Başlığı: ",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color:
                                              Color.fromARGB(230, 19, 10, 113),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        ds["konumBaslik"],
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 0, 17, 255),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Lokasyon Bilgileri: ",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color:
                                              Color.fromARGB(230, 19, 10, 113),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        "${geoPoint.latitude},${geoPoint.longitude} ",
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 0, 17, 255),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Açıklama: ",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color:
                                              Color.fromARGB(230, 19, 10, 113),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        ds["description"],
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 0, 17, 255),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Text(
                                            "Tarih: ",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                              fontSize: 17,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 0, 17, 255),
                                              fontSize: 17,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Text(
                                            "Saat: ",
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            "${dateTime.hour}:${dateTime.minute}",
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Color.fromARGB(
                                                  255, 0, 17, 255),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityUpdate(
                                                    id: ds.id,
                                                    title: ds["title"],
                                                    locationInfo:
                                                        ds["konumBaslik"],
                                                    location: ds["konum"],
                                                    description:
                                                        ds["description"],
                                                    dateTime: dateTime,
                                                  ),
                                                ));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Color.fromARGB(
                                                230, 19, 10, 113),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            authService
                                                .etkinlikSil(ds.reference);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Color.fromARGB(
                                                230, 19, 10, 113),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ParticiPantList(
                                                        id: ds.id,
                                                        title: ds["title"]),
                                              ));
                                        },
                                        child: Text(
                                          "Katılımcı listesi",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 16),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
            : Container(
                child: Text(""),
              );
      }),
    );
  }
}
