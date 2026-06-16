class GroupOrder {
  final String id;
  final String name;
  final String creatorId;
  final String creatorName;
  final String? companyId;
  final String? companyName;
  final String status;
  final String? menuPackageId;
  final String? menuPackageName;
  final String deliveryAddress;
  final DateTime deliveryDate;
  final String deliveryTime;
  final DateTime orderDeadline;
  final String? joinCode;
  final int participantCount;
  final int maxParticipants;
  final List<GroupOrderParticipant> participants;
  final double? estimatedTotal;
  final String paymentMethod;
  final String? notes;
  final DateTime createdAt;

  const GroupOrder({
    required this.id,
    required this.name,
    required this.creatorId,
    required this.creatorName,
    this.companyId,
    this.companyName,
    required this.status,
    this.menuPackageId,
    this.menuPackageName,
    required this.deliveryAddress,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.orderDeadline,
    this.joinCode,
    this.participantCount = 0,
    this.maxParticipants = 50,
    this.participants = const [],
    this.estimatedTotal,
    required this.paymentMethod,
    this.notes,
    required this.createdAt,
  });

  factory GroupOrder.fromJson(Map<String, dynamic> json) => GroupOrder(
        id: json['id'] as String,
        name: json['name'] as String,
        creatorId: json['creator_id'] as String,
        creatorName: json['creator_name'] as String,
        companyId: json['company_id'] as String?,
        companyName: json['company_name'] as String?,
        status: json['status'] as String,
        menuPackageId: json['menu_package_id'] as String?,
        menuPackageName: json['menu_package_name'] as String?,
        deliveryAddress: json['delivery_address'] as String,
        deliveryDate: DateTime.parse(json['delivery_date'] as String),
        deliveryTime: json['delivery_time'] as String,
        orderDeadline: DateTime.parse(json['order_deadline'] as String),
        joinCode: json['join_code'] as String?,
        participantCount: json['participant_count'] as int? ?? 0,
        maxParticipants: json['max_participants'] as int? ?? 50,
        participants: (json['participants'] as List? ?? [])
            .map((e) =>
                GroupOrderParticipant.fromJson(e as Map<String, dynamic>))
            .toList(),
        estimatedTotal: (json['estimated_total'] as num?)?.toDouble(),
        paymentMethod: json['payment_method'] as String? ?? 'invoice',
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'creator_id': creatorId,
        'creator_name': creatorName,
        'company_id': companyId,
        'company_name': companyName,
        'status': status,
        'menu_package_id': menuPackageId,
        'menu_package_name': menuPackageName,
        'delivery_address': deliveryAddress,
        'delivery_date': deliveryDate.toIso8601String(),
        'delivery_time': deliveryTime,
        'order_deadline': orderDeadline.toIso8601String(),
        'join_code': joinCode,
        'participant_count': participantCount,
        'max_participants': maxParticipants,
        'participants': participants.map((e) => e.toJson()).toList(),
        'estimated_total': estimatedTotal,
        'payment_method': paymentMethod,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  bool get isOpen => status == 'open';
  bool get isDraft => status == 'draft';
  bool get isClosed => status == 'closed';
  bool get isDelivered => status == 'delivered';
  bool get deadlinePassed => DateTime.now().isAfter(orderDeadline);
  Duration get timeUntilDeadline => orderDeadline.difference(DateTime.now());

  String get deadlineCountdown {
    if (deadlinePassed) return 'Deadline passed';
    final diff = timeUntilDeadline;
    if (diff.inDays > 0) return '${diff.inDays}d ${diff.inHours % 24}h left';
    if (diff.inHours > 0) {
      return '${diff.inHours}h ${diff.inMinutes % 60}m left';
    }
    return '${diff.inMinutes}m left';
  }

  double get participantProgress =>
      maxParticipants > 0 ? participantCount / maxParticipants : 0;

  GroupOrder copyWith({
    String? id,
    String? name,
    String? creatorId,
    String? creatorName,
    String? companyId,
    String? companyName,
    String? status,
    String? menuPackageId,
    String? menuPackageName,
    String? deliveryAddress,
    DateTime? deliveryDate,
    String? deliveryTime,
    DateTime? orderDeadline,
    String? joinCode,
    int? participantCount,
    int? maxParticipants,
    List<GroupOrderParticipant>? participants,
    double? estimatedTotal,
    String? paymentMethod,
    String? notes,
    DateTime? createdAt,
  }) =>
      GroupOrder(
        id: id ?? this.id,
        name: name ?? this.name,
        creatorId: creatorId ?? this.creatorId,
        creatorName: creatorName ?? this.creatorName,
        companyId: companyId ?? this.companyId,
        companyName: companyName ?? this.companyName,
        status: status ?? this.status,
        menuPackageId: menuPackageId ?? this.menuPackageId,
        menuPackageName: menuPackageName ?? this.menuPackageName,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        deliveryDate: deliveryDate ?? this.deliveryDate,
        deliveryTime: deliveryTime ?? this.deliveryTime,
        orderDeadline: orderDeadline ?? this.orderDeadline,
        joinCode: joinCode ?? this.joinCode,
        participantCount: participantCount ?? this.participantCount,
        maxParticipants: maxParticipants ?? this.maxParticipants,
        participants: participants ?? this.participants,
        estimatedTotal: estimatedTotal ?? this.estimatedTotal,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
}

class GroupOrderParticipant {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String? department;
  final List<GroupOrderMealSelection> mealSelections;
  final bool hasSubmitted;
  final DateTime? submittedAt;

  const GroupOrderParticipant({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    this.department,
    this.mealSelections = const [],
    this.hasSubmitted = false,
    this.submittedAt,
  });

  factory GroupOrderParticipant.fromJson(Map<String, dynamic> json) =>
      GroupOrderParticipant(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        userName: json['user_name'] as String,
        userAvatar: json['user_avatar'] as String?,
        department: json['department'] as String?,
        mealSelections: (json['meal_selections'] as List? ?? [])
            .map((e) =>
                GroupOrderMealSelection.fromJson(e as Map<String, dynamic>))
            .toList(),
        hasSubmitted: json['has_submitted'] as bool? ?? false,
        submittedAt: json['submitted_at'] != null
            ? DateTime.parse(json['submitted_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'user_name': userName,
        'user_avatar': userAvatar,
        'department': department,
        'meal_selections': mealSelections.map((e) => e.toJson()).toList(),
        'has_submitted': hasSubmitted,
        'submitted_at': submittedAt?.toIso8601String(),
      };

  String get initials {
    final parts = userName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return userName.isNotEmpty ? userName[0].toUpperCase() : '?';
  }
}

class GroupOrderMealSelection {
  final String mealId;
  final String mealName;
  final int quantity;
  final double unitPrice;
  final String? notes;

  const GroupOrderMealSelection({
    required this.mealId,
    required this.mealName,
    required this.quantity,
    required this.unitPrice,
    this.notes,
  });

  double get subtotal => unitPrice * quantity;

  factory GroupOrderMealSelection.fromJson(Map<String, dynamic> json) =>
      GroupOrderMealSelection(
        mealId: json['meal_id'] as String,
        mealName: json['meal_name'] as String,
        quantity: json['quantity'] as int,
        unitPrice: (json['unit_price'] as num).toDouble(),
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'meal_id': mealId,
        'meal_name': mealName,
        'quantity': quantity,
        'unit_price': unitPrice,
        'notes': notes,
      };
}
