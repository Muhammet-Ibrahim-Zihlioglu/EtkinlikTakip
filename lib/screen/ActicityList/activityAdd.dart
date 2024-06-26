import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_takip_projesi/component/provider.dart';
import 'package:etkinlik_takip_projesi/screen/GoogleMaps/map.dart';
import 'package:etkinlik_takip_projesi/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  TextEditingController _categories = TextEditingController();

  List<String> categories = [
    "Gezi",
    "Toplantı",
    "Eğitim",
    "Sosyal",
    "Kültürel"
  ];

  GeoPoint? latLng;
  String? locationTitle;

  @override
  Widget build(BuildContext context) {
    String companyName = Provider.of<UserProvider>(context).adminCompanyName;

    DateTime dateTime = widget.selectedDate ?? DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Etkinlik Ekleme Sayfası",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "$companyName",
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '* Başlık',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: '* Açıklama',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _categories.text.isNotEmpty ? _categories.text : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: "* Lütfen Bir Kategori Seçiniz",
                  hintStyle: TextStyle(
                    color: Colors.deepPurple.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.deepPurple.withOpacity(0.7)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.deepPurple,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _categories.text = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                enabled: false,
                controller: _selectedMaps,
                decoration: InputDecoration(
                  labelText: latLng != null
                      ? "Konum Eklendi"
                      : "* Lütfen Konum Giriniz",
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              if (latLng != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Enlem: ${latLng!.latitude}",
                      style: TextStyle(fontSize: 13, color: Colors.deepPurple),
                    ),
                    Text(
                      "Boylam: ${latLng!.longitude}",
                      style: TextStyle(fontSize: 13, color: Colors.deepPurple),
                    )
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
                          color: Colors.deepPurple,
                        ),
                        Text("Konum Ekleme",
                            style: TextStyle(
                                color: Colors.deepPurple,
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
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: widget.selectedDate != null
                      ? "${dateTime.day}/${dateTime.month}/${dateTime.year}"
                      : '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
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
              SizedBox(height: 10),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                    labelText: "Saat",
                    hintText: "${dateTime.hour}:${dateTime.minute}",
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200),
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
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _descriptionController.text.isNotEmpty &&
                        _categories.text.isNotEmpty &&
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
                            companyName,
                            _titleController.text,
                            _descriptionController.text,
                            _categories.text,
                            companyName,
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
                            "Doldurulması Zorunlu Alanlar Boş Bırakılamaz",
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          content: Text(
                            "Lütfen * ile gösterilen alanları boş bırakmayınız.",
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Tamam'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    'Etkinliği Ekle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
