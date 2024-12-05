const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onPinAdded = functions.firestore
  .document("events/{eventId}/pins/{pinId}")
  .onCreate((snapshot, context) => {
    const eventId = context.params.eventId; // Get the event ID
    const pinData = snapshot.data(); // Data of the newly added pin

    // Construct the notification document
    const notification = {
      eventId: eventId,
      pinId: context.params.pinId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      userId: pinData.userId, // User who placed the pin
      eventName: eventId, // Use event ID as event name (can be customized)
    };

    // Add the notification to the 'notifications' collection
    return admin.firestore().collection("notifications").add(notification);
  });
