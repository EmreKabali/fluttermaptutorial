import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:fluttermaptutorial/FakeData.dart';
import 'package:latlong2/latlong.dart' as LatLng;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //set markers function
  List<Marker> setMarkers() {
    return List<Marker>.from(FakeData.getLocations.map((e) => new Marker(
        width: 60,
        height: 60,
        point: new LatLng.LatLng(e.latitude, e.longitude),
        builder: (context) => new Icon(Icons.pin_drop))));
  }

//mapcontroller field to focus map
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Flutter Map Tutorial - Kabalidev'),
      ),
      body: SafeArea(
          child: Container(
        child: Stack(children: [
          Positioned(
            child: FlutterMap(
              //we have to add mapcontroller to flutter map
              mapController: _mapController,
              options: MapOptions(
                  center: LatLng.LatLng(FakeData.getLocations[0].latitude,
                      FakeData.getLocations[0].longitude),
                  zoom: 13.0,
                  plugins: [LocationMarkerPlugin(), MarkerClusterPlugin()]),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: setMarkers(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Container(
              height: 150,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: FakeData.getLocations.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                        //When i click cardi i should focus city lang long

                        onTap: () {
                          //focus event
                          // we can focus new city with mapcontroller move method
                          var response = _mapController.move(
                              LatLng.LatLng(
                                  FakeData.getLocations[index].latitude,
                                  FakeData.getLocations[index].longitude),
                              13);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width / 1.7,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  FakeData.getLocations[index].name,
                                  style: TextStyle(fontSize: 25),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(FakeData.getLocations[index].description)
                              ],
                            ),
                          ),
                        ),
                      )),
            ),
          )
        ]),
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
