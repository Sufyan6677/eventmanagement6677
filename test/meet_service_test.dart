import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

// We need to allow injecting Firestore for testing
Future<void> MeetServiceWithDb(String documentId, FakeFirebaseFirestore firestore) async {
  try {
    String meetLink = "https://meet.google.com/${DateTime.now().millisecondsSinceEpoch}";

    await firestore.collection("events").doc(documentId).update({
      "meetLink": meetLink,
    });
  } catch (e) {
    print("Error creating/storing meet link: $e");
  }
}

void main() {
  group("MeetService Tests", () {
    test("should store meet link in Firestore", () async {
      // Arrange
      final firestore = FakeFirebaseFirestore();

      // Create a dummy event document first
      const docId = "event123";
      await firestore.collection("events").doc(docId).set({
        "title": "Test Event",
      });

      // Act
      await MeetServiceWithDb(docId, firestore);

      // Assert
      final snapshot = await firestore.collection("events").doc(docId).get();
      final data = snapshot.data();

      expect(data, isNotNull);
      expect(data!["meetLink"], startsWith("https://meet.google.com/"));
    });

    test("should not throw if document missing", () async {
      final firestore = FakeFirebaseFirestore();

      // Missing doc
      await MeetServiceWithDb("missingDoc", firestore);

      final snapshot = await firestore.collection("events").doc("missingDoc").get();
      expect(snapshot.exists, false); // no doc created automatically
    });
  });
}
