import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final snapshot = await _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return {
        "docId": doc.id,
        ...doc.data(),
      };
    }).toList();
  }
}