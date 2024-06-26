import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/activityCard.dart';
import 'package:etkinlik_takip_projesi/component/categoriesCard.dart';
import 'package:etkinlik_takip_projesi/component/provider.dart';
import 'package:etkinlik_takip_projesi/screen/GoogleMaps/mapNavigation.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:etkinlik_takip_projesi/service/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreenKullanici extends StatefulWidget {
  const CalendarScreenKullanici({
    super.key,
    this.companyName,
  });
  final String? companyName;
  @override
  _CalendarPageKullaniciState createState() => _CalendarPageKullaniciState();
}

class _CalendarPageKullaniciState extends State<CalendarScreenKullanici> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  AuthService authService = AuthService();
  List<Event> _events = [];
  String baslik = "";

  void _EventLoader() async {
    String companyName = Provider.of<UserProvider>(context).userCompanyName;

    Stream<QuerySnapshot> eventStream =
        await AuthService().tumEtkinlikler(companyName);

    eventStream.listen((QuerySnapshot snapshot) {
      setState(() {
        _events = snapshot.docs.map((DocumentSnapshot doc) {
          Timestamp timestamp = doc["date"];
          DateTime dateTime = timestamp.toDate();
          return Event(
              title: doc["title"],
              description: doc["description"],
              dateTime: dateTime,
              time: TimeOfDay.fromDateTime(dateTime),
              categories: doc["categories"],
              companyName: doc["companyName"]);
        }).toList();
      });
    });
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userEmail;
  String? userNumber;
  String? userName;

  String? companyName;
  List<String> idList = [];
  void getUserActivity(String id, int sira) async {
    User? user = auth.currentUser;

    QuerySnapshot querySnapshot = await firestore
        .collection("Company")
        .doc(companyName)
        .collection("Çalışan Listesi")
        .doc(user?.uid)
        .collection("KullanıcınınKatıldığıEtkinlikler")
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        setState(() {});
        if (doc.id == id) {
          if (id.isNotEmpty) {
            idList = querySnapshot.docs.map((doc) => doc.id).toList();
          }
        } else {
          print("etkinliğe katılan kullanıcı bulunamadı");
        }
      });
    } else {
      print("Belirtilen koşullara uygun belge bulunamadı.");
    }
  }

  void _getUsers() async {
    User? user = auth.currentUser;

    // Check if the user is not null
    if (user != null) {
      // Get the document snapshot directly
      DocumentSnapshot docSnapshot =
          await firestore.collection("Users").doc(user.uid).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        setState(() {
          userEmail = docSnapshot["email"];
          companyName = docSnapshot["companyName"];
          userName = docSnapshot["username"];
          userNumber = docSnapshot["number"];
        });
      } else {
        // Handle the case where the document does not exist
        print("Document does not exist");
      }
    } else {
      // Handle the case where the user is null
      print("User is not signed in");
    }
  }

  Stream? etkinlikStream;
  Timestamp? timestamp;

  getontheload() async {
    String companyName = Provider.of<UserProvider>(context).userCompanyName;

    etkinlikStream = await AuthService().tumEtkinlikler(companyName);
    setState(() {});
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    getontheload();
    _EventLoader();
    _getUsers();
  }

  DateTime? _selectedDate;
  @override
  void setState(VoidCallback fn) {
    _selectedDate;
    idList;
    // TODO: implement setState
    super.setState(fn);
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    String? id = user?.uid ?? "";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (companyName != null)
                  Text('${companyName} ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                Text('Etkinlik Takvimi',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25)),
              ],
            ),
            SizedBox(
              height: 2,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.all(4),
        color: Colors.white,
        child: Column(
          children: [
            if (userName != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "$userName",
                    style: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TableCalendar(
                calendarStyle: CalendarStyle(
                  outsideTextStyle: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.grey.shade400),
                  defaultTextStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white), // Günlerin yazı rengi
                  weekendTextStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white), // Haftasonu günlerinin yazı rengi
                  selectedTextStyle:
                      TextStyle(color: Colors.white), // Seçili günün yazı rengi
                  todayTextStyle:
                      TextStyle(color: Colors.white), // Bugünün yazı rengi
                  todayDecoration: BoxDecoration(
                    color:
                        Colors.deepPurple.shade900, // Bugünün arka plan rengi
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color:
                        Colors.purple.shade700, // Seçili günün arka plan rengi
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.white, // Etkinlik işaretçilerinin rengi
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.white), // Başlık yazısının rengi

                  formatButtonTextStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white), // Format butonu yazısının rengi
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.deepPurple.shade900,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  titleCentered: true,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white), // Haftanın günlerinin yazı rengi
                  weekendStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white), // Haftasonu günlerinin yazı rengi
                ),
                eventLoader: (day) {
                  // Etkinliklerin olduğu günleri bul
                  List<DateTime> eventDays =
                      _events.map((event) => event.dateTime).toList();

                  // Etkinliklerin olduğu günlerin altına yuvarlak işaretçiler ekle
                  List<DateTime> markedDays = [];
                  for (DateTime eventDay in eventDays) {
                    if (isSameDay(eventDay, day)) {
                      markedDays.add(eventDay);
                    }
                  }
                  return markedDays;
                },
                firstDay: DateTime.utc(2024, 4, 1),
                locale: 'tr_TR',
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
                //Seçili günü yuvarlak içerisinde gösteriyor.
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton("Gezi", Icons.flight),
                _buildCategoryButton(
                    "Toplantı", Icons.video_camera_front_outlined),
                _buildCategoryButton("Eğitim", Icons.edit_calendar),
                _buildCategoryButton("Sosyal", Icons.people),
                _buildCategoryButton("Kültürel", Icons.theater_comedy),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Etkinlik Listesi",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline)),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: etkinlikStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("Lütfen Etkinlik Ekleyiniz."),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      Timestamp timestamp = ds["date"];
                      DateTime dateTime = timestamp.toDate();
                      getUserActivity(ds.id, index);

                      bool isUserJoined = idList.contains(ds.id);
                      if (isSameDay(dateTime, _focusedDay)) {
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          color: Colors.deepPurple.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    ds["title"],
                                    style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isUserJoined)
                                  const Text(
                                    "Katıldınız",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                else
                                  IconButton(
                                    iconSize: 35,
                                    onPressed: () {
                                      setState(() {});
                                      if (userEmail != null &&
                                          companyName != null) {
                                        authService.etkinligeKatilanKullanici(
                                          companyName!,
                                          id,
                                          ds.id,
                                          userEmail!,
                                          userName!,
                                          userNumber!,
                                        );
                                        authService.etkinlikKatil(
                                          companyName!,
                                          ds.id,
                                          ds["title"],
                                          ds["description"],
                                          dateTime,
                                          ds["konum"],
                                          ds["konumBaslik"],
                                          ds["categories"],
                                          ds["companyName"],
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                "Ekleme İşleminiz Tamamlanamadı!! Lütfen Takvimin Üzerinde Kullanıcı İsminiz Görünene Kadar Bekleyiniz",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Tamam'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.check_box,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${dateTime.day}/${dateTime.month}/${dateTime.year} ',
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      ' ${dateTime.hour}:${dateTime.minute}',
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MapsNavigation(
                                              geoPointLast: ds["konum"],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Konuma Git",
                                        style: TextStyle(
                                          color: Colors.deepPurple.shade700,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        DateTime? selectedDateTime =
                                            await _selectDateTime(context);
                                        if (selectedDateTime != null) {
                                          NotificationService
                                              .scheduleAlarmNotification(
                                            title: ds["title"],
                                            body: '${ds["description"]}',
                                            dateTime: selectedDateTime,
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.alarm_add,
                                        color: Colors.deepPurple.shade700,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        return DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }

    return null; // Seçim yapılmadıysa null döndür
  }

  Widget _buildCategoryButton(String label, IconData icon) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade700,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoriesCard(categories: label),
                )),
            icon: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 20,
              fontWeight: FontWeight.w900),
        )
      ],
    );
  }
}

class Event {
  final String title;
  final String description;
  final DateTime dateTime;
  final TimeOfDay time;
  final String categories;
  final String companyName;

  Event({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.time,
    required this.categories,
    required this.companyName,
  });
}
