import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGoogle = const CameraPosition(
      target: LatLng(20.42796133580664 , 80.885749655962),
      zoom: 14.4746
  );

  final List<Marker> _markers = [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 75.885749655962),
        infoWindow: InfoWindow(
          title: 'My First Position',
        ),
    ),
  ];

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
}
  // late GoogleMapController mapController;
  //
  void _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Maps Sample App'),
    backgroundColor: Colors.green[700],
    ),
    body: Container(
      child: SafeArea(
        child: GoogleMap(
        initialCameraPosition: _kGoogle,
          markers: Set<Marker>.of(_markers),
          mapType: MapType.normal,
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
        ),
      ),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserCurrentLocation().then((value) async {
            print(value.latitude.toString() + " "+value.longitude.toString());

            _markers.add(
              Marker(
                markerId: MarkerId("2"),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: InfoWindow(
                  title: 'My Current Location',
                ),
              )
            );

            CameraPosition cameraPosition = new CameraPosition(
                target: LatLng(value.latitude, value.longitude),
                zoom: 14,
            );

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
              });
        },
       child: Icon(Icons.local_activity),
      ),
    );
  }
}
