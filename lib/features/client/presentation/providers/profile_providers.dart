import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/models/meal_model.dart';
import '../../../../shared/models/review_model.dart';
import '../../../../shared/models/order_model.dart';
import '../../../../shared/mock_data/mock_meals.dart';
import '../../../../shared/mock_data/mock_data.dart';
import '../../../../core/constants/app_colors.dart';
import 'client_providers.dart';


// ── Dietary Preferences Provider ──────────────────────────────────────────────

class DietaryPreferencesNotifier extends StateNotifier<List<String>> {
  DietaryPreferencesNotifier()
      : super(['High Protein', 'Gluten-Free', 'Halal', 'No Peanuts']);

  void updatePreferences(List<String> preferences) {
    state = List.from(preferences);
  }
}

final dietaryPreferencesProvider =
    StateNotifierProvider<DietaryPreferencesNotifier, List<String>>((ref) {
  return DietaryPreferencesNotifier();
});

// ── Addresses Provider ─────────────────────────────────────────────────────────

class AddressesNotifier extends StateNotifier<List<AddressModel>> {
  AddressesNotifier()
      : super([
          const AddressModel(
            id: 'addr_1',
            label: 'Office (Default)',
            street: '150 Tech Park Drive, Suite 400',
            city: 'San Francisco',
            state: 'CA',
            zip: '94105',
            isDefault: true,
          ),
          const AddressModel(
            id: 'addr_2',
            label: 'Home',
            street: '458 Oak Avenue',
            city: 'San Francisco',
            state: 'CA',
            zip: '94117',
            isDefault: false,
          ),
        ]);

  void addAddress(AddressModel address) {
    if (address.isDefault) {
      state = [
        ...state.map((a) => a.copyWith(isDefault: false)),
        address,
      ];
    } else {
      state = [...state, address];
    }
  }

  void updateAddress(AddressModel updatedAddress) {
    state = state.map((a) {
      if (a.id == updatedAddress.id) {
        return updatedAddress;
      }
      if (updatedAddress.isDefault) {
        return a.copyWith(isDefault: false);
      }
      return a;
    }).toList();
  }

  void deleteAddress(String id) {
    state = state.where((a) => a.id != id).toList();
    // If we deleted the default address and there are still addresses left, make the first one default
    if (state.isNotEmpty && !state.any((a) => a.isDefault)) {
      state = [
        state.first.copyWith(isDefault: true),
        ...state.sublist(1),
      ];
    }
  }

  void setDefaultAddress(String id) {
    state = state.map((a) {
      return a.copyWith(isDefault: a.id == id);
    }).toList();
  }
}

final addressesProvider =
    StateNotifierProvider<AddressesNotifier, List<AddressModel>>((ref) {
  return AddressesNotifier();
});

// ── Favorites Provider ─────────────────────────────────────────────────────────

class FavoritesNotifier extends StateNotifier<List<MealModel>> {
  FavoritesNotifier() : super(MockMeals.meals.take(3).toList());

  void toggleFavorite(MealModel meal) {
    if (state.any((m) => m.id == meal.id)) {
      state = state.where((m) => m.id != meal.id).toList();
    } else {
      state = [...state, meal];
    }
  }

  void removeFavorite(String mealId) {
    state = state.where((m) => m.id != mealId).toList();
  }

  bool isFavorite(String mealId) {
    return state.any((m) => m.id == mealId);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<MealModel>>((ref) {
  return FavoritesNotifier();
});

// ── Reviews Provider ───────────────────────────────────────────────────────────

class ReviewsNotifier extends StateNotifier<List<ReviewModel>> {
  ReviewsNotifier()
      : super([
          ReviewModel(
            id: 'rev_1',
            mealId: MockMeals.meals.isNotEmpty ? MockMeals.meals[0].id : 'meal_1',
            mealName: MockMeals.meals.isNotEmpty
                ? MockMeals.meals[0].name
                : 'Mediterranean Grain Bowl',
            rating: 5,
            comment:
                'Absolutely delicious! The ingredients were fresh, and the portion size was perfect for lunch.',
            createdAt: DateTime.now().subtract(const Duration(days: 4)),
          ),
          ReviewModel(
            id: 'rev_2',
            mealId: MockMeals.meals.length > 1 ? MockMeals.meals[1].id : 'meal_2',
            mealName: MockMeals.meals.length > 1
                ? MockMeals.meals[1].name
                : 'Herb-Crusted Salmon',
            rating: 4,
            comment:
                'Great texture and taste. The asparagus side was a bit salty, but overall very good.',
            createdAt: DateTime.now().subtract(const Duration(days: 19)),
          ),
        ]);

  void addReview(ReviewModel review) {
    state = [review, ...state];
  }

  void updateReview(ReviewModel updatedReview) {
    state = state.map((r) => r.id == updatedReview.id ? updatedReview : r).toList();
  }

  void deleteReview(String id) {
    state = state.where((r) => r.id != id).toList();
  }
}

final reviewsProvider =
    StateNotifierProvider<ReviewsNotifier, List<ReviewModel>>((ref) {
  return ReviewsNotifier();
});

// Extension helper for AddressModel to easily copy and change fields
extension AddressModelCopy on AddressModel {
  AddressModel copyWith({
    String? id,
    String? label,
    String? street,
    String? city,
    String? state,
    String? zip,
    String? country,
    bool? isDefault,
    double? latitude,
    double? longitude,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

// ── Cart Checkout Helper ────────────────────────────────────────────────────────

void placeCartOrder(WidgetRef ref, BuildContext context, List<CartItem> cartItems) {
  if (cartItems.isEmpty) return;

  final orderNumber = 'PLT-IND-${DateTime.now().millisecondsSinceEpoch % 100000}';

  final orderItems = cartItems.map((c) => OrderItem(
    id: 'oi_${c.mealId}_${DateTime.now().millisecondsSinceEpoch}',
    mealId: c.mealId,
    mealName: c.mealName,
    mealImageUrl: c.mealImageUrl,
    unitPrice: c.unitPrice,
    quantity: c.quantity,
  )).toList();

  final subtotal = cartItems.fold(0.0, (sum, c) => sum + c.subtotal);
  const deliveryFee = 5.0;
  final tax = subtotal * 0.08;
  final total = subtotal + deliveryFee + tax;

  final newOrder = OrderModel(
    id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
    orderNumber: orderNumber,
    userId: 'u_client_1',
    companyId: null,
    companyName: null,
    items: orderItems,
    status: 'pending',
    deliveryAddress: '150 Tech Park Drive, Suite 400, San Francisco, CA 94105',
    deliveryDate: DateTime.now().add(const Duration(hours: 1)),
    deliveryTime: '12:30 PM',
    subtotal: subtotal,
    deliveryFee: deliveryFee,
    tax: tax,
    total: total,
    paymentMethod: 'card',
    paymentStatus: 'pending',
    createdAt: DateTime.now(),
    statusHistory: [
      OrderStatusEvent(status: 'pending', timestamp: DateTime.now()),
    ],
  );

  MockData.orders.insert(0, newOrder);

  // Clear the cart
  ref.read(cartProvider.notifier).clear();

  final totalQuantity = orderItems.fold(0, (sum, i) => sum + i.quantity);

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Order "$orderNumber" placed — $totalQuantity item(s)!'),
      backgroundColor: AppColors.oliveGreen,
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: 'TRACK',
        textColor: Colors.white,
        onPressed: () {
          ref.read(clientNavIndexProvider.notifier).state = 3;
        },
      ),
    ),
  );

  ref.read(clientNavIndexProvider.notifier).state = 3;
}

