import 'product_model.dart';

class AutoCartPrediction {
  final ProductModel product;

  final int purchaseCount;

  final int averageGapDays;

  final DateTime lastPurchaseDate;

  final DateTime predictedDate;

  const AutoCartPrediction({
    required this.product,
    required this.purchaseCount,
    required this.averageGapDays,
    required this.lastPurchaseDate,
    required this.predictedDate,
  });
}