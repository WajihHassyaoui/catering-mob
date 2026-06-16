import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/group_order_model.dart';
import '../../../../shared/models/order_model.dart';

final clientNavIndexProvider = StateProvider<int>((ref) => 0);
final activeGroupOrderProvider = StateProvider<GroupOrder?>((ref) => null);

// ── Cart Provider ──────────────────────────────────────────────────────────────

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  /// Add a meal to the cart. If it already exists, increment quantity.
  void addItem(CartItem item) {
    final idx = state.indexWhere((c) => c.mealId == item.mealId);
    if (idx != -1) {
      final updated = List<CartItem>.from(state);
      updated[idx] = updated[idx].copyWith(quantity: updated[idx].quantity + 1);
      state = updated;
    } else {
      state = [...state, item];
    }
  }

  /// Remove a meal entirely from the cart.
  void removeItem(String mealId) {
    state = state.where((c) => c.mealId != mealId).toList();
  }

  /// Increase the quantity of a cart item by 1.
  void increment(String mealId) {
    state = state.map((c) {
      if (c.mealId == mealId) return c.copyWith(quantity: c.quantity + 1);
      return c;
    }).toList();
  }

  /// Decrease the quantity of a cart item by 1, removing it if it reaches 0.
  void decrement(String mealId) {
    final item = state.firstWhere((c) => c.mealId == mealId);
    if (item.quantity <= 1) {
      removeItem(mealId);
    } else {
      state = state.map((c) {
        if (c.mealId == mealId) return c.copyWith(quantity: c.quantity - 1);
        return c;
      }).toList();
    }
  }

  /// Empty the cart (called after a successful checkout).
  void clear() => state = [];

  /// Total number of individual items across all cart entries.
  int get totalItems => state.fold(0, (sum, c) => sum + c.quantity);

  /// Grand total price.
  double get subtotal => state.fold(0.0, (sum, c) => sum + c.subtotal);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

