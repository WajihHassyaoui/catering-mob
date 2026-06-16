class ReviewModel {
  final String id;
  final String mealId;
  final String mealName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.mealId,
    required this.mealName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id'] as String,
        mealId: json['meal_id'] as String,
        mealName: json['meal_name'] as String,
        rating: json['rating'] as int,
        comment: json['comment'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'meal_id': mealId,
        'meal_name': mealName,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt.toIso8601String(),
      };

  ReviewModel copyWith({
    String? id,
    String? mealId,
    String? mealName,
    int? rating,
    String? comment,
    DateTime? createdAt,
  }) =>
      ReviewModel(
        id: id ?? this.id,
        mealId: mealId ?? this.mealId,
        mealName: mealName ?? this.mealName,
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        createdAt: createdAt ?? this.createdAt,
      );
}
