import 'package:flutter/material.dart';

class MapPageParent extends StatefulWidget {
  final String eventName;
  final String mapUrl;
  final List<Offset>? initialPins;
  final bool readonly; // Add readonly parameter to control interactivity

  const MapPageParent({
    super.key,
    required this.eventName,
    required this.mapUrl,
    this.initialPins,
    this.readonly = false, // Default to false for interactive mode
  });

  @override
  MapPageParentState createState() => MapPageParentState();
}

class MapPageParentState extends State<MapPageParent> {
  List<Offset> pinPositions = [];
  bool canPlacePin = false;
  bool isBlackAndWhite = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPins != null) {
      pinPositions = List.from(widget.initialPins!);
    }
  }

  void _addPin(Offset position) {
    if (widget.readonly) return; // Prevent adding pins in read-only mode
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
    if (widget.readonly) {
      return; // Prevent enabling pin placement in read-only mode
    }
    setState(() {
      canPlacePin = !canPlacePin;
    });
  }

  void _toggleMapColor() {
    if (widget.readonly) return; // Prevent color toggle in read-only mode
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
          if (!widget.readonly)
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
            onTapDown: canPlacePin && !widget.readonly
                ? (details) => _addPin(details.localPosition)
                : null,
            child: ColorFiltered(
              colorFilter: isBlackAndWhite
                  ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                  : const ColorFilter.mode(
                      Colors.transparent, BlendMode.multiply),
              child: Image.network(widget.mapUrl, fit: BoxFit.cover),
            ),
          ),
          ...pinPositions.map((position) {
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: GestureDetector(
                onTap: () {
                  if (widget.readonly) return;
                  setState(() {
                    pinPositions.remove(position);
                  });
                },
                child: const Icon(Icons.pin_drop, color: Colors.red, size: 30),
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: widget.readonly
          ? null
          : BottomAppBar(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _toggleMapColor,
                  child: Text(isBlackAndWhite
                      ? 'Switch to Color Map'
                      : 'Switch to Black & White Map'),
                ),
              ),
            ),
    );
  }
}
