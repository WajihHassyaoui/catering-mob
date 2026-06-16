class InvoiceModel {
  final String id;
  final String invoiceNumber;
  final String companyId;
  final String companyName;
  final String? orderId;
  final String? groupOrderId;
  final String? cateringRequestId;
  final String invoiceType; // order | group_order | catering | meal_prep
  final List<InvoiceLineItem> lineItems;
  final double subtotal;
  final double tax;
  final double total;
  final String status; // pending | paid | overdue | cancelled
  final DateTime issuedAt;
  final DateTime dueDate;
  final DateTime? paidAt;
  final String? paymentReference;
  final String? notes;

  const InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.companyId,
    required this.companyName,
    this.orderId,
    this.groupOrderId,
    this.cateringRequestId,
    required this.invoiceType,
    this.lineItems = const [],
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    required this.issuedAt,
    required this.dueDate,
    this.paidAt,
    this.paymentReference,
    this.notes,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json['id'] as String,
        invoiceNumber: json['invoice_number'] as String,
        companyId: json['company_id'] as String,
        companyName: json['company_name'] as String,
        orderId: json['order_id'] as String?,
        groupOrderId: json['group_order_id'] as String?,
        cateringRequestId: json['catering_request_id'] as String?,
        invoiceType: json['invoice_type'] as String,
        lineItems: (json['line_items'] as List? ?? [])
            .map((e) => InvoiceLineItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal: (json['subtotal'] as num).toDouble(),
        tax: (json['tax'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
        status: json['status'] as String,
        issuedAt: DateTime.parse(json['issued_at'] as String),
        dueDate: DateTime.parse(json['due_date'] as String),
        paidAt: json['paid_at'] != null
            ? DateTime.parse(json['paid_at'] as String)
            : null,
        paymentReference: json['payment_reference'] as String?,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'invoice_number': invoiceNumber,
        'company_id': companyId,
        'company_name': companyName,
        'order_id': orderId,
        'group_order_id': groupOrderId,
        'catering_request_id': cateringRequestId,
        'invoice_type': invoiceType,
        'line_items': lineItems.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'tax': tax,
        'total': total,
        'status': status,
        'issued_at': issuedAt.toIso8601String(),
        'due_date': dueDate.toIso8601String(),
        'paid_at': paidAt?.toIso8601String(),
        'payment_reference': paymentReference,
        'notes': notes,
      };

  bool get isPaid => status == 'paid';
  bool get isPending => status == 'pending';
  bool get isOverdue =>
      status == 'overdue' || (isPending && DateTime.now().isAfter(dueDate));

  String get formattedTotal => '\$${total.toStringAsFixed(2)}';
  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;
}

class InvoiceLineItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double total;

  const InvoiceLineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) =>
      InvoiceLineItem(
        description: json['description'] as String,
        quantity: json['quantity'] as int,
        unitPrice: (json['unit_price'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'description': description,
        'quantity': quantity,
        'unit_price': unitPrice,
        'total': total,
      };
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type; // order | group_order | catering | invoice | system
  final String? referenceId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.referenceId,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        type: json['type'] as String,
        referenceId: json['reference_id'] as String?,
        isRead: json['is_read'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'body': body,
        'type': type,
        'reference_id': referenceId,
        'is_read': isRead,
        'created_at': createdAt.toIso8601String(),
      };

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        userId: userId,
        title: title,
        body: body,
        type: type,
        referenceId: referenceId,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
      );
}
