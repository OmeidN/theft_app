import 'package:flutter/material.dart';

class Edc2024 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EDC 2024'),
      ),
      body: Center(
        child: Image.network(
          'https://i.redd.it/pxczjrfuuwz81.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}