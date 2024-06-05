import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthcare/screen/main_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyGoogleMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  MyGoogleMap({required this.latitude, required this.longitude});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyGoogleMap> {
  int _selectedIndex = 1;

  String _address = '';
  late GoogleMapController mapController;

  late LatLng _center;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _center = LatLng(widget.latitude, widget.longitude);
    _getPlaceAddress();
  }

  Future<void> _getPlaceAddress() async {
    final address = await getPlaceAddress(lat: _center.latitude, lng: _center.longitude);
    setState(() {
      _address = address;
      _updateMarkerAndShowInfoWindow(); // 마커 업데이트 함수 호출
    });
  }

  Future<String> getPlaceAddress({double lat = 0.0, double lng = 0.0}) async {
    const String GOOGLE_API_KEY = "";
    final String geoAPI = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY&language=ko'; // 역지오코딩 api 주소
    final http.Response response = await http.get(Uri.parse(geoAPI));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['results'].isNotEmpty) {
        String address = result['results'][0]['formatted_address'];
        address = address.replaceAll("대한민국 ", "");
        return address;
      }
    }
    return '주소를 찾을 수 없음';
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _updateMarkerAndShowInfoWindow();
  }

  void _updateMarkerAndShowInfoWindow() {
    final markerId = MarkerId('_centerMarker');
    _markers.clear(); // 기존 마커를 제거
    _markers.add(
      Marker(
          markerId: markerId,
          position: _center,
          infoWindow: InfoWindow(
            title: _address, // 업데이트된 주소를 사용
            snippet: '위급상황이 발생했습니다.',
          ),
          onTap: () {
            mapController.showMarkerInfoWindow(markerId);
          }
      ),
    );

    // 정보 창을 자동으로 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mapController != null) {
        mapController.showMarkerInfoWindow(markerId);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('보행보조차 현재위치'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 17,
                  ),
                  markers: _markers,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: SelectableText(
                _address,
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
                label: 'home'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_pin),
                label: '위치정보'
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
              if (_selectedIndex == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HealthInfoPage()),
                );
              }
            });
          },
        ),
      ),
    );
  }
}
