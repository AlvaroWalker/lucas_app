import 'package:flutter/material.dart';

class ListaSelecionada extends StatefulWidget {
  const ListaSelecionada({Key? key}) : super(key: key);

  @override
  _ListaSelecionadaState createState() => _ListaSelecionadaState();
}

class _ListaSelecionadaState extends State<ListaSelecionada> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Text('todo'),
    );
  }
}
