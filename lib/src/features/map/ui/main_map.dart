import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yrden_trail/src/features/map/ui/fog_of_war.dart';
import 'package:yrden_trail/src/utilites/consts.dart';

class MainMap extends StatefulWidget {
  const MainMap({super.key});

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  MapController mapController = MapController();
  MapOptions mapOptions = const MapOptions(
    initialCenter: LatLng(32.8917297, 13.1756972),
    initialZoom: 9.2,
  );
  List<Marker> markers = []; // Declare a Marker list

  List<Widget> _buildAttributions() {
    return [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.app',
      ),
      RichAttributionWidget(
        attributions: [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () =>
                launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
        ],
      ),
    ];
  }

  List<LatLng> revealedAreas = [];

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Create a new Marker with the current position and add it to the Marker list
    setState(() {
      markers.add(
        Marker(
          width: 30.0,
          height: 30.0,
          point: LatLng(position.latitude, position.longitude),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
      );

      revealedAreas.add(LatLng(position.latitude, position.longitude));
    });

    return position;
  }

  @override
  void initState() {
    _determinePosition().then((value) {
      mapController.move(LatLng(value.latitude, value.longitude), 15);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // backgroundColor: Theme.of(context).colorScheme.primary,
      //   title: Text(
      //     'YrdenTrail',
      //     style: Theme.of(context).textTheme.headlineMedium,
      //   ),
      // ),
      body: SlidingUpPanel(
        padding: Consts.paddingAllSmall,
        color: Consts.canvasColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 48,
            spreadRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
        panel: Column(
          children: [
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      _determinePosition().then((value) {
                        mapController.move(
                            LatLng(value.latitude, value.longitude), 15);
                      });
                    },
                    child: const Text("Get Location")))
          ],
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: mapOptions,
              children: [
                ..._buildAttributions(),
                MarkerLayer(
                    markers:
                        markers), // Add MarkerLayerOptions to the layers property
              ],
            ),
            CustomPaint(
              painter: FogOfWarPainter(revealedAreas),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
