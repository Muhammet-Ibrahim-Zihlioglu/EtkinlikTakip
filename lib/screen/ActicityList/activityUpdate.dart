import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/provider.dart';
import 'package:etkinlik_takip_projesi/screen/GoogleMaps/map.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityUpdate extends StatefulWidget {
  ActivityUpdate({
    Key? key,
    this.id,
    this.title,
    this.locationInfo,
    this.location,
    this.description,
    this.categories,
    this.dateTime,
  }) : super(key: key);

  String? id;
  String? title;
  String? categories;
  String? description;
  String? locationInfo;
  GeoPoint? location;
  DateTime? dateTime;

  @override
  State<ActivityUpdate> createState() => _ActivityUpdateState();
}

class _ActivityUpdateState extends State<ActivityUpdate> {
  final AuthService _authService = AuthService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _mapsController = TextEditingController();
  final TextEditingController _mapsInfoController = TextEditingController();

  List<String> categories = [
    "Gezi",
    "Toplantı",
    "Eğitim",
    "Sosyal",
    "Kültürel"
  ];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title ?? '';
    _descriptionController.text = widget.description ?? '';
    _dateController.text = widget.dateTime != null
        ? '${widget.dateTime!.day}/${widget.dateTime!.month}/${widget.dateTime!.year}'
        : '';
    _timeController.text = widget.dateTime != null
        ? '${widget.dateTime!.hour}:${widget.dateTime!.minute.toString().padLeft(2, '0')}'
        : '';
    _mapsInfoController.text = widget.locationInfo ?? '';
    _mapsController.text = widget.location != null
        ? '${widget.location!.latitude}, ${widget.location!.longitude}'
        : '';
  }

  @override
  Widget build(BuildContext context) {
    String companyName = Provider.of<UserProvider>(context).adminCompanyName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Etkinlik Güncelle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Text(
              'Şirket: $companyName',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Başlık",
                labelStyle: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
                labelText: "Açıklama",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: DropdownButtonFormField<String>(
                value: widget.categories,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      color: Colors.deepPurple, fontWeight: FontWeight.w900),
                  labelText: "Kategori",
                  border: InputBorder.none,
                ),
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    widget.categories = newValue!;
                  });
                },
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _mapsController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
                labelText: "Konum",
                border: OutlineInputBorder(),
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
                  ),
                );
                setState(() {
                  if (result != null) {
                    if (result["latlng"] != null) {
                      GeoPoint selectedLocation = result["latlng"];
                      _mapsController.text =
                          '${selectedLocation.latitude}, ${selectedLocation.longitude}';
                      widget.location = selectedLocation;
                    }

                    if (result["locationTitle"] != null) {
                      _mapsInfoController.text = result["locationTitle"];
                      widget.locationInfo = result["locationTitle"];
                    }
                    _mapsInfoController.text =
                        _mapsInfoController.text.toUpperCase();
                  }
                });
              },
            ),
            SizedBox(height: 12),
            TextField(
              controller: _mapsInfoController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
                labelText: "Yol Tarifi",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
                labelText: "Tarih",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                DateTime initialDate = widget.dateTime ?? DateTime.now();
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
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
                    _dateController.text =
                        '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                  });
                }
              },
            ),
            SizedBox(height: 12),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
                labelText: "Saat",
                border: OutlineInputBorder(),
              ),
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
                    _timeController.text =
                        '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
                  });
                }
              },
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                DateTime finalDateTime = widget.dateTime ?? DateTime.now();
                await _authService.etkinlikGuncelle(
                  companyName,
                  widget.id!,
                  _titleController.text,
                  _descriptionController.text,
                  widget.categories!,
                  companyName,
                  finalDateTime,
                  widget.location!,
                  _mapsInfoController.text,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Güncelle",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
