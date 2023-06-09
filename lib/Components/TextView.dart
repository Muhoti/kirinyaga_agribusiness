import 'package:flutter/material.dart';

class TextView extends StatefulWidget {
  final String label;
  const TextView({super.key, required this.label});

  @override
  State<StatefulWidget> createState() => _TextOakarState();
}

class _TextOakarState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Text(widget.label,
      textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.normal, color: Colors.blue)),
    );
  }
}
