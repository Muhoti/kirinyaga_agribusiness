import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kirinyaga_agribusiness/Components/SubmitButton.dart';
import 'package:kirinyaga_agribusiness/Pages/AddValueChain.dart';
import 'package:kirinyaga_agribusiness/Pages/FarmerHome.dart';
import 'package:kirinyaga_agribusiness/Pages/Summary.dart';
import 'package:kirinyaga_agribusiness/Scroll/VCScrollController.dart';

class FarmerValueChains extends StatefulWidget {
  const FarmerValueChains({
    super.key,
  });

  @override
  State<FarmerValueChains> createState() => _FarmerValueChainsState();
}

class _FarmerValueChainsState extends State<FarmerValueChains> {
  final storage = const FlutterSecureStorage();
  String name = '';
  String FarmerID = '';
  String type = '';

  @override
  void initState() {
    checkMapping();
    super.initState();
  }

  checkMapping() async {
    try {
      var id = await storage.read(key: "NationalID");
      var usertype = await storage.read(key: "Type");

      type = usertype!;

      print("farmertype valuechain is $type and id is $id");

      if (id != null) {
        setState(() {
          FarmerID = id;
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirinyaga Agribusiness',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Farmer ValueChains",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(0, 128, 0, 1),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
              child: TextButton(
                onPressed: () {
                  type == "Farmer"
                      ? Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const FarmerHome()))
                      : Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const Summary()));
                },
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 24,
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FarmerID != ""
                  ? VCScrollController(id: FarmerID)
                  : const SizedBox(),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(12, 24, 12, 24),
                child: Column(
                  children: [
                    SubmitButton(
                      label: "Add ValueChain",
                      onButtonPressed: () {
                        storage.write(
                            key: "selectedValueChain",
                            value: "Select Value Chain");

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const AddValueChain(editing: false)));
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
