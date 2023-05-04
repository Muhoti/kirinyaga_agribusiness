// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kirinyaga_agribusiness/Components/MyTextInput.dart';
import 'package:kirinyaga_agribusiness/Components/FODrawer.dart';
import 'package:kirinyaga_agribusiness/Components/SubmitButton.dart';
import 'package:kirinyaga_agribusiness/Components/TextOakar.dart';
import 'package:kirinyaga_agribusiness/Pages/FarmerHome.dart';
import 'package:kirinyaga_agribusiness/Pages/FarmerValueChains.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;

import '../Components/Utils.dart';

class AddValueChain extends StatefulWidget {
  const AddValueChain({super.key, required id});

  @override
  State<AddValueChain> createState() => _AddValueChainState();
}

class _AddValueChainState extends State<AddValueChain> {
  String valueChainID = '';
  String? valueChain = 'Banana';
  String farmerID = '';
  String farmerName = '';
  String AvgHarvestProduction = '';
  String AvgYearlyProduction = '';
  String approxAcreage = '';
  String? productionUnit = 'Kilograms';
  String variety = '';
  String error = '';
  var isLoading;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    checkMapping();
    super.initState();
  }

  checkMapping() async {
    try {
      var id = await storage.read(key: "NationalID");
      if (id != null) {
        setState(() {
          farmerID = id;
          print("VALUE CHAINS ID IS $farmerID");
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Value Chain"),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ],
        backgroundColor: Color.fromRGBO(0, 128, 0, 1),
      ),
      drawer: const Drawer(child: FODrawer()),
      body: SingleChildScrollView(
        child: Form(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const TextLarge(
                //   label: "Add Value Chain",
                // ),
                TextOakar(label: error),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 48,
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(24, 8, 24, 0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 128, 0, 1))),
                      labelText: 'Value Chain',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: TextStyle(color: Color.fromRGBO(0, 128, 0, 1)),
                    ),
                    value: valueChain, // use selectedGender variable
                    onChanged: (selectedValueChain) {
                      setState(() {
                        valueChain = selectedValueChain;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        child: Text("Banana"),
                        value: "Banana",
                      ),
                      DropdownMenuItem(
                        child: Text("Beans"),
                        value: "Beans",
                      ),
                      DropdownMenuItem(
                        child: Text("Dairy"),
                        value: "Dairy",
                      ),
                      DropdownMenuItem(
                        child: Text("Vegetables"),
                        value: "Vegetables",
                      ),
                      DropdownMenuItem(
                        child: Text("Local Chicken (Kienyeji)"),
                        value: "Local Chicken (Kienyeji)",
                      ),
                    ],
                  ),
                ),
                MyTextInput(
                    title: "Variety (Optional)",
                    lines: 1,
                    value: "",
                    type: TextInputType.text,
                    onSubmit: (value) {
                      setState(() {
                        variety = value;
                      });
                    }),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 48,
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(24, 8, 24, 0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 128, 0, 1))),
                      labelText: 'Production Unit',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: TextStyle(color: Color.fromRGBO(0, 128, 0, 1)),
                    ),
                    value: productionUnit, // use selectedGender variable
                    onChanged: (selectedProductionUnit) {
                      setState(() {
                        productionUnit = selectedProductionUnit;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: "Kilograms",
                        child: Text("Kilograms"),
                      ),
                      DropdownMenuItem(
                        child: Text("Litres"),
                        value: "Litres",
                      ),
                      DropdownMenuItem(
                        value: "Number",
                        child: Text("Number"),
                      ),
                      DropdownMenuItem(
                        value: "Trays",
                        child: Text("Trays"),
                      ),
                    ],
                  ),
                ),
                
                MyTextInput(
                    title: "Approximate Acreage (Acres)",
                    lines: 1,
                    value: "",
                    type: TextInputType.number,
                    onSubmit: (value) {
                      setState(() {
                        approxAcreage = value;
                      });
                    }),
                MyTextInput(
                    title: "Average Yearly Production",
                    lines: 1,
                    value: "",
                    type: TextInputType.number,
                    onSubmit: (value) {
                      setState(() {
                        AvgYearlyProduction = value;
                      });
                    }),
                MyTextInput(
                    title: "Average Harvest Production",
                    lines: 1,
                    value: "",
                    type: TextInputType.number,
                    onSubmit: (value) {
                      setState(() {
                        AvgHarvestProduction = value;
                      });
                    }),
                SubmitButton(
                  label: "Submit",
                  onButtonPressed: () async {
                    setState(() {
                      isLoading = LoadingAnimationWidget.staggeredDotsWave(
                        color: Color.fromRGBO(0, 128, 0, 1),
                        size: 100,
                      );
                    });
                    var res = await postProduce(
                        farmerID,
                        valueChain!,
                        variety,
                        productionUnit!,
                        approxAcreage,
                        AvgHarvestProduction,
                        AvgYearlyProduction);

                    setState(() {
                      isLoading = null;
                      if (res.error == null) {
                        error = res.success;
                      } else {
                        error = res.error;
                      }
                    });

                    if (res.error == null) {
                      await storage.write(key: 'erjwt', value: res.token);
                      Timer(const Duration(seconds: 2), () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FarmerValueChains()));
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<Message> postProduce(
  String farmerID,
  String valueChain,
  String variety,
  String productionUnit,
  String approxAcreage,
  String AvgHarvestProduction,
  String AvgYearlyProduction,
) async {
  if (AvgHarvestProduction.isEmpty) {
    return Message(
        token: null, success: null, error: "Please fill all inputs!");
  }

  final response = await http.post(
    Uri.parse("${getUrl()}farmervaluechains"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'FarmerID': farmerID,
      'Name': valueChain,
      'Variety': variety,
      'Unit': productionUnit,
      'ApproxAcreage': approxAcreage,
      'AvgYearlyProduction': AvgYearlyProduction,
      'AvgHarvestProduction': AvgHarvestProduction,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 203) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Message.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    return Message(
      token: null,
      success: null,
      error: "Connection to server failed!",
    );
  }
}

class Message {
  var token;
  var success;
  var error;

  Message({
    required this.token,
    required this.success,
    required this.error,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      token: json['token'],
      success: json['success'],
      error: json['error'],
    );
  }
}