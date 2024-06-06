import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/screen/GoogleMaps/map.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';

class ActivityUpdate extends StatefulWidget {
  ActivityUpdate({
    super.key,
    this.id,
    this.title,
    this.locationInfo,
    this.location,
    this.description,
    this.dateTime,
  });
  String? id;
  String? title;
  String? description;
  String? locationInfo;
  GeoPoint? location;
  DateTime? dateTime;
  @override
  State<ActivityUpdate> createState() => _ActivityUpdateState();
}

class _ActivityUpdateState extends State<ActivityUpdate> {
  AuthService authService = AuthService();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController mapsController = TextEditingController();
  TextEditingController mapsInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title ?? '';
    descriptionController.text = widget.description ?? '';
    dateController.text = widget.dateTime != null
        ? '${widget.dateTime!.day}/${widget.dateTime!.month}/${widget.dateTime!.year}'
        : '';
    timeController.text = widget.dateTime != null
        ? '${widget.dateTime!.hour}:${widget.dateTime!.minute.toString().padLeft(2, '0')}'
        : '';
    mapsInfoController.text = widget.locationInfo ?? '';
    mapsController.text = widget.location != null
        ? '${widget.location!.latitude}, ${widget.location!.longitude}'
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Etkinlik Güncelle',
            style: TextStyle(
                color: Color.fromARGB(230, 19, 10, 113),
                fontWeight: FontWeight.bold,
                fontSize: 25)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Color.fromARGB(230, 19, 10, 113),
                  fontWeight: FontWeight.w900,
                ),
                labelText: "Başlık",
                hintText: '${widget.title}',
              ),
            ),
            TextField(
              controller: mapsInfoController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Color.fromARGB(230, 19, 10, 113),
                  fontWeight: FontWeight.w900,
                ),
                labelText: "Yol Tarifi",
                hintText: '${widget.locationInfo}',
              ),
            ),
            TextField(
              controller: mapsController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Color.fromARGB(230, 19, 10, 113),
                  fontWeight: FontWeight.w900,
                ),
                labelText: "Konum",
                hintText: '${widget.location}',
              ),
              readOnly: true,
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapSample(
                        geo: widget.location,
                        loctitle: widget.locationInfo,
                      ),
                    ));
                setState(() {
                  if (result != null) {
                    if (result["geo"] != null) {
                      GeoPoint selectedLocation = result["latlng"];
                      mapsController.text =
                          '${selectedLocation.latitude}, ${selectedLocation.longitude}';
                      widget.location = selectedLocation;
                    }

                    if (result["locationTitle"] != null) {
                      mapsInfoController.text = result["locationTitle"];
                      widget.locationInfo = result["locationTitle"];
                    }
                    mapsInfoController.text =
                        mapsInfoController.text.toUpperCase();
                  }
                });
              },
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Color.fromARGB(230, 19, 10, 113),
                  fontWeight: FontWeight.w900,
                ),
                labelText: "Açıklama",
                hintText: '${widget.description}',
              ),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Tarih',
                labelStyle: TextStyle(
                  color: Color.fromARGB(230, 19, 10, 113),
                  fontWeight: FontWeight.w900,
                ),
                hintText: widget.dateTime != null
                    ? '${widget.dateTime!.day}/${widget.dateTime!.month}/${widget.dateTime!.year}'
                    : '',
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.dateTime ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.utc(2030, 12, 31),
                );
                if (pickedDate != null) {
                  setState(() {
                    widget.dateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      widget.dateTime?.hour ?? 0,
                      widget.dateTime?.minute ?? 0,
                    );
                    dateController.text =
                        '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                  });
                }
              },
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Color.fromARGB(230, 19, 10, 113),
                    fontWeight: FontWeight.w900,
                  ),
                  labelText: 'Saat',
                  hintText: widget.dateTime != null
                      ? '${widget.dateTime!.hour}:${widget.dateTime!.minute}'
                      : ''),
              readOnly: true,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(widget.dateTime ?? DateTime.now()),
                );
                if (pickedTime != null) {
                  setState(() {
                    widget.dateTime = DateTime(
                      widget.dateTime?.year ?? DateTime.now().year,
                      widget.dateTime?.month ?? DateTime.now().month,
                      widget.dateTime?.day ?? DateTime.now().day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    timeController.text =
                        '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
                  });
                }
              },
            ),
            SizedBox(height: 20),
            Container(
              height: 60,
              width: 150,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 212, 184, 254),
                ),
                onPressed: () async {
                  DateTime finalDateTime = widget.dateTime ?? DateTime.now();
                  await authService.etkinlikGuncelle(
                    widget.id!,
                    titleController.text.isNotEmpty
                        ? titleController.text
                        : widget.title!,
                    descriptionController.text.isNotEmpty
                        ? descriptionController.text
                        : widget.description!,
                    finalDateTime,
                    widget.location!,
                    mapsInfoController.text.isNotEmpty
                        ? mapsInfoController.text
                        : widget.locationInfo!,
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  "Güncelle",
                  style: TextStyle(
                      color: Color.fromARGB(230, 19, 10, 113),
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
