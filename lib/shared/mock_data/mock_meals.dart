import '../models/meal_model.dart';

class MockMeals {
  static final List<MealCategory> categories = [
    const MealCategory(
        id: 'cat_1',
        name: 'Salads & Bowls',
        iconEmoji: '🥗',
        imageUrl:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400'),
    const MealCategory(
        id: 'cat_2',
        name: 'Grilled & Proteins',
        iconEmoji: '🥩',
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'),
    const MealCategory(
        id: 'cat_3',
        name: 'Pasta & Grains',
        iconEmoji: '🍝',
        imageUrl:
            'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=400'),
    const MealCategory(
        id: 'cat_4',
        name: 'Sandwiches & Wraps',
        iconEmoji: '🥙',
        imageUrl:
            'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400'),
    const MealCategory(
        id: 'cat_5',
        name: 'Soups',
        iconEmoji: '🍲',
        imageUrl:
            'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400'),
    const MealCategory(
        id: 'cat_6',
        name: 'Desserts',
        iconEmoji: '🍮',
        imageUrl:
            'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=400'),
    const MealCategory(
        id: 'cat_7',
        name: 'Beverages',
        iconEmoji: '☕',
        imageUrl:
            'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400'),
  ];

  static final List<MealModel> meals = [
    MealModel(
      id: 'm_1',
      name: 'Mediterranean Grain Bowl',
      description:
          'Farro, roasted vegetables, hummus, kalamata olives, feta, and lemon tahini dressing on a bed of arugula.',
      price: 16.50,
      categoryId: 'cat_1',
      categoryName: 'Salads & Bowls',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600',
      calories: 520,
      ingredients: [
        'Farro',
        'Roasted Zucchini',
        'Bell Peppers',
        'Hummus',
        'Kalamata Olives',
        'Feta Cheese',
        'Arugula',
        'Tahini'
      ],
      allergens: ['Dairy', 'Sesame', 'Gluten'],
      dietaryTags: ['Vegetarian', 'High Protein', 'Healthy'],
      preparationTimeMinutes: 25,
      isFeatured: true,
      rating: 4.8,
      reviewCount: 142,
      createdAt: DateTime(2024, 1, 15),
    ),
    MealModel(
      id: 'm_2',
      name: 'Herb-Crusted Salmon',
      description:
          'Atlantic salmon fillet with lemon herb crust, roasted asparagus, wild rice, and dill cream sauce.',
      price: 24.00,
      categoryId: 'cat_2',
      categoryName: 'Grilled & Proteins',
      imageUrl:
          'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=600',
      calories: 580,
      ingredients: [
        'Atlantic Salmon',
        'Fresh Herbs',
        'Lemon',
        'Asparagus',
        'Wild Rice',
        'Dill',
        'Cream'
      ],
      allergens: ['Fish', 'Dairy'],
      dietaryTags: ['High Protein', 'Healthy', 'Gluten-Free'],
      preparationTimeMinutes: 30,
      isFeatured: true,
      rating: 4.9,
      reviewCount: 217,
      createdAt: DateTime(2024, 1, 16),
    ),
    MealModel(
      id: 'm_3',
      name: 'Avocado Chicken Caesar',
      description:
          'Grilled chicken breast, romaine hearts, house Caesar dressing, croutons, parmesan, and fresh avocado.',
      price: 18.00,
      categoryId: 'cat_1',
      categoryName: 'Salads & Bowls',
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
      calories: 490,
      ingredients: [
        'Grilled Chicken',
        'Romaine Lettuce',
        'Avocado',
        'Caesar Dressing',
        'Croutons',
        'Parmesan'
      ],
      allergens: ['Gluten', 'Dairy', 'Eggs'],
      dietaryTags: ['High Protein', 'Healthy'],
      preparationTimeMinutes: 20,
      rating: 4.7,
      reviewCount: 98,
      createdAt: DateTime(2024, 1, 17),
    ),
    MealModel(
      id: 'm_4',
      name: 'Tuscan Penne Primavera',
      description:
          'Penne pasta with seasonal vegetables, cherry tomatoes, fresh basil, olive oil, and aged parmesan.',
      price: 14.50,
      categoryId: 'cat_3',
      categoryName: 'Pasta & Grains',
      imageUrl:
          'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=600',
      calories: 610,
      ingredients: [
        'Penne Pasta',
        'Zucchini',
        'Cherry Tomatoes',
        'Basil',
        'Olive Oil',
        'Garlic',
        'Parmesan'
      ],
      allergens: ['Gluten', 'Dairy'],
      dietaryTags: ['Vegetarian'],
      preparationTimeMinutes: 25,
      rating: 4.6,
      reviewCount: 84,
      createdAt: DateTime(2024, 1, 18),
    ),
    MealModel(
      id: 'm_5',
      name: 'Turkey Avocado Club',
      description:
          'Sliced turkey breast, fresh avocado, crispy bacon, tomato, lettuce, and herb aioli on artisan bread.',
      price: 15.00,
      categoryId: 'cat_4',
      categoryName: 'Sandwiches & Wraps',
      imageUrl:
          'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=600',
      calories: 540,
      ingredients: [
        'Turkey Breast',
        'Avocado',
        'Bacon',
        'Tomato',
        'Lettuce',
        'Herb Aioli',
        'Artisan Bread'
      ],
      allergens: ['Gluten', 'Eggs'],
      dietaryTags: ['High Protein'],
      preparationTimeMinutes: 15,
      rating: 4.5,
      reviewCount: 73,
      createdAt: DateTime(2024, 1, 19),
    ),
    MealModel(
      id: 'm_6',
      name: 'Roasted Tomato Bisque',
      description:
          'Slow-roasted heirloom tomatoes, fresh basil cream, and house-made croutons. A warming classic.',
      price: 10.00,
      categoryId: 'cat_5',
      categoryName: 'Soups',
      imageUrl:
          'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=600',
      calories: 280,
      ingredients: [
        'Heirloom Tomatoes',
        'Basil',
        'Cream',
        'Garlic',
        'Onion',
        'Vegetable Broth',
        'Croutons'
      ],
      allergens: ['Dairy', 'Gluten'],
      dietaryTags: ['Vegetarian', 'Healthy'],
      preparationTimeMinutes: 10,
      rating: 4.8,
      reviewCount: 156,
      createdAt: DateTime(2024, 1, 20),
    ),
    MealModel(
      id: 'm_7',
      name: 'Korean BBQ Beef Bowl',
      description:
          'Tender bulgogi beef, steamed jasmine rice, pickled vegetables, sesame bok choy, and gochujang glaze.',
      price: 19.50,
      categoryId: 'cat_2',
      categoryName: 'Grilled & Proteins',
      imageUrl:
          'https://images.unsplash.com/photo-1559847844-5315695dadae?w=600',
      calories: 650,
      ingredients: [
        'Bulgogi Beef',
        'Jasmine Rice',
        'Pickled Radish',
        'Bok Choy',
        'Sesame',
        'Gochujang',
        'Scallions'
      ],
      allergens: ['Soy', 'Sesame', 'Gluten'],
      dietaryTags: ['High Protein', 'Halal', 'Spicy'],
      preparationTimeMinutes: 30,
      isFeatured: true,
      rating: 4.9,
      reviewCount: 203,
      createdAt: DateTime(2024, 1, 21),
    ),
    MealModel(
      id: 'm_8',
      name: 'Vegan Buddha Bowl',
      description:
          'Quinoa, roasted sweet potato, chickpeas, kale, avocado, pickled red onion, and miso tahini dressing.',
      price: 15.50,
      categoryId: 'cat_1',
      categoryName: 'Salads & Bowls',
      imageUrl:
          'https://images.unsplash.com/photo-1540914124281-342587941389?w=600',
      calories: 480,
      ingredients: [
        'Quinoa',
        'Sweet Potato',
        'Chickpeas',
        'Kale',
        'Avocado',
        'Red Onion',
        'Miso Tahini'
      ],
      allergens: ['Sesame', 'Soy'],
      dietaryTags: ['Vegan', 'Gluten-Free', 'High Protein', 'Healthy'],
      preparationTimeMinutes: 25,
      isFeatured: true,
      rating: 4.7,
      reviewCount: 119,
      createdAt: DateTime(2024, 1, 22),
    ),
    MealModel(
      id: 'm_9',
      name: 'Lemon Herb Chicken Wrap',
      description:
          'Grilled lemon herb chicken, hummus, roasted red peppers, cucumber, spinach in a whole wheat tortilla.',
      price: 13.50,
      categoryId: 'cat_4',
      categoryName: 'Sandwiches & Wraps',
      imageUrl:
          'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=600',
      calories: 430,
      ingredients: [
        'Grilled Chicken',
        'Hummus',
        'Red Pepper',
        'Cucumber',
        'Spinach',
        'Whole Wheat Tortilla',
        'Lemon Herb'
      ],
      allergens: ['Gluten', 'Sesame'],
      dietaryTags: ['High Protein', 'Healthy', 'Halal'],
      preparationTimeMinutes: 15,
      rating: 4.6,
      reviewCount: 87,
      createdAt: DateTime(2024, 1, 23),
    ),
    MealModel(
      id: 'm_10',
      name: 'Chocolate Lava Cake',
      description:
          'Warm dark chocolate fondant with a molten center, vanilla bean ice cream, and berry compote.',
      price: 9.00,
      categoryId: 'cat_6',
      categoryName: 'Desserts',
      imageUrl:
          'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=600',
      calories: 420,
      ingredients: [
        'Dark Chocolate',
        'Butter',
        'Eggs',
        'Sugar',
        'Flour',
        'Vanilla Ice Cream',
        'Mixed Berries'
      ],
      allergens: ['Dairy', 'Eggs', 'Gluten'],
      dietaryTags: [],
      preparationTimeMinutes: 20,
      rating: 4.9,
      reviewCount: 341,
      createdAt: DateTime(2024, 1, 24),
    ),
    MealModel(
      id: 'm_11',
      name: 'Grilled Veggie Flatbread',
      description:
          'House-made flatbread with roasted eggplant, caramelized onions, sun-dried tomatoes, and goat cheese.',
      price: 13.00,
      categoryId: 'cat_4',
      categoryName: 'Sandwiches & Wraps',
      imageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600',
      calories: 390,
      ingredients: [
        'Flatbread',
        'Eggplant',
        'Caramelized Onions',
        'Sun-Dried Tomatoes',
        'Goat Cheese',
        'Fresh Herbs'
      ],
      allergens: ['Gluten', 'Dairy'],
      dietaryTags: ['Vegetarian'],
      preparationTimeMinutes: 20,
      rating: 4.6,
      reviewCount: 62,
      createdAt: DateTime(2024, 1, 25),
    ),
    MealModel(
      id: 'm_12',
      name: 'Cold Brew Coffee',
      description:
          'Smooth 24-hour cold brew concentrate served over ice with oat milk. Add your preferred sweetness.',
      price: 6.00,
      categoryId: 'cat_7',
      categoryName: 'Beverages',
      imageUrl:
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600',
      calories: 80,
      ingredients: ['Cold Brew Coffee', 'Oat Milk', 'Ice'],
      allergens: [],
      dietaryTags: ['Vegan', 'Low Carb'],
      preparationTimeMinutes: 5,
      rating: 4.8,
      reviewCount: 274,
      createdAt: DateTime(2024, 1, 26),
    ),
  ];

  static final List<CateringPackage> cateringPackages = [
    const CateringPackage(
      id: 'cp_1',
      name: 'Executive Business Lunch',
      description:
          'Premium selection of gourmet salads, hot entrées, artisan breads, and a dessert station. Perfect for board meetings and client entertainment.',
      pricePerPerson: 45.00,
      minGuests: 10,
      maxGuests: 50,
      includedItems: [
        'Gourmet Salad Station',
        '2 Hot Entrées',
        'Artisan Bread & Butter',
        'Seasonal Sides',
        'Dessert Station',
        'Soft Beverages'
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600',
      suitableEventTypes: [
        'Board Meeting',
        'Client Entertainment',
        'Conference'
      ],
      serviceTypes: ['Delivery + Setup', 'Full-Service Catering'],
      dietaryOptions: ['Vegetarian', 'Gluten-Free', 'Vegan on request'],
    ),
    const CateringPackage(
      id: 'cp_2',
      name: 'Team Celebration Buffet',
      description:
          'Festive buffet spread for team events, training days, and office celebrations. Includes a wide variety of crowd-pleasing options.',
      pricePerPerson: 32.00,
      minGuests: 20,
      maxGuests: 150,
      includedItems: [
        'Salad Bar',
        '3 Main Dishes',
        'Rice & Pasta Sides',
        'Fresh Fruit Platter',
        'Pastry Station',
        'Coffee & Tea'
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1555244162-803834f70033?w=600',
      suitableEventTypes: ['Team Lunch', 'Training Day', 'Company Event'],
      serviceTypes: ['Buffet', 'Delivery + Setup'],
      dietaryOptions: ['Vegetarian', 'Halal', 'Gluten-Free options'],
    ),
    const CateringPackage(
      id: 'cp_3',
      name: 'Coffee Break Package',
      description:
          'Energize your team with specialty coffees, premium teas, freshly baked pastries, and healthy snack options.',
      pricePerPerson: 18.00,
      minGuests: 5,
      maxGuests: 100,
      includedItems: [
        'Specialty Coffee Station',
        'Premium Teas',
        'Freshly Baked Pastries',
        'Fresh Fruit Skewers',
        'Granola Bars',
        'Sparkling Water'
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600',
      suitableEventTypes: ['Coffee Break', 'Morning Meeting', 'Workshop'],
      serviceTypes: ['Delivery Only', 'Delivery + Setup'],
      dietaryOptions: ['Vegan options', 'Gluten-Free options'],
    ),
    const CateringPackage(
      id: 'cp_4',
      name: 'Corporate Gala Dinner',
      description:
          'A truly elevated dining experience for your most important corporate events. Multi-course plated dinner with full white-glove service.',
      pricePerPerson: 95.00,
      minGuests: 30,
      maxGuests: 300,
      includedItems: [
        'Welcome Canapés',
        '3-Course Plated Dinner',
        'Premium Wine & Beverage Service',
        'Live Dessert Station',
        'Full Wait Staff',
        'Table Settings'
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=600',
      suitableEventTypes: [
        'Annual Celebration',
        'Product Launch',
        'Awards Dinner',
        'Holiday Party'
      ],
      serviceTypes: ['Full-Service Catering', 'Custom Corporate Event'],
      dietaryOptions: ['All dietary requirements accommodated'],
    ),
  ];

  static final List<MealPrepPackage> mealPrepPackages = [
    const MealPrepPackage(
      id: 'mp_1',
      name: 'Weekly Office Lunch Plan',
      description:
          'Fresh, balanced lunches delivered to your office every weekday. Rotating seasonal menu designed by our nutritionists.',
      duration: '1 Week',
      mealsPerDay: 1,
      price: 89.00,
      mealCategories: ['Salads & Bowls', 'Grilled & Proteins', 'Wraps'],
      dietaryOptions: ['Standard', 'Vegetarian', 'Vegan', 'Gluten-Free'],
      deliveryDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600',
    ),
    const MealPrepPackage(
      id: 'mp_2',
      name: 'Monthly Team Meal Plan',
      description:
          'Comprehensive monthly meal program covering lunch and afternoon snacks for your entire team.',
      duration: '1 Month',
      mealsPerDay: 2,
      price: 320.00,
      mealCategories: ['All Categories'],
      dietaryOptions: [
        'Standard',
        'Vegetarian',
        'Vegan',
        'Gluten-Free',
        'High Protein'
      ],
      deliveryDays: ['Monday', 'Wednesday', 'Friday'],
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
    ),
    const MealPrepPackage(
      id: 'mp_3',
      name: 'Executive Lunch Subscription',
      description:
          'Premium curated lunches for your executive team. Chef-selected menus with premium ingredients and presentation.',
      duration: '2 Weeks',
      mealsPerDay: 1,
      price: 195.00,
      mealCategories: [
        'Grilled & Proteins',
        'Salads & Bowls',
        'Pasta & Grains'
      ],
      dietaryOptions: ['Standard', 'Gluten-Free', 'Low Carb'],
      deliveryDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      imageUrl:
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=600',
    ),
  ];

  static List<MealModel> getFeaturedMeals() =>
      meals.where((m) => m.isFeatured).toList();

  static List<MealModel> getMealsByCategory(String categoryId) =>
      meals.where((m) => m.categoryId == categoryId).toList();

  static List<MealModel> searchMeals(String query) {
    final q = query.toLowerCase();
    return meals
        .where((m) =>
            m.name.toLowerCase().contains(q) ||
            m.description.toLowerCase().contains(q) ||
            m.dietaryTags.any((t) => t.toLowerCase().contains(q)))
        .toList();
  }
}
