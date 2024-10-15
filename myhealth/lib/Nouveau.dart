import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myhealth/HomePatient.dart';
import 'package:myhealth/controller/patient_controller.dart';

TextEditingController _nom = TextEditingController();
TextEditingController _prenom = TextEditingController();
TextEditingController _matricule = TextEditingController();
TextEditingController _chambre = TextEditingController();
TextEditingController _lit = TextEditingController();
TextEditingController _carte = TextEditingController();

NewPatientController newPatientController = NewPatientController();

class Nouveau extends StatefulWidget {
  const Nouveau({super.key});

  @override
  State<Nouveau> createState() => _NouveauState();
}

class _NouveauState extends State<Nouveau> {
  final _PatientKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE3DFDF),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SvgPicture.asset(
                "assets/images/bg.svg",
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(CupertinoIcons.arrow_left)),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Dossier Medical Informatisé",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF000000).withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Nouveau Patient",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF000000).withOpacity(0.8),
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                        fontSize: 18),
                  ),
                  SizedBox(height: 40),
                  Container(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Form(
                        key: _PatientKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nom,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                hintText: "Nom",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter le nom ';
                                }
                                if (!RegExp(r'^[a-z A-Z,.\-]+$')
                                    .hasMatch(value)) {
                                  return 'Nom invalide';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _prenom,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                hintText: "Prenom",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter le Prenom ';
                                }
                                if (!RegExp(r'^[a-z A-Z,.\-]+$')
                                    .hasMatch(value)) {
                                  return 'Prenom invalide';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _matricule,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                hintText: "Matricule",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Entrer le Matricule';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _chambre,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      hintStyle:
                                          TextStyle(color: Colors.grey[600]),
                                      hintText: "Chambre",
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter n°.chambre ';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextFormField(
                                    controller: _lit,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      hintStyle:
                                          TextStyle(color: Colors.grey[600]),
                                      hintText: "Lit",
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Entrer n°.Lit';
                                      }
                                      if (!RegExp(r'^[0-9 ]+$')
                                          .hasMatch(value)) {
                                        return 'Lit invalide';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextFormField(
                                    controller: _carte,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      hintStyle:
                                          TextStyle(color: Colors.grey[600]),
                                      hintText: "Carte",
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Entrer n°.Carte';
                                      }
                                      if (!RegExp(r'^[0-9 ]+$')
                                          .hasMatch(value)) {
                                        return 'Carte invalide';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Expanded(
                                  child: CupertinoButton(
                                    child: Text(
                                      "Enregister",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Color(0xFFFFFDFD)
                                              .withOpacity(0.8)),
                                    ),
                                    color: Color(0xFF0094FF).withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(50),
                                    onPressed: () async {
                                      if (_PatientKey.currentState!
                                          .validate()) {
                                        newPatientController
                                            .createNewPatientController(
                                                _nom.text,
                                                _prenom.text,
                                                _matricule.text,
                                                _chambre.text,
                                                _lit.text,
                                                _carte.text)
                                            .then((value) => Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (contex) =>
                                                        HomePatient())));
                                      } else {
                                        print("failed");
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
