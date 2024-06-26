import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsNavigation extends StatefulWidget {
  MapsNavigation({super.key, this.geoPointLast});
  GeoPoint? geoPointLast;

  @override
  State<MapsNavigation> createState() => MapNavigationState();
}

class MapNavigationState extends State<MapsNavigation> {
  @override
  void initState() {
    super.initState();
    addMarker();
  }

  Marker? destinationPosition;

  addMarker() {
    setState(() {
      if (widget.geoPointLast != null) {
        destinationPosition = Marker(
          markerId: MarkerId('destination'),
          position: LatLng(
              widget.geoPointLast!.latitude, widget.geoPointLast!.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        );
      }
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition get _kInitialPosition {
    if (widget.geoPointLast != null) {
      return CameraPosition(
        target: LatLng(
            widget.geoPointLast!.latitude, widget.geoPointLast!.longitude),
        zoom: 14,
      );
    } else {
      // Fallback to a default location if widget.geoPointLast is null
      return CameraPosition(
        target: LatLng(39.9334, 32.8597),
        zoom: 10,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text("Google Haritalar",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 25)),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 150,
              color: Colors.deepPurple.shade200,
              child: GestureDetector(
                onTap: () async {
                  if (widget.geoPointLast != null) {
                    await launchUrl(Uri.parse(
                        'google.navigation:q=${widget.geoPointLast!.latitude},${widget.geoPointLast!.longitude}&key=YOUR_API_KEY'));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions, color: Colors.black),
                    Text("Yol Tarifi",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kInitialPosition,
          markers: destinationPosition != null ? {destinationPosition!} : {},
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ]),
    );
  }
}
