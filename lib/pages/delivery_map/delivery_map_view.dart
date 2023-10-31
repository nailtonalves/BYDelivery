import 'dart:async';

import 'package:bydelivery/components/loanding_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';

import 'package:geolocator/geolocator.dart';

class DeliveryMapView extends StatefulWidget {
  const DeliveryMapView({super.key});

  @override
  State<DeliveryMapView> createState() => _DeliveryMapViewState();
}

class _DeliveryMapViewState extends State<DeliveryMapView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _polylineCount = 1;
  final Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  final GoogleMapPolyline _googleMapPolyline =
      GoogleMapPolyline(apiKey: "AIzaSyAOVzmh_jcGAC2-4xmk8KomDKX4WTUb3ko");

  double latitude = -40.816722;
  double longitude = -14.850176;
  late GoogleMapController mapController;
  late StreamSubscription<Position> positionStream;

  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  Marker marker = Marker(
      onTap: () {
        print("Maker 1.");
      },
      markerId: const MarkerId("1"),
      position: const LatLng(-14.846154, -40.825444));

  final markers = <Marker>{};

  final LatLng _center = const LatLng(-14.850176, -40.816722);
  bool _loading = false;

  _setLoadingMenu(bool status) {
    setState(() {
      _loading = status;
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _setLoadingMenu(true);
    mapController = controller;
    watchPosition();
    await getPosition();
    markers.add(marker);
    await _getPolylinesWithLocation();
    mapController
        .moveCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
    _setLoadingMenu(false);
  }

  _getPolylinesWithLocation() async {
    List<LatLng>? coordinates =
        await _googleMapPolyline.getCoordinatesWithLocation(
            origin: LatLng(latitude, longitude),
            destination: marker.position,
            mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(coordinates);
  }

  _addPolyline(List<LatLng>? coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: coordinates!,
        width: 10,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
  }

  watchPosition() async {
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    });
  }

  getPosition() async {
    print("Obtendo a posição atual do dispositivo.");
    try {
      final position = await _currentPosition();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {
      print("Ocorreu um erro ao obiter a posição atual do dispositivo.");
    }
  }

  Future<Position> _currentPosition() async {
    LocationPermission permission;
    bool isActive = await Geolocator.isLocationServiceEnabled();

    if (!isActive) {
      return Future.error("Por favor, habilite a localização do smartphone.");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Você precisa autorizar o acesso à localização.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Autorize o acesso à localização nas configurações.");
    }

    return await Geolocator.getCurrentPosition();
  }

  _goTohome(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Google Maps'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            polylines: Set<Polyline>.of(_polylines.values),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16,
            ),
          ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text("Latitude: $latitude"),
          //     Text(" - Longitude: $longitude"),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext c) {
                        return AlertDialog(
                          title: const Text(
                              "Tem certeza que deseja finalizar a entrega?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Não")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pop(context);
                                },
                                child: const Text("Sim"))
                          ],
                        );
                      });
                },
                child: const Text("Finalizar entrega")),
          ),
          if (_loading) const LoadingScreen()
        ],
      ),
    );
  }
}
