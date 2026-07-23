import 'dart:async';

import 'package:cartify/models/cart_item_model.dart';
import 'package:cartify/models/product_model.dart';
import 'package:cartify/services/cart_service.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  List<CartItemModel> _cartItems = [];

  StreamSubscription<List<CartItemModel>>? _subscription;

  List<CartItemModel> get cartItems => _cartItems;

  CartProvider() {
    _listenToCart();
  }

  void _listenToCart() {
    _subscription?.cancel();

    _subscription = _cartService.cartItems().listen((items) {
      _cartItems = items;
      notifyListeners();
    });
  }

  Future<void> addToCart(
      ProductModel product, {
        bool isSuggested = false,
        String suggestionReason = "",
      }) async {
    await _cartService.addToCart(
      product,
      isSuggested: isSuggested,
      suggestionReason: suggestionReason,
    );
  }

  Future<void> increaseQuantity(String productId) async {
    await _cartService.increaseQuantity(productId);
  }

  Future<void> decreaseQuantity(String productId) async {
    await _cartService.decreaseQuantity(productId);
  }

  Future<void> removeItem(String productId) async {
    await _cartService.removeItem(productId);
  }

  Future<void> clearCart() async {
    await _cartService.clearCart();
  }

  int get totalItems {
    return _cartItems.fold(
      0,
          (sum, item) => sum + item.cartQuantity,
    );
  }

  double get subtotal {
    return _cartItems.fold(
      0,
          (sum, item) => sum + item.totalPrice,
    );
  }

  double get totalSavings {
    return _cartItems.fold(
      0,
          (sum, item) => sum + item.totalSaving,
    );
  }

  bool isInCart(String productId) {
    return _cartItems.any((item) => item.productId == productId);
  }

  int quantityOf(String productId) {
    try {
      return _cartItems
          .firstWhere((item) => item.productId == productId)
          .cartQuantity;
    } catch (_) {
      return 0;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}