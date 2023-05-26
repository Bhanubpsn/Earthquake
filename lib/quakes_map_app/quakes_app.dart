import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'model/quake.dart';
import 'network/network.dart';

class QuakesApp extends StatefulWidget {
  const QuakesApp({Key? key}) : super(key: key);

  @override
  State<QuakesApp> createState() => _QuakesAppState();
}

class _QuakesAppState extends State<QuakesApp> {
  late Future<Quake> _quakesData;
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _markerList = [];
  double _zoomVal = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quakesData = Network().getAllQuakes();
    // _quakesData.then((values) => {
    //   print("${values.features?[0].geometry!.coordinates?[0]}")
    // }
    // );

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGooglemap(context),
          _zoomMinus(),
          _zoomPlus(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed:(){
            findQuakes();
          } ,
          label: Text("Find Quakes")
      ),
    );
  }

  
  Widget _zoomMinus(){
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: (){
            _zoomVal--;
            _minus(_zoomVal);
          } ,
          icon: const Icon(Icons.zoom_in,color: Colors.black38,),
        ),
      ),
    );
  }

  Widget _zoomPlus(){
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          onPressed: (){
            _zoomVal++;
            _plus(_zoomVal);
          } ,
          icon: const Icon(Icons.zoom_out,color: Colors.black38,),
        ),
      ),
    );
  }

  Widget _buildGooglemap(BuildContext){
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
            mapType: MapType.satellite,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
          initialCameraPosition: const CameraPosition(
              target: LatLng(29.2471839,79.5332419),
              zoom: 3,
          ),
          markers: Set<Marker>.of(_markerList),
        ),
    );
  }

  void findQuakes() {
    setState(() {
      _markerList.clear();
      _handleResponse();
    });
  }


  void _handleResponse(){
    setState(() {
      _quakesData.then((quakes) => {  //quakes is the entire payload.
       quakes.features?.forEach((quake) =>  //quake is the one object in the whole payload.
         _markerList.add(
           Marker(
             markerId: MarkerId(quake.id),
             infoWindow: InfoWindow(title: quake.properties?.mag.toString(), snippet: quake.properties?.title),
             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
             position: LatLng(quake.geometry!.coordinates![1],quake.geometry!.coordinates![0]),
             onTap:() {},
           )
         )
       )
      });
    });
  }

  Future<void> _minus(double zoomVal) async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: const LatLng(29.2471839,79.5332419),zoom: zoomVal)
    ));
  }

  Future<void> _plus(double zoomVal) async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: const LatLng(29.2471839,79.5332419),zoom: zoomVal)
    ));
  }

}


