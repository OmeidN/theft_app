import 'package:flutter/material.dart';

class Edc2024 extends StatefulWidget {
  @override
  _Edc2024State createState() => _Edc2024State();
}

class _Edc2024State extends State<Edc2024> {
  List<Offset> pinPositions = [];
  bool canPlacePin = false; // Flag to determine if pins can be placed

  void _addPin(Offset position) {
    setState(() {
      pinPositions.add(position);
      canPlacePin = false; // Reset the flag after placing a pin
    });
  }

  void _togglePinPlacement() {
    setState(() {
      canPlacePin = !canPlacePin; // Toggle the ability to place a pin
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EDC 2024'),
        actions: [
          TextButton(
            onPressed: _togglePinPlacement,
            child: Text(
              canPlacePin ? 'Cancel Pin' : 'Report a phone theft',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTapDown: canPlacePin
                  ? (details) {
                      _addPin(details.localPosition);
                    }
                  : null, // Only allow tap if canPlacePin is true
              child: Image.network(
                'https://i.redd.it/pxczjrfuuwz81.jpg',
                fit: BoxFit.cover,
              ),
            ),
            ...pinPositions.map((position) {
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: Icon(
                  Icons.pin_drop,
                  color: Colors.red,
                  size: 30, // Adjust pin size as needed
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
