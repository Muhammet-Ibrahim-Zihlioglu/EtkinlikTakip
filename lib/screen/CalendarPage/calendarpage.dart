import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/provider.dart';
import 'package:etkinlik_takip_projesi/screen/ActicityList/activityAdd.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarScreen> {
  LatLng? latLng;
  String? locationTitle;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  AuthService authService = AuthService();
  List<Event> _events = [];

  void _populateEventsFromFirestore() async {
    String companyName = Provider.of<UserProvider>(context).adminCompanyName;
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
          );
        }).toList();
      });
    });
  }

  Stream? etkinlikStream;
  Timestamp? timestamp;
  getontheload() async {
    String companyName = Provider.of<UserProvider>(context).adminCompanyName;
    etkinlikStream = await AuthService().tumEtkinlikler(companyName);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getontheload();
    _populateEventsFromFirestore();
  }

  TimeOfDay? _selectedTime;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    String companyName = Provider.of<UserProvider>(context).adminCompanyName;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: Column(
          children: [
            Text('${companyName} Etkinlik Takvimi',
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
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white, // Arka plan rengini beyaz yapıyoruz
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade200,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TableCalendar(
                calendarStyle: CalendarStyle(
                  outsideTextStyle: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.black),
                  defaultTextStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black), // Günlerin yazı rengi
                  weekendTextStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black), // Haftasonu günlerinin yazı rengi
                  selectedTextStyle:
                      TextStyle(color: Colors.white), // Seçili günün yazı rengi
                  todayTextStyle:
                      TextStyle(color: Colors.white), // Bugünün yazı rengi
                  todayDecoration: BoxDecoration(
                    color: Colors.deepPurple, // Bugünün arka plan rengi
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
                      color: Colors.black), // Başlık yazısının rengi
                  formatButtonTextStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white), // Format butonu yazısının rengi
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                  titleCentered: true,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black), // Haftanın günlerinin yazı rengi
                  weekendStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black), // Haftasonu günlerinin yazı rengi
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
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarFormat: _calendarFormat,
                // Seçili günü yuvarlak içerisinde gösteriyor.
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
                Text("Etkinlik Listesi",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline)),
                SizedBox(width: 15),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityAdd(
                                selectedDate: _selectedDay,
                              ),
                            ));
                      });
                    },
                    iconSize: 35,
                    icon: const Icon(
                      Icons.add_box_rounded,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: etkinlikStream,
                builder: ((context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Text("");
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        Timestamp timestamp = ds["date"];
                        DateTime dateTime = timestamp.toDate();
                        if (isSameDay(dateTime, _focusedDay)) {
                          return Card(
                            margin: EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            color: Colors.grey[200],
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
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        ' ${dateTime.hour}:${dateTime.minute}',
                                        style: const TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
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
                      });
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
      String locationInfo) {
    DateTime event = timestamp.toDate();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.deepPurple,
              fontSize: 30,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Konum Başlığı',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.deepPurpleAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
              Text(
                '$locationInfo',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text(
                'Lokasyon Bilgileri',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.deepPurpleAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
              Text(
                'Enlem: ${geoPoint.latitude}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                'Boylam: ${geoPoint.longitude}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                'Açıklama',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.deepPurpleAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
              Text(
                '$description',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const Text(
                'Tarih: ',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.deepPurpleAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '${event.day}/${event.month}/${event.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const Text(
                'Saat: ',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.deepPurpleAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
              Text(
                '${event.hour}:${event.minute}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Tamam',
                style: TextStyle(color: Colors.black),
              ),
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
