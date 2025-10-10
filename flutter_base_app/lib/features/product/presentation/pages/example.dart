import 'package:flutter/material.dart';

class NameWidget extends StatefulWidget {
  const NameWidget({super.key});

  @override
  State<NameWidget> createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Text('Hola'));
  }
}
