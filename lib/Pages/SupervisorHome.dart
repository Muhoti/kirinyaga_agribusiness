// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kirinyaga_agribusiness/Components/Stats.dart';
import 'package:kirinyaga_agribusiness/Components/Utils.dart';
import 'package:kirinyaga_agribusiness/Pages/FarmerDetails.dart';
import 'package:kirinyaga_agribusiness/Pages/Login.dart';
import 'package:kirinyaga_agribusiness/Scroll/FOScrollController.dart';
import 'package:kirinyaga_agribusiness/Scroll/SupScrollController.dart';
import '../Components/NavigationButton.dart';
import '../Components/NavigationDrawer2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SupervisorHome extends StatefulWidget {
  const SupervisorHome({super.key});

  @override
  State<SupervisorHome> createState() => _FieldOfficerHomeState();
}

class _FieldOfficerHomeState extends State<SupervisorHome> {
  final storage = const FlutterSecureStorage();
  String name = '';
  String total = '';
  String pending = '';
  String complete = '';
  String active = 'F.O Reports';
  String id = '';
  String status = 'Pending';

  @override
  void initState() {
    getDefaultValues();
    super.initState();
  }

  Future<void> getDefaultValues() async {
    var token = await storage.read(key: "erjwt");
    var decoded = parseJwt(token.toString());
    if (decoded["error"] == "Invalid token") {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Login()));
    } else {
      setState(() {
        name = decoded["Name"];
        id = decoded["UserID"];
      });

      countTasks(decoded["UserID"]);
    }
  }

  Future<void> countTasks(String id) async {
    try {
      final dynamic response;

      active == "My Reports"
          ? response = await http.get(
              Uri.parse("${getUrl()}reports/stats/fieldofficer/$id"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
            )
            
          : response = await http.get(
              Uri.parse("${getUrl()}workplan/stats/fieldofficer/$id"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
            );

      print(response.body);
      print("this is being implemented");
      print("the id is $id");

      var data = json.decode(response.body);

      setState(() {
        total = data["total"].toString();
        pending = data["pending"].toString();
        complete = data["complete"].toString();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirinyaga Agribusiness',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Super Home"),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ],
          backgroundColor: const Color.fromRGBO(0, 128, 0, 1),
        ),
        drawer: const Drawer(child: NavigationDrawer2()),
        
        body: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(12, 24, 12, 24),
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Stats(
                          label: "Work Plan",
                          color: Colors.blue,
                          value: total,
                          icon: Icons.trending_up,
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Stats(
                          label: "Farmers",
                          color: Colors.orange,
                          value: pending,
                          icon: Icons.refresh,
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Stats(
                          label: "Completed",
                          color: Colors.green,
                          value: complete,
                          icon: Icons.done,
                        )),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                children: [
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: NavigationButton(
                        label: "F.O Reports",
                        active: active,
                        buttonPressed: () {
                          setState(() {
                            active = "F.O Reports";
                            status = "Pending";
                            countTasks(id);
                            print("the count task is is $id");
                          });
                        },
                      )),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: NavigationButton(
                      label: "My Reports",
                      active: active,
                      buttonPressed: () {
                        setState(() {
                          active = "My Reports";
                          status = "Complete";
                          countTasks(id);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: id != ""
                  ? SupScrollController(
                      id: id, active: active, status: status)
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}