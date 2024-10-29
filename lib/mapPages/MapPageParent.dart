// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MapPageParent extends StatefulWidget {
  final String eventName;
  final String mapUrl;

  const MapPageParent({
    super.key,
    required this.eventName,
    required this.mapUrl,
  });

  @override
  _MapPageParentState createState() => _MapPageParentState();
}

class _MapPageParentState extends State<MapPageParent> {
  List<Offset> pinPositions = [];
  bool canPlacePin = false;
  bool isBlackAndWhite = false;

  void _addPin(Offset position) {
    setState(() {
      const double pinWidth = 30.0;
      const double pinHeight = 30.0;

      final adjustedPosition = Offset(
        position.dx - pinWidth / 2,
        position.dy - pinHeight / 2,
      );

      pinPositions.add(adjustedPosition);
      canPlacePin = false;
    });
  }

  void _togglePinPlacement() {
    setState(() {
      canPlacePin = !canPlacePin;
    });
  }

  void _toggleMapColor() {
    setState(() {
      isBlackAndWhite = !isBlackAndWhite;
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
              canPlacePin ? 'Cancel Pin' : 'Report a phone theft',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTapDown: canPlacePin ? (details) => _addPin(details.localPosition) : null,
            child: ColorFiltered(
              colorFilter: isBlackAndWhite
                  ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                  : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
              child: Image.network(widget.mapUrl, fit: BoxFit.cover),
            ),
          ),
          ...pinPositions.map((position) {
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: const Icon(Icons.pin_drop, color: Colors.red, size: 30),
            );
          }),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _toggleMapColor,
            child: Text(isBlackAndWhite ? 'Switch to Color Map' : 'Switch to Black & White Map'),
          ),
        ),
      ),
    );
  }
}
