import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapSample extends StatefulWidget {
  MapSample({super.key, this.geo, this.loctitle});
  GeoPoint? geo;
  String? loctitle;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(39.9334, 32.8597),
    zoom: 10,
  );

  TextEditingController _searchController = TextEditingController();
  TextEditingController _enlem =
      TextEditingController(); // Burada _enlem tanımlandı.
  TextEditingController _boylam = TextEditingController();
  Set<Marker> _markers = {};
  GeoPoint? _searchedLatLng;
  String? locationTitle;
  @override
  void initState() {
    if (widget.geo != null) {
      _kInitialPosition = CameraPosition(
        target: LatLng(widget.geo!.latitude, widget.geo!.longitude),
        zoom: 14, // Adjust zoom level as necessary
      );

      // Add initial marker
      _markers.add(Marker(
        markerId: MarkerId("initial_marker"),
        position: LatLng(widget.geo!.latitude, widget.geo!.longitude),
        infoWindow: InfoWindow(
          title: widget.loctitle ?? "Selected Location",
        ),
      ));
    } else {
      _kInitialPosition = const CameraPosition(
        target: LatLng(39.9334, 32.8597), // Default position (Ankara, Turkey)
        zoom: 10,
      );
    }

    _searchController;
    _enlem;
    _boylam;
    _markers;
    locationTitle;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Google Haritalar',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 25)),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.deepPurple,
              height: 50,
              child: TextButton(
                  onPressed: () => Navigator.pop(context, {
                        "latlng": _searchedLatLng,
                        "locationTitle": locationTitle
                      }),
                  child: Text(
                    "Konumu Kaydet",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20),
                  )),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kInitialPosition,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 20, left: 30),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Lütfen Bir Konum Giriniz',
                  hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w900),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 15),
                  suffixIcon: IconButton(
                    color: Color.fromARGB(230, 19, 10, 113),
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _searchAndNavigate();
                      _enlem.text = "";
                      _boylam.text = "";
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 75,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 220,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _enlem, // _enlem burada kullanılmalı.
                        decoration: InputDecoration(
                          hintText: _searchedLatLng != null
                              ? 'Enlem: ${_searchedLatLng?.latitude}'
                              : 'Konuma Ait Enlem Bilgisi',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w900),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 220,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _boylam,
                        decoration: InputDecoration(
                          hintText: _searchedLatLng != null
                              ? 'Boylam: ${_searchedLatLng?.longitude}'
                              : ' Konuma Ait Boylam Bilgisi',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w900),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 40,
                      width: 100,
                      color: Colors.purple.shade50,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    title: Text(
                                      'Enlem Ve Boylam Bilgisi Girerek Nasıl Konum Bulunır?',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    content: Expanded(
                                        child: Text(
                                      "Arama kısmında yazdığınız bilgilere ait bilgi bulunamadığında buradan enlem ve boylam bilgilerini girerek konumu ekrana getirebilirsiniz. İstediğiniz konumun enlem boylam bilgilerine erişmek için google haritaların mobil uygulamasına yada web sitesinden girerek bulmak istediğiniz konumu yazıyorsunuz. Daha sonra gelen ekranda kırmızı oklu konum öğesine basılı tutunca karşınıza iki adet ondalıklı sayı çkıyor. Bunlardan birincisi konumun enlemini,ikincisi ise konumun boylamını veriyor. Bu bilgileri girerek etkinlik takip uygulamamız üzerinden etkinliğinize ait konumu etkinliğinize ekleyebiliyorsunuz.",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.info,
                              color: Colors.deepPurple,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                _markersUpdate(double.parse(_enlem.text),
                                    double.parse(_boylam.text));
                                _searchController.text = "";
                              },
                              icon: const Icon(
                                Icons.search,
                                color: Colors.deepPurple,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markersUpdate(double latitude, double longitude) async {
    try {
      final GoogleMapController controller = await _controller.future;
      CameraPosition newPosition = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14,
      );
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(newPosition));

      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId("Adres"),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: "Arama Adresi",
            ),
          ),
        );
        _searchedLatLng = GeoPoint(latitude, longitude);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Girdiğiniz bilgilere ait konum bulunamadı.')),
      );
    }
  }

  Future<void> _searchAndNavigate() async {
    String searchAddress = _searchController.text;
    String key = "AIzaSyAwIASegAbabeyMJfkTRwXpdMyPxULHlCs";
    try {
      var url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$searchAddress&key=$key';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          var location = data['results'][0]['geometry']['location'];
          double latitude = location['lat'];
          double longitude = location['lng'];
          final GoogleMapController controller = await _controller.future;
          CameraPosition newPosition = CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 14,
          );
          controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));

          setState(() {
            _markers.clear();
            _markers.add(
              Marker(
                markerId: MarkerId(searchAddress),
                position: LatLng(latitude, longitude),
                infoWindow: InfoWindow(
                  title: searchAddress,
                ),
              ),
            );
            _searchedLatLng = GeoPoint(latitude, longitude);
            locationTitle = searchAddress;
          });
        } else {
          throw Exception(
              'Geocoding request failed with status: ${data['status']}');
        }
      } else {
        throw Exception(
            'HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Aradığınız konuma ait bilgiler bulunamadı. Enlem boylam bilgilerini girerek lütfen tekrar deneyiniz.')),
      );
    }
  }
}
