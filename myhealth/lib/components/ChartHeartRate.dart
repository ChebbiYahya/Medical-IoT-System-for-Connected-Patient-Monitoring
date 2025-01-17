import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';

class ChartHeatRate extends StatefulWidget {
  @override
  State<ChartHeatRate> createState() => _ChartHeatRateState();
}

class _ChartHeatRateState extends State<ChartHeatRate> {
  List<num> trace = [];
  Timer? _timer;
  final Future<FirebaseApp> fApp = Firebase.initializeApp();
  late DatabaseReference? dbref;
  var heartRate;

  List<double> traceSine = [];
  double radians = 0.0;

  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance.ref().child("1");
    dataChange();
    _timer = Timer.periodic(Duration(milliseconds: 100), _generateTrace);
  }

  dataChange() {
    dbref?.onValue.listen((event) {
      heartRate = event.snapshot.child("heartRate").value;
      print("HEARTRATE FIREBASE= $heartRate");
      trace.add(heartRate);
      print("TRACE= $trace");
    });
  }

  _generateTrace(Timer t) {
    setState(() {
      print("SEEEEEEEET");
    });
  }

  @override
  Widget build(BuildContext context) {
    Oscilloscope scope = Oscilloscope(
      showYAxis: false,
      yAxisColor: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      strokeWidth: 1.5,
      backgroundColor: Colors.white,
      traceColor: Colors.red.withOpacity(1),
      yAxisMax: 300,
      yAxisMin: -10,
      dataSet: trace,
    );
    return Expanded(flex: 1, child: scope);
  }
}
