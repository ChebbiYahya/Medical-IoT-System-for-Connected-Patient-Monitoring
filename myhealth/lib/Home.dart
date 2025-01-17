import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myhealth/components/incident.dart';
import 'package:myhealth/controller/patient_controller.dart';

import 'components/ChartECG.dart';
import 'components/ChartHeartRate.dart';
import 'components/ChartTemperature.dart';

class Home extends StatefulWidget {
  final String matricule;

  const Home({required this.matricule});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<FirebaseApp> fApp = Firebase.initializeApp();
  late DatabaseReference? dbref;

  var ecg;
  var heartRate;
  var spo2;
  var temperature;

  void initState() {
    super.initState();
    dbref = FirebaseDatabase.instance.ref().child("1");
    dataChange();
  }

  dataChange() async {
    dbref?.onValue.listen((event) {
      setState(() {
        ecg = event.snapshot.child("ecg").value;
        heartRate = event.snapshot.child("heartRate").value;
        spo2 = event.snapshot.child("spo2").value;
        temperature = event.snapshot.child("temperature").value;

        print("ecg= $ecg");
        print("heartRate= $heartRate");
        print("spo2= $spo2");
        print("temperature= $temperature");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE3DFDF),
      body: Stack(
        children: [
          SvgPicture.asset(
            "assets/images/bg.svg",
          ),
          SingleChildScrollView(
            child: FutureBuilder<NouveauPatient?>(
                future: NewPatientController()
                    .affichageNouveauPatientController(widget.matricule),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;

                    return data == null
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: <Widget>[
                              SizedBox(height: 50),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffffffff),
                                ),
                                height: 90,
                                child: Row(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: SvgPicture.asset(
                                        "assets/images/Patient.svg",
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Patient: ${data.prenom} ${data.nom}",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Color(0xFF000000)
                                                    .withOpacity(0.8),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 20),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                "Mtr: ${data.matricule}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF000000)
                                                        .withOpacity(0.8),
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 20),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "Chmbr: ${data.chambre}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF000000)
                                                        .withOpacity(0.8),
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 20),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "Lit: ${data.lit}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF000000)
                                                        .withOpacity(0.8),
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      "Fréquence cardiaque: $heartRate",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF000000)
                                              .withOpacity(0.6),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffffffff),
                                ),
                                height: 90,
                                child: ChartHeatRate(),
                              ),
                              SizedBox(height: 20),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Text(
                                      "SpO2 :",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xFF000000)
                                              .withOpacity(0.6),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(width: 185),
                                    Text(
                                      "$spo2%",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xFF000000)
                                              .withOpacity(0.6),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 35.0,
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffffffff),
                                ),
                                height: 50,
                              ),
                              SizedBox(height: 10),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      "ECG : $ecg",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF000000)
                                              .withOpacity(0.6),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                height: 90,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffffffff),
                                ),
                                child: ChartECG(),
                              ),
                              SizedBox(height: 10),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      "Température : $temperature °C",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF000000)
                                              .withOpacity(0.6),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                height: 90,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffffffff),
                                ),
                                child: ChartTemperature(),
                              ),
                              SizedBox(height: 10),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      "Incidents",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF000000)
                                              .withOpacity(0.6),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              //SizedBox(height: 5),
                              Container(
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xffC4C4C4),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: FirebaseAnimatedList(
                                    query: FirebaseDatabase.instance
                                        .ref()
                                        .child('1/pic'),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (context, snapshot, animation, index) {
                                      var v = snapshot.value.toString();
                                      var g = v.replaceAll(
                                          RegExp("{|}|temps: |type: |valeur: "),
                                          "");
                                      g.trim();
                                      var l = g.split(',');
                                      return GestureDetector(
                                        child: IncidentJour(
                                            date: l[1],
                                            pic: l[0],
                                            valeur: l[2]),
                                      );
                                    }),
                              ),
                            ],
                          );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          )
        ],
      ),
    );
  }
}
