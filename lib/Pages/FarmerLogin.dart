// ignore_for_file: file_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kirinyaga_agribusiness/Components/MyTextInput.dart';
import 'package:kirinyaga_agribusiness/Components/SubmitButton.dart';
import 'package:kirinyaga_agribusiness/Components/TextLarge.dart';
import 'package:kirinyaga_agribusiness/Components/TextOakar.dart';
import 'package:kirinyaga_agribusiness/Components/Utils.dart';
import 'package:kirinyaga_agribusiness/Pages/FarmerHome.dart';
import 'package:kirinyaga_agribusiness/Pages/Login.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;

class FarmerLogin extends StatefulWidget {
  const FarmerLogin({super.key});

  @override
  State<StatefulWidget> createState() => _FarmerLoginState();
}

class _FarmerLoginState extends State<FarmerLogin> {
  String phone = '';
  String nationalId = '';
  String error = '';
  var isLoading;
  final storage = const FlutterSecureStorage();

  Future<void> verifyFarmer() async {
    var token = await storage.read(key: "erjwt");

    if (token != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const FarmerHome()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Login()));
    }
  }

  @override
  void initState() {
    //verifyFarmer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Farmer Login",
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: <Widget>[
            Center(
                child: Container(
                    constraints: const BoxConstraints.tightForFinite(),
                    child: SingleChildScrollView(
                      child: Form(
                          child: Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(84, 24, 84, 12),
                              child: Image.asset('assets/images/logo.png'),
                            ),
                            const TextLarge(label: "Farmer Login"),
                            TextOakar(label: error),
                            MyTextInput(
                              title: 'Phone Number',
                              lines: 1,
                              value: '',
                              type: TextInputType.phone,
                              onSubmit: (value) {
                                setState(() {
                                  phone = value;
                                });
                              },
                            ),
                            MyTextInput(
                              title: 'National ID',
                              lines: 1,
                              value: '',
                              type: TextInputType.number,
                              onSubmit: (value) {
                                setState(() {
                                  nationalId = value;
                                });
                              },
                            ),
                            SubmitButton(
                              label: "Login",
                              onButtonPressed: () async {
                                setState(() {
                                  isLoading =
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color: Color.fromRGBO(0, 128, 0, 1),
                                    size: 100,
                                  );
                                });
                                var res = await login(phone, nationalId);
                                setState(() {
                                  isLoading = null;
                                  if (res.error == null) {
                                    error = res.success;
                                  } else {
                                    error = res.error;
                                  }
                                });
                                if (res.error == null) {
                                  await storage.write(
                                      key: 'erjwt', value: res.token);
                                  await storage.write(
                                      key: 'Type', value: 'Farmer');
                                  Timer(const Duration(seconds: 2), () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const FarmerHome()));
                                  });
                                }
                              },
                            ),
                            const TextOakar(
                                label: "Powered by \n Oakar Services Ltd.")
                          ]))),
                    ))),
            Center(child: isLoading),
          ])),
    );
  }
}

Future<Message> login(String phone, String nationalId) async {
  if (phone.length != 9) {
    return Message(
      token: null,
      success: null,
      error: "Invalid phone number!",
    );
  }

  if (nationalId.length < 6) {
    return Message(
      token: null,
      success: null,
      error: "National ID is too short!",
    );
  }

  final response = await http.post(
    Uri.parse("${getUrl()}farmerdetails/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body:
        jsonEncode(<String, String>{'Phone': phone, 'NationalID': nationalId}),
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
