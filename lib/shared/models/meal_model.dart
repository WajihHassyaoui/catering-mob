class MealCategory {
  final String id;
  final String name;
  final String? iconEmoji;
  final String? imageUrl;
  final bool isActive;

  const MealCategory({
    required this.id,
    required this.name,
    this.iconEmoji,
    this.imageUrl,
    this.isActive = true,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) => MealCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        iconEmoji: json['icon_emoji'] as String?,
        imageUrl: json['image_url'] as String?,
        isActive: json['is_active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon_emoji': iconEmoji,
        'image_url': imageUrl,
        'is_active': isActive,
      };
}

class MealModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String? categoryName;
  final String? imageUrl;
  final int calories;
  final List<String> ingredients;
  final List<String> allergens;
  final List<String> dietaryTags;
  final int preparationTimeMinutes;
  final bool isAvailable;
  final bool isFeatured;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;

  const MealModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    this.categoryName,
    this.imageUrl,
    required this.calories,
    this.ingredients = const [],
    this.allergens = const [],
    this.dietaryTags = const [],
    required this.preparationTimeMinutes,
    this.isAvailable = true,
    this.isFeatured = false,
    this.rating = 0,
    this.reviewCount = 0,
    required this.createdAt,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        categoryId: json['category_id'] as String,
        categoryName: json['category_name'] as String?,
        imageUrl: json['image_url'] as String?,
        calories: json['calories'] as int? ?? 0,
        ingredients: List<String>.from(json['ingredients'] as List? ?? []),
        allergens: List<String>.from(json['allergens'] as List? ?? []),
        dietaryTags: List<String>.from(json['dietary_tags'] as List? ?? []),
        preparationTimeMinutes: json['preparation_time_minutes'] as int? ?? 30,
        isAvailable: json['is_available'] as bool? ?? true,
        isFeatured: json['is_featured'] as bool? ?? false,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: json['review_count'] as int? ?? 0,
        createdAt: DateTime.parse(
            json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category_id': categoryId,
        'category_name': categoryName,
        'image_url': imageUrl,
        'calories': calories,
        'ingredients': ingredients,
        'allergens': allergens,
        'dietary_tags': dietaryTags,
        'preparation_time_minutes': preparationTimeMinutes,
        'is_available': isAvailable,
        'is_featured': isFeatured,
        'rating': rating,
        'review_count': reviewCount,
        'created_at': createdAt.toIso8601String(),
      };

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get prepTime => '$preparationTimeMinutes min';

  MealModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? categoryId,
    String? categoryName,
    String? imageUrl,
    int? calories,
    List<String>? ingredients,
    List<String>? allergens,
    List<String>? dietaryTags,
    int? preparationTimeMinutes,
    bool? isAvailable,
    bool? isFeatured,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
  }) =>
      MealModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        imageUrl: imageUrl ?? this.imageUrl,
        calories: calories ?? this.calories,
        ingredients: ingredients ?? this.ingredients,
        allergens: allergens ?? this.allergens,
        dietaryTags: dietaryTags ?? this.dietaryTags,
        preparationTimeMinutes:
            preparationTimeMinutes ?? this.preparationTimeMinutes,
        isAvailable: isAvailable ?? this.isAvailable,
        isFeatured: isFeatured ?? this.isFeatured,
        rating: rating ?? this.rating,
        reviewCount: reviewCount ?? this.reviewCount,
        createdAt: createdAt ?? this.createdAt,
      );
}

class CateringPackage {
  final String id;
  final String name;
  final String description;
  final double pricePerPerson;
  final int minGuests;
  final int maxGuests;
  final List<String> includedItems;
  final String? imageUrl;
  final List<String> suitableEventTypes;
  final List<String> serviceTypes;
  final List<String> dietaryOptions;
  final bool isAvailable;

  const CateringPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerPerson,
    required this.minGuests,
    required this.maxGuests,
    this.includedItems = const [],
    this.imageUrl,
    this.suitableEventTypes = const [],
    this.serviceTypes = const [],
    this.dietaryOptions = const [],
    this.isAvailable = true,
  });

  factory CateringPackage.fromJson(Map<String, dynamic> json) =>
      CateringPackage(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        pricePerPerson: (json['price_per_person'] as num).toDouble(),
        minGuests: json['min_guests'] as int,
        maxGuests: json['max_guests'] as int,
        includedItems: List<String>.from(json['included_items'] as List? ?? []),
        imageUrl: json['image_url'] as String?,
        suitableEventTypes:
            List<String>.from(json['suitable_event_types'] as List? ?? []),
        serviceTypes: List<String>.from(json['service_types'] as List? ?? []),
        dietaryOptions:
            List<String>.from(json['dietary_options'] as List? ?? []),
        isAvailable: json['is_available'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price_per_person': pricePerPerson,
        'min_guests': minGuests,
        'max_guests': maxGuests,
        'included_items': includedItems,
        'image_url': imageUrl,
        'suitable_event_types': suitableEventTypes,
        'service_types': serviceTypes,
        'dietary_options': dietaryOptions,
        'is_available': isAvailable,
      };

  String get formattedPrice => '\$${pricePerPerson.toStringAsFixed(2)}/person';
  String get guestRange => '$minGuests–$maxGuests guests';
}

class MealPrepPackage {
  final String id;
  final String name;
  final String description;
  final String duration;
  final int mealsPerDay;
  final double price;
  final List<String> mealCategories;
  final List<String> dietaryOptions;
  final List<String> deliveryDays;
  final String? imageUrl;
  final bool isActive;

  const MealPrepPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.mealsPerDay,
    required this.price,
    this.mealCategories = const [],
    this.dietaryOptions = const [],
    this.deliveryDays = const [],
    this.imageUrl,
    this.isActive = true,
  });

  factory MealPrepPackage.fromJson(Map<String, dynamic> json) =>
      MealPrepPackage(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        duration: json['duration'] as String,
        mealsPerDay: json['meals_per_day'] as int,
        price: (json['price'] as num).toDouble(),
        mealCategories:
            List<String>.from(json['meal_categories'] as List? ?? []),
        dietaryOptions:
            List<String>.from(json['dietary_options'] as List? ?? []),
        deliveryDays: List<String>.from(json['delivery_days'] as List? ?? []),
        imageUrl: json['image_url'] as String?,
        isActive: json['is_active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'duration': duration,
        'meals_per_day': mealsPerDay,
        'price': price,
        'meal_categories': mealCategories,
        'dietary_options': dietaryOptions,
        'delivery_days': deliveryDays,
        'image_url': imageUrl,
        'is_active': isActive,
      };

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
}
