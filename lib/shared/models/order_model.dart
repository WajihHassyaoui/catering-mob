class OrderItem {
  final String id;
  final String mealId;
  final String mealName;
  final String? mealImageUrl;
  final double unitPrice;
  final int quantity;
  final String? notes;

  const OrderItem({
    required this.id,
    required this.mealId,
    required this.mealName,
    this.mealImageUrl,
    required this.unitPrice,
    required this.quantity,
    this.notes,
  });

  double get subtotal => unitPrice * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id'] as String,
        mealId: json['meal_id'] as String,
        mealName: json['meal_name'] as String,
        mealImageUrl: json['meal_image_url'] as String?,
        unitPrice: (json['unit_price'] as num).toDouble(),
        quantity: json['quantity'] as int,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'meal_id': mealId,
        'meal_name': mealName,
        'meal_image_url': mealImageUrl,
        'unit_price': unitPrice,
        'quantity': quantity,
        'notes': notes,
      };

  OrderItem copyWith({
    String? id,
    String? mealId,
    String? mealName,
    String? mealImageUrl,
    double? unitPrice,
    int? quantity,
    String? notes,
  }) =>
      OrderItem(
        id: id ?? this.id,
        mealId: mealId ?? this.mealId,
        mealName: mealName ?? this.mealName,
        mealImageUrl: mealImageUrl ?? this.mealImageUrl,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        notes: notes ?? this.notes,
      );
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String userId;
  final String? companyId;
  final String? companyName;
  final List<OrderItem> items;
  final String status;
  final String deliveryAddress;
  final DateTime deliveryDate;
  final String? deliveryTime;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String paymentMethod;
  final String? paymentStatus;
  final String? promoCode;
  final double? discount;
  final String? notes;
  final String? departmentCode;
  final DateTime createdAt;
  final List<OrderStatusEvent> statusHistory;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    this.companyId,
    this.companyName,
    required this.items,
    required this.status,
    required this.deliveryAddress,
    required this.deliveryDate,
    this.deliveryTime,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    this.paymentStatus,
    this.promoCode,
    this.discount,
    this.notes,
    this.departmentCode,
    required this.createdAt,
    this.statusHistory = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        orderNumber: json['order_number'] as String,
        userId: json['user_id'] as String,
        companyId: json['company_id'] as String?,
        companyName: json['company_name'] as String?,
        items: (json['items'] as List? ?? [])
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        status: json['status'] as String,
        deliveryAddress: json['delivery_address'] as String,
        deliveryDate: DateTime.parse(json['delivery_date'] as String),
        deliveryTime: json['delivery_time'] as String?,
        subtotal: (json['subtotal'] as num).toDouble(),
        deliveryFee: (json['delivery_fee'] as num).toDouble(),
        tax: (json['tax'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
        paymentMethod: json['payment_method'] as String,
        paymentStatus: json['payment_status'] as String?,
        promoCode: json['promo_code'] as String?,
        discount: (json['discount'] as num?)?.toDouble(),
        notes: json['notes'] as String?,
        departmentCode: json['department_code'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        statusHistory: (json['status_history'] as List? ?? [])
            .map((e) => OrderStatusEvent.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_number': orderNumber,
        'user_id': userId,
        'company_id': companyId,
        'company_name': companyName,
        'items': items.map((e) => e.toJson()).toList(),
        'status': status,
        'delivery_address': deliveryAddress,
        'delivery_date': deliveryDate.toIso8601String(),
        'delivery_time': deliveryTime,
        'subtotal': subtotal,
        'delivery_fee': deliveryFee,
        'tax': tax,
        'total': total,
        'payment_method': paymentMethod,
        'payment_status': paymentStatus,
        'promo_code': promoCode,
        'discount': discount,
        'notes': notes,
        'department_code': departmentCode,
        'created_at': createdAt.toIso8601String(),
        'status_history': statusHistory.map((e) => e.toJson()).toList(),
      };

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isCancelled => status == 'cancelled';
  bool get isDelivered => status == 'delivered';
  bool get isActive => !isCancelled && !isDelivered;

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? userId,
    String? companyId,
    String? companyName,
    List<OrderItem>? items,
    String? status,
    String? deliveryAddress,
    DateTime? deliveryDate,
    String? deliveryTime,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    String? paymentMethod,
    String? paymentStatus,
    String? promoCode,
    double? discount,
    String? notes,
    String? departmentCode,
    DateTime? createdAt,
    List<OrderStatusEvent>? statusHistory,
  }) =>
      OrderModel(
        id: id ?? this.id,
        orderNumber: orderNumber ?? this.orderNumber,
        userId: userId ?? this.userId,
        companyId: companyId ?? this.companyId,
        companyName: companyName ?? this.companyName,
        items: items ?? this.items,
        status: status ?? this.status,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        deliveryDate: deliveryDate ?? this.deliveryDate,
        deliveryTime: deliveryTime ?? this.deliveryTime,
        subtotal: subtotal ?? this.subtotal,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        tax: tax ?? this.tax,
        total: total ?? this.total,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        promoCode: promoCode ?? this.promoCode,
        discount: discount ?? this.discount,
        notes: notes ?? this.notes,
        departmentCode: departmentCode ?? this.departmentCode,
        createdAt: createdAt ?? this.createdAt,
        statusHistory: statusHistory ?? this.statusHistory,
      );
}

class OrderStatusEvent {
  final String status;
  final DateTime timestamp;
  final String? note;

  const OrderStatusEvent({
    required this.status,
    required this.timestamp,
    this.note,
  });

  factory OrderStatusEvent.fromJson(Map<String, dynamic> json) =>
      OrderStatusEvent(
        status: json['status'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'timestamp': timestamp.toIso8601String(),
        'note': note,
      };
}

class CartItem {
  final String mealId;
  final String mealName;
  final String? mealImageUrl;
  final double unitPrice;
  int quantity;
  String? notes;

  CartItem({
    required this.mealId,
    required this.mealName,
    this.mealImageUrl,
    required this.unitPrice,
    this.quantity = 1,
    this.notes,
  });

  double get subtotal => unitPrice * quantity;

  CartItem copyWith({
    String? mealId,
    String? mealName,
    String? mealImageUrl,
    double? unitPrice,
    int? quantity,
    String? notes,
  }) =>
      CartItem(
        mealId: mealId ?? this.mealId,
        mealName: mealName ?? this.mealName,
        mealImageUrl: mealImageUrl ?? this.mealImageUrl,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        notes: notes ?? this.notes,
      );
}
