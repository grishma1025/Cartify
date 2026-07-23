import 'package:cartify/models/auto_cart_prediction.dart';
import 'package:cartify/models/product_model.dart';
import 'package:cartify/providers/cart_provider.dart';
import 'package:cartify/services/auto_cart_history_service.dart';
import 'package:cartify/services/product_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutoCartService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final ProductService _productService =
  ProductService();

  Future<List<AutoCartPrediction>> getPredictedProducts() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return [];
    }

    final orderSnapshot = await _firestore
        .collection("orders")
        .where("userId", isEqualTo: user.uid)
        .orderBy("createdAt")
        .get();

    if (orderSnapshot.docs.isEmpty) {
      return [];
    }

// Group purchase history by productId
    final Map<String, List<DateTime>> purchaseHistory = {};

    for (final order in orderSnapshot.docs) {
      final data = order.data();

      if (data["createdAt"] == null) continue;

      final orderDate =
      (data["createdAt"] as Timestamp).toDate();

      final List products = data["products"] ?? [];

      for (final product in products) {
        final productId = product["productId"];

        if (productId == null) continue;

        purchaseHistory.putIfAbsent(productId, () => []);

        purchaseHistory[productId]!.add(orderDate);
      }
    }


    // Prediction list
    final List<AutoCartPrediction> predictions = [];

    for (final entry in purchaseHistory.entries) {

      final productId = entry.key;

      final purchaseDates = entry.value;

      // Need at least 5 purchases
      if (purchaseDates.length < 5) {
        continue;
      }

      purchaseDates.sort();

      final List<int> gaps = [];

      for (int i = 1; i < purchaseDates.length; i++) {
        gaps.add(
          purchaseDates[i]
              .difference(purchaseDates[i - 1])
              .inDays,
        );
      }

      // Sort gaps to calculate median
      gaps.sort();

      int medianGap;

      if (gaps.length.isOdd) {
        medianGap = gaps[gaps.length ~/ 2];
      } else {
        medianGap =
            ((gaps[gaps.length ~/ 2 - 1] +
                gaps[gaps.length ~/ 2]) /
                2)
                .round();
      }

      final DateTime lastPurchase = purchaseDates.last;

      final DateTime predictedDate = lastPurchase.add(
        Duration(days: medianGap),
      );
      // Skip if prediction date hasn't arrived yet
      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      final prediction = DateTime(
        predictedDate.year,
        predictedDate.month,
        predictedDate.day,
      );

// Skip if prediction date hasn't arrived yet
      if (today.isBefore(prediction)) {
        continue;
      }

// Fetch product details
      final ProductModel? product =
      await _productService.getProductById(productId);

      if (product == null) {
        continue;
      }

// Add prediction
      predictions.add(
        AutoCartPrediction(
          product: product,
          purchaseCount: purchaseDates.length,
          averageGapDays: medianGap,
          lastPurchaseDate: lastPurchase,
          predictedDate: predictedDate,
        ),
      );

    }

    return predictions;
  }
  Future<List<ProductModel>> prepareAutoCart(
      CartProvider cartProvider,
      ) async {
    print("========== AUTO CART STARTED ==========");
    final predictions = await getPredictedProducts();
    print("Predictions found: ${predictions.length}");
    final historyService = AutoCartHistoryService();

    final List<ProductModel> addedProducts = [];

    for (final prediction in predictions) {
      print("Adding ${prediction.product.productName}");
      final product = prediction.product;

      final alreadyProcessed =
      await historyService.isAlreadyProcessed(
        product.id!,
        prediction.predictedDate,
      );

      if (alreadyProcessed) {
        continue;
      }

      if (cartProvider.isInCart(product.id!)) {
        continue;
      }

      await cartProvider.addToCart(
        product,
        isSuggested: true,
        suggestionReason:
        "Predicted from your shopping history",
      );

      await historyService.savePrediction(
        product.id!,
        prediction.predictedDate,
      );

      addedProducts.add(product);
    }

    return addedProducts;
  }

}