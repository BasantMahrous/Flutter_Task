import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double currentSpeedInMps = 0.0;
  double currentSpeedInKph = 0.0;
  int timeInSecondFrom10To30 = 0;
  int timeInSecondFrom30To10 = 0;
  DateTime currentTimeStamp;
  int initialSpeed = 0;
  int lastSpeed = 0;

  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  @override
  void initState() {
    super.initState();
    getVehicleSpeed();
  }

  Future<void> getVehicleSpeed() async {
    try {
      geolocator.getPositionStream((locationOptions)).listen((position) async {
        currentSpeedInMps = position.speed;

        setState(() {
          currentSpeedInKph = currentSpeedInMps / 3.6;
        });

        print(currentSpeedInKph.round());
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getVehicleTimeStampFrom30To10() async {
    try {
      geolocator.getPositionStream((locationOptions)).listen((position) async {
        int countInitialSpeed = 0;
        int countLastSpeed = 0;
        DateTime firstTimeStamp;
        DateTime lastTimeStamp;
        if (currentSpeedInKph == 30 && countInitialSpeed == 0) {
          firstTimeStamp = position.timestamp;
          countInitialSpeed++;
        } else if (currentSpeedInKph == 10 && countLastSpeed == 0 && countInitialSpeed==1) {
          lastTimeStamp = position.timestamp;
          countLastSpeed++;
        }
        setState(() {
          if(firstTimeStamp!=null && lastTimeStamp!=null)
            {
              timeInSecondFrom30To10 = lastTimeStamp.difference(firstTimeStamp).inSeconds ;
              countInitialSpeed=0;
              countLastSpeed=0;
            }

        });
        print(currentSpeedInKph.round());
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getVehicleTimeStampFrom10To30() async {
    try {
      geolocator.getPositionStream((locationOptions)).listen((position) async {
        int countInitialSpeed = 0;
        int countLastSpeed = 0;
        DateTime firstTimeStamp;
        DateTime lastTimeStamp;
        if (currentSpeedInKph == 10 && countInitialSpeed == 0) {
          firstTimeStamp = position.timestamp;
          countInitialSpeed++;
        } else if (currentSpeedInKph == 30 && countLastSpeed == 0 && countInitialSpeed==1) {
          lastTimeStamp = position.timestamp;
          countLastSpeed++;
        }
        setState(() {
          if(firstTimeStamp!=null && lastTimeStamp!=null)
          {
            timeInSecondFrom10To30 = lastTimeStamp.difference(firstTimeStamp).inSeconds ;
            countInitialSpeed=0;
            countLastSpeed=0;
          }

        });
        print(currentSpeedInKph.round());
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('speedoMeter App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Text(
                  'Current Speed',
                  style: TextStyle(fontSize: 20.0),
                )),
            FlatButton(
              onPressed: getVehicleSpeed,
              child: Text(
                currentSpeedInKph.toString(),
                style: TextStyle(fontSize: 30.0),
              ),
              textColor: Colors.green,
            ),
            Text(
              'Km/h',
              style: TextStyle(fontSize: 20.0),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(20, 60, 0, 0),
                child: Text(
                  'From 10 to 30',
                  style: TextStyle(fontSize: 20.0),
                )),
            FlatButton(
              onPressed: getVehicleTimeStampFrom10To30,
              child: Text(
                timeInSecondFrom10To30.toString(),
                style: TextStyle(fontSize: 30.0),
              ),
              textColor: Colors.green,
            ),
            Text(
              'Seconds',
              style: TextStyle(fontSize: 20.0),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(20, 40, 0, 0),
                child: Text(
                  'From 10 to 30',
                  style: TextStyle(fontSize: 20.0),
                )),
            FlatButton(
              onPressed: getVehicleTimeStampFrom30To10,
              child: Text(
                timeInSecondFrom30To10.toString(),
                style: TextStyle(fontSize: 30.0),
              ),
              textColor: Colors.green,
            ),
            Text(
              'Seconds',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    ));
  }
}
