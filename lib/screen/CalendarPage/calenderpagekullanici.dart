import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/screen/GoogleMaps/mapNavigation.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:etkinlik_takip_projesi/service/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreenKullanici extends StatefulWidget {
  const CalendarScreenKullanici({
    super.key,
  });
  @override
  _CalendarPageKullaniciState createState() => _CalendarPageKullaniciState();
}

class _CalendarPageKullaniciState extends State<CalendarScreenKullanici> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  AuthService authService = AuthService();
  List<Event> _events = [];
  void _EventLoader() async {
    Stream<QuerySnapshot> eventStream = await AuthService().tumEtkinlikler();

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
          );
        }).toList();
      });
    });
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? userEmail;
  String? userNumber;
  String? userName;
  bool katildiMi = false;

  void getUserActivity(String title, String description, Timestamp timestamp,
      GeoPoint geoPoint, String locationTitle) async {
    User? user = auth.currentUser;

    QuerySnapshot querySnapshot = await firestore
        .collection("isyeriegitimi")
        .doc(user?.uid)
        .collection("KatildigimEtkinlikler")
        .where(
          "title",
          isEqualTo: title,
        )
        .where("description", isEqualTo: description)
        .where("date", isEqualTo: timestamp)
        .where("konum", isEqualTo: geoPoint)
        .where("konumBaslik", isEqualTo: locationTitle)
        .get();
    if (this.mounted) {
      setState(() {
        if (querySnapshot.docs.isNotEmpty) {
          katildiMi = true;
        } else {
          katildiMi = false;
        }
      });
    }
  }

  void _getUsers() async {
    User? user = auth.currentUser;
    String? email = user?.email;

    QuerySnapshot querySnapshot = await firestore
        .collection("isyeriegitimi")
        .where("email", isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;

      setState(() {
        userEmail = doc["email"];
        userNumber = doc["number"];
        userName = doc["username"];
      });
    }
  }

  Stream? etkinlikStream;
  Timestamp? timestamp;
  getontheload() async {
    etkinlikStream = await AuthService().tumEtkinlikler();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    _getUsers();
    _EventLoader();
    super.initState();
  }

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  @override
  void setState(VoidCallback fn) {
    _selectedDate;
    katildiMi;
    // TODO: implement setState
    super.setState(fn);
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot? documentSnapshot;
    User? user = auth.currentUser;
    String? id = user?.uid ?? "";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            const Text('Etkinlik Takvimi',
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/takvim.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(
                  0.8), // Saydamlık oranını buradan ayarlayabilirsiniz
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          children: [
            if (userName != null)
              Container(
                color: Color.fromARGB(230, 19, 10, 113).withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "$userName",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                  color: Color.fromARGB(230, 19, 10, 113).withOpacity(0.4)),
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
                    color: Color.fromARGB(
                        230, 19, 10, 113), // Bugünün arka plan rengi
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.purple, // Seçili günün arka plan rengi
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
                    color: Color.fromARGB(230, 19, 10, 113),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Etkinlik Listesi",
                    style: TextStyle(
                        color: Color.fromARGB(230, 19, 10, 113),
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline)),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: etkinlikStream,
                builder: ((context, AsyncSnapshot snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];
                            Timestamp timestamp = ds["date"];
                            DateTime dateTime = timestamp.toDate();
                            if (isSameDay(dateTime, _focusedDay!)) {
                              getUserActivity(
                                  ds["title"],
                                  ds["description"],
                                  timestamp,
                                  ds["konum"],
                                  ds["konumBaslik"]); // Kullanıcının etkinliğe katılıp katılmadığını kontrol et
                              // katildiMi bayrağını güncelle

                              return Card(
                                margin: EdgeInsets.only(
                                    left: 15, right: 15, top: 5, bottom: 5),
                                color: Color.fromARGB(255, 168, 200, 255),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        // Wrap the Text widget with Expanded
                                        child: Text(
                                          ds["title"],
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  230, 19, 10, 113),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      katildiMi
                                          ? const Text(
                                              "Katıldınız",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      230, 19, 10, 113),
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w900,
                                                  fontStyle: FontStyle.italic),
                                            )
                                          : IconButton(
                                              iconSize: 35,
                                              onPressed: () {
                                                if (userEmail != null &&
                                                    userNumber != null &&
                                                    userName != null) {
                                                  authService
                                                      .etkinligeKatilanKullanici(
                                                          id,
                                                          ds.id,
                                                          userEmail!,
                                                          userName!,
                                                          userNumber!);
                                                  authService.etkinlikKatil(
                                                      ds.id,
                                                      ds["title"],
                                                      ds["description"],
                                                      dateTime,
                                                      ds["konum"],
                                                      ds["konumBaslik"]);
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          "Ekleme İşleminiz Tamamlanamadı!! Lütfen Takvimin Üzerinde Kullanıcı İsminiz Görünene Kadar Bekleyiniz",
                                                          style: TextStyle(
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Tamam'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.check_box,
                                                color: Color.fromARGB(
                                                    230, 19, 10, 113),
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
                                                color: Color.fromARGB(
                                                    230, 19, 10, 113),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Text(
                                            ' ${dateTime.hour}:${dateTime.minute}',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    230, 19, 10, 113),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MapsNavigation(
                                                            geoPointLast:
                                                                ds["konum"]),
                                                  ));
                                            },
                                            child: Text("Konuma Git",
                                                style: TextStyle(
                                                    color:
                                                        Colors.purple.shade700,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 20,
                                                    decoration: TextDecoration
                                                        .underline)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.purple.shade700),
                                            onPressed: () {
                                              DateTime scheduledTime =
                                                  DateTime.now().add(
                                                      Duration(seconds: 5));
                                              NotificationService
                                                  .scheduleAlarmNotification(
                                                title: ds["title"],
                                                body: '${ds["description"]}',
                                                dateTime: scheduledTime,
                                              );
                                            },
                                            child: Text(
                                              'Alarm Test',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color.fromARGB(
                                                      230, 19, 10, 113)),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.purple.shade700),
                                            onPressed: () async {
                                              DateTime? selectedDateTime =
                                                  await _selectDateTime(
                                                      context);
                                              if (selectedDateTime != null) {
                                                NotificationService
                                                    .scheduleAlarmNotification(
                                                  title: ds["title"],
                                                  body: '${ds["description"]}',
                                                  dateTime: selectedDateTime,
                                                );
                                              }
                                            },
                                            child: Text(
                                              'Alarm Kur',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color.fromARGB(
                                                      230, 19, 10, 113)),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    _showEventDetailsDialog(
                                        context,
                                        ds["title"],
                                        ds["description"],
                                        ds["date"],
                                        ds["konum"],
                                        ds["konumBaslik"]);
                                  },
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          })
                      : const Text("Lütfen Etkinlik Ekleyiniz.");
                }),
              ),
            ),
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

  void _showEventDetailsDialog(
    BuildContext context,
    String title,
    String description,
    Timestamp timestamp,
    GeoPoint geoPoint,
    String locationTitle,
  ) {
    DateTime dateTime = timestamp.toDate();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 211, 207, 255),
          title: Text(
            title,
            style: const TextStyle(
                color: Color.fromARGB(230, 19, 10, 113),
                fontSize: 25,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          locationTitle,
                          style: const TextStyle(
                            color: Color.fromARGB(230, 19, 10, 113),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Enlem: ",
                              style: const TextStyle(
                                color: Color.fromARGB(230, 19, 10, 113),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "${geoPoint.latitude}",
                              style: const TextStyle(
                                color: Color.fromARGB(230, 19, 10, 113),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "Boylam: ",
                              style: const TextStyle(
                                color: Color.fromARGB(230, 19, 10, 113),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "${geoPoint.longitude} ",
                              style: const TextStyle(
                                color: Color.fromARGB(230, 19, 10, 113),
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
                          description,
                          style: const TextStyle(
                            color: Color.fromARGB(230, 19, 10, 113),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Tarih: ",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.purple.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                              style: const TextStyle(
                                color: Color.fromARGB(230, 19, 10, 113),
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
                                decoration: TextDecoration.underline,
                                color: Colors.purple.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "${dateTime.hour}:${dateTime.minute}",
                              style: const TextStyle(
                                color: Color.fromARGB(230, 19, 10, 113),
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
                ],
              ),
            ],
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
}

class Event {
  final String title;
  final String description;
  final DateTime dateTime;
  final TimeOfDay time;

  Event({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.time,
  });
}
