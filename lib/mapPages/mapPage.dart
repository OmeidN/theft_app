import 'package:flutter/material.dart';

abstract class MapPage extends StatefulWidget {
  final String eventName;
  final String mapImageUrl;
  final String iconImageUrl;

  MapPage({
    required this.eventName,
    required this.mapImageUrl,
    required this.iconImageUrl,
  });

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState<T extends MapPage> extends State<T> {
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
        title: Text(widget.eventName),
        actions: [
          TextButton(
            onPressed: _togglePinPlacement,
            child: Text(
              canPlacePin ? 'Cancel Pin' : 'Place Pin',
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
                widget.mapImageUrl,
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