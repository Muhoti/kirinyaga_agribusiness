import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kirinyaga_agribusiness/Components/MySelectInput.dart';
import 'package:kirinyaga_agribusiness/Components/MyTextInput.dart';
import 'package:kirinyaga_agribusiness/Components/SubmitButton.dart';
import 'package:kirinyaga_agribusiness/Components/TextOakar.dart';
import 'package:kirinyaga_agribusiness/Components/Utils.dart';
import 'package:kirinyaga_agribusiness/Pages/FarmerValueChains.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TomatoSeedling extends StatefulWidget {
  const TomatoSeedling({super.key, required String farmerID});

  @override
  State<TomatoSeedling> createState() => _TomatoSeedlingState();
}

class _TomatoSeedlingState extends State<TomatoSeedling> {
  final storage = const FlutterSecureStorage();
  String error = '';
  var isLoading;
  String farmerID = '';
  String valueChain = 'TomatoSeedling';
  String tomatoseedlingQ1 = '';
  String tomatoseedlingQ2 = '';
  String tomatoseedlingQ3 = '';
  String tomatoseedlingQ4 = '';
  String tomatoseedlingQ5 = '';
  String tomatoseedlingQ6 = '';
  String tomatoseedlingQ7 = '';
  String tomatoseedlingQ8 = '';
  String tomatoseedlingQ9 = '';

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
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    MyTextInput(
                        title: "Value Chain",
                        lines: 1,
                        value: "TomatoSeedling",
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            valueChain = value;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextInput(
                        title: "Nursery Capacity",
                        lines: 1,
                        value: "",
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            tomatoseedlingQ1 = value;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextInput(
                        title: "Initial Investment Cost",
                        lines: 1,
                        value: "",
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            tomatoseedlingQ2 = value;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextInput(
                        title: "Input Cost",
                        lines: 1,
                        value: "",
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            tomatoseedlingQ3 = value;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    
                    MyTextInput(
                        title: "No. of Seelings Produced",
                        lines: 1,
                        value: "",
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            tomatoseedlingQ4 = value;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextInput(
                        title: "Spoiled Seedlings",
                        lines: 1,
                        value: "",
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            tomatoseedlingQ5 = value;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextInput(
                        title: "Sold Seedlings",
                        lines: 1,
                        value: "",
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            tomatoseedlingQ6 = value;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextInput(
                        title: "Seedling Price",
                        lines: 1,
                        value: "",
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            tomatoseedlingQ7 = value;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextInput(
                        title: "Seedling Buyers",
                        lines: 1,
                        value: "",
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            tomatoseedlingQ8 = value;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextOakar(label: error),
                    SubmitButton(
                      label: "Submit",
                      onButtonPressed: () async {
                        setState(() {
                          isLoading = LoadingAnimationWidget.staggeredDotsWave(
                            color: Color.fromRGBO(0, 128, 0, 1),
                            size: 100,
                          );
                        });
                        var res = await postTomatoSeedling(
                            farmerID,
                            valueChain,
                            tomatoseedlingQ1,
                            tomatoseedlingQ2,
                            tomatoseedlingQ3,
                            tomatoseedlingQ4,
                            tomatoseedlingQ5,
                            tomatoseedlingQ6,
                            tomatoseedlingQ7,
                            tomatoseedlingQ8);

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
                            Navigator.push(
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
          Center(
            child: isLoading,
          )
        ],
      ),
    );
  }
}

postTomatoSeedling(
    String farmerID,
    String valueChain,
    String tomatoseedlingQ1,
    String tomatoseedlingQ2,
    String tomatoseedlingQ3,
    String tomatoseedlingQ4,
    String tomatoseedlingQ5,
    String tomatoseedlingQ6,
    String tomatoseedlingQ7,
    String tomatoseedlingQ8) async {
  print(
      "the TomatoSeedling values are: $farmerID, $valueChain, $tomatoseedlingQ1, $tomatoseedlingQ2, $tomatoseedlingQ3, $tomatoseedlingQ5");

  if (valueChain.isEmpty ||
      tomatoseedlingQ2.isEmpty ||
      tomatoseedlingQ3.isEmpty ||
      tomatoseedlingQ4.isEmpty ||
      tomatoseedlingQ6.isEmpty ||
      tomatoseedlingQ7.isEmpty ||
      tomatoseedlingQ8.isEmpty) {
    return Message(
        token: null, success: null, error: "Please fill all inputs!");
  }
  var response = await http.post(Uri.parse("${getUrl()}tomatoseedlings"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'FarmerID': farmerID,
        'ValueChainName': valueChain,
        'Capacity': tomatoseedlingQ1,
        'InitialCost': tomatoseedlingQ2,
        'InputCost': tomatoseedlingQ3,
        'Seedlings': tomatoseedlingQ4,
        'SpoiltSeedlings': tomatoseedlingQ5,
        'SeedlingSold': tomatoseedlingQ6,
        'SeedlingPrice': tomatoseedlingQ7,
        'SeedlingBuyers': tomatoseedlingQ8,
      }));
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