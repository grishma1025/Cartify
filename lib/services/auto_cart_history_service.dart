import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutoCartHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Checks whether this prediction has already been processed
  Future<bool> isAlreadyProcessed(
      String productId,
      DateTime predictedDate,
      ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return true;

    final docId =
        "${productId}_${predictedDate.year}_${predictedDate.month}_${predictedDate.day}";

    final doc = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("auto_cart_history")
        .doc(docId)
        .get();

    return doc.exists;
  }

  /// Saves a processed prediction
  Future<void> savePrediction(
      String productId,
      DateTime predictedDate,
      ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final docId =
        "${productId}_${predictedDate.year}_${predictedDate.month}_${predictedDate.day}";

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("auto_cart_history")
        .doc(docId)
        .set({
      "productId": productId,
      "predictedDate": Timestamp.fromDate(predictedDate),
      "addedAt": FieldValue.serverTimestamp(),
      "ordered": false,
      "status": "pending",
    });
  }

  /// Deletes history older than 180 days
  Future<void> clearOldHistory() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final cutoff =
    DateTime.now().subtract(const Duration(days: 180));

    final snapshot = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("auto_cart_history")
        .where(
      "predictedDate",
      isLessThan: Timestamp.fromDate(cutoff),
    )
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}