import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/bottomnavigationbar.dart';
import 'package:etkinlik_takip_projesi/component/provider.dart';
import 'package:etkinlik_takip_projesi/screen/ActicityList/activityUpdate.dart';
import 'package:etkinlik_takip_projesi/screen/ActicityList/participantList.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({
    Key? key,
  }) : super(key: key);

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  AuthService authService = AuthService();
  Stream? etkinlikStream;

  void getontheload() async {
    String companyName = Provider.of<UserProvider>(context).adminCompanyName;
    etkinlikStream = await AuthService().tumEtkinlikler(companyName);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getontheload();
  }

  @override
  Widget build(BuildContext context) {
    String companyName = Provider.of<UserProvider>(context).adminCompanyName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: Text(
          '$companyName Etkinlik Listesi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey.shade100,
        child: allActivityDetails(),
      ),
      bottomNavigationBar: const BottomNavBar(selectedMenu: MenuState.activity),
    );
  }

  Widget allActivityDetails() {
    return StreamBuilder(
      stream: etkinlikStream,
      builder: ((context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Text(
              "Henüz etkinlik bulunmamaktadır.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            Timestamp timestamp = ds["date"];
            DateTime dateTime = timestamp.toDate();
            GeoPoint geoPoint = ds["konum"];

            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActivityUpdate(
                                        id: ds.id,
                                        title: ds["title"],
                                        categories: ds["categories"],
                                        locationInfo: ds["konumBaslik"],
                                        location: ds["konum"],
                                        description: ds["description"],
                                        dateTime: dateTime,
                                      ),
                                    ),
                                  );
                                },
                                icon:
                                    Icon(Icons.edit, color: Colors.deepPurple),
                              ),
                              IconButton(
                                onPressed: () {
                                  authService.etkinlikSil(ds.reference);
                                },
                                icon: Icon(Icons.delete,
                                    color: Colors.deepPurple),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        ds["description"],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.green.shade300),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.category,
                              color: Colors.deepPurple, size: 18),
                          SizedBox(width: 5),
                          Text(
                            ds["categories"],
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.deepPurple, size: 18),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              ds["konumBaslik"],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.date_range,
                              color: Colors.deepPurple, size: 18),
                          SizedBox(width: 5),
                          Text(
                            "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(Icons.access_time,
                              color: Colors.deepPurple, size: 18),
                          SizedBox(width: 5),
                          Text(
                            "${dateTime.hour}:${dateTime.minute}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ParticiPantList(
                                    id: ds.id,
                                    title: ds["title"],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Katılımcı Listesi",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
