import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

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
  final Logger logger = Logger();
  List<Offset> pinPositions = [];
  bool canPlacePin = false;
  bool isBlackAndWhite = false;

  @override
  void initState() {
    super.initState();
    _fetchPins(); // Fetch pins from Firestore
    _listenForPinUpdates(); // Listen for real-time updates
    if (widget.initialPins != null) {
      pinPositions.addAll(widget.initialPins!);
    }
  }

  Future<void> _fetchPins() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventName)
          .collection('pins')
          .get();

      setState(() {
        pinPositions = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return Offset(data['x'] as double, data['y'] as double);
        }).toList();
      });

      logger.i('Pins fetched successfully from Firestore.');
    } catch (e) {
      logger.e('Error fetching pins from Firestore', e);
    }
  }

  void _listenForPinUpdates() {
    FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventName)
        .collection('pins')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        pinPositions = snapshot.docs.map((doc) {
          final data = doc.data();
          return Offset(data['x'] as double, data['y'] as double);
        }).toList();
      });

      logger.i('Real-time pin updates received.');
    }, onError: (error) {
      logger.e('Error in Firestore listener: $error');
    });
  }

  void _addPin(Offset position) async {
    if (canPlacePin == false) return;

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        logger.e('User is not authenticated');
        return;
      }

      // Adjust pin position
      const double pinWidth = 30.0;
      const double pinHeight = 30.0;
      final adjustedPosition = Offset(
        position.dx - pinWidth / 2,
        position.dy - pinHeight / 2,
      );

      setState(() {
        pinPositions.add(adjustedPosition);
        canPlacePin = false;
      });

      final pinDocRef = FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventName)
          .collection('pins')
          .doc();

      // Write the pin to Firestore
      await pinDocRef.set({
        'x': position.dx,
        'y': position.dy,
        'userId': userId,
        'timestamp': Timestamp.now(),
      });

      logger.i('Pin added successfully.');

      // Write the notification to Firestore
      final notificationRef = FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventName)
          .collection('notifications')
          .doc();

      await notificationRef.set({
        'message': 'A new pin was added to ${widget.eventName}!',
        'timestamp': Timestamp.now(),
        'userId': userId,
        'eventName': widget.eventName,
      });

      logger.i('Notification created successfully.');
    } catch (e) {
      logger.e('Error adding pin or notification: $e');
    }
  }

  void _removePin(Offset position) async {
    if (widget.readonly) return;

    // Fetch the currently authenticated user's UID
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final eventDocRef =
          FirebaseFirestore.instance.collection('events').doc(widget.eventName);
      final pinQuery = await eventDocRef
          .collection('pins')
          .where('x', isEqualTo: position.dx)
          .where('y', isEqualTo: position.dy)
          .get();

      for (var doc in pinQuery.docs) {
        if (doc.data()['userId'] == userId) {
          await doc.reference.delete(); // Allow deletion
          logger.i('Pin removed successfully from Firestore.');
          setState(() {
            pinPositions.remove(position); // Remove the pin locally
          });
        } else {
          logger.w('Unauthorized attempt to remove another user\'s pin.');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('You can only remove pins you placed.')),
            );
          }
        }
      }
    } catch (e) {
      logger.e('Error removing pin from Firestore', e);
    }
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
              left: position.dx - 15.0, // Adjust for pin size (30x30)
              top: position.dy - 15.0, // Adjust for pin size (30x30)
              child: GestureDetector(
                onTap: () {
                  _removePin(position); // Call the updated method
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
