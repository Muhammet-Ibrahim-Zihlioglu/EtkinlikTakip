import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/screen/GoogleMaps/map.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';

class ActivityAdd extends StatefulWidget {
  ActivityAdd({super.key, this.selectedDate});
  DateTime? selectedDate;

  @override
  State<ActivityAdd> createState() => _ActivityAddState();
}

class _ActivityAddState extends State<ActivityAdd> {
  AuthService authService = AuthService();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _selectedMaps = TextEditingController();
  TextEditingController _selectedMapsInfo = TextEditingController();

  GeoPoint? latLng;
  String? locationTitle;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.selectedDate ?? DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text("Etkinlik Ekleme Sayfası",
            style: TextStyle(
                color: Color.fromARGB(230, 19, 10, 113),
                fontWeight: FontWeight.bold,
                fontSize: 25)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '* Başlık',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
              ),
              TextField(
                enabled: false,
                controller: _selectedMaps,
                decoration: InputDecoration(
                  labelText: latLng != null
                      ? "Konum Eklendi"
                      : "* Lütfen Konum Giriniz",
                ),
              ),
              if (latLng != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Enlem: ${latLng!.latitude}",
                      style: TextStyle(fontSize: 13),
                    ),
                    Text("Boylam: ${latLng!.longitude}",
                        style: TextStyle(fontSize: 13))
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapSample(),
                          ));
                      setState(() {
                        if (result != null) {
                          latLng = result["latlng"];
                          locationTitle = result["locationTitle"];
                        }
                        if (latLng != null || locationTitle != null) {
                          if (locationTitle != null) {
                            _selectedMapsInfo.text = locationTitle!;
                            _selectedMapsInfo.text =
                                _selectedMapsInfo.text.toUpperCase();
                          }
                        }
                      });
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Color.fromARGB(230, 19, 10, 113),
                        ),
                        Text("Konum Ekleme",
                            style: TextStyle(
                                color: Color.fromARGB(230, 19, 10, 113),
                                decoration: TextDecoration.underline)),
                      ],
                    ),
                  )
                ],
              ),
              TextField(
                enabled: false,
                controller: _selectedMapsInfo,
                decoration: InputDecoration(
                  labelText: "Adres Başlığı",
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: widget.selectedDate != null
                      ? "${dateTime.day}/${dateTime.month}/${dateTime.year}"
                      : '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: widget.selectedDate != null
                      ? '${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}'
                      : '',
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.utc(2030, 12, 31),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      widget.selectedDate = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        widget.selectedDate?.hour ?? 0,
                        widget.selectedDate?.minute ?? 0,
                      );
                      _dateController.text =
                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                    });
                  }
                },
              ),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                    labelText: "Saat",
                    hintText: "${dateTime.hour}:${dateTime.minute}"),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      widget.selectedDate = DateTime(
                        widget.selectedDate?.year ?? DateTime.now().year,
                        widget.selectedDate?.month ?? DateTime.now().month,
                        widget.selectedDate?.day ?? DateTime.now().day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      _timeController.text =
                          '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
                    });
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  if (_titleController.text.isNotEmpty &&
                      latLng != null &&
                      _timeController.text.isNotEmpty) {
                    setState(() {
                      DateTime? dateTime;
                      if (widget.selectedDate != null) {
                        dateTime = DateTime(
                            widget.selectedDate!.year,
                            widget.selectedDate!.month,
                            widget.selectedDate!.day,
                            widget.selectedDate!.hour,
                            widget.selectedDate!.minute);
                      }
                      authService.etkinlikEkle(
                          _titleController.text,
                          _descriptionController.text,
                          dateTime ?? DateTime.now(),
                          latLng!,
                          _selectedMapsInfo.text);

                      _titleController.clear();
                      _descriptionController.clear();
                      widget.selectedDate = null;
                      _timeController.clear();
                      _dateController.clear();
                      Navigator.pop(context);
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                            "Doldurulması Zorunlu Alanlar Boş Bırakılamaz"),
                        content: Text(
                            "Lütfen * ile gösterilen alanları boş bırakmayınız."),
                      ),
                    );
                  }
                },
                child: Container(
                    width: 150,
                    height: 50,
                    color: Colors.grey.shade300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Etkinliği Ekle',
                            style: TextStyle(
                                color: Color.fromARGB(230, 19, 10, 113),
                                fontSize: 18,
                                fontWeight: FontWeight.w900)),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
