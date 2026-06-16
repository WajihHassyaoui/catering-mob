class CateringRequest {
  final String id;
  final String? companyId;
  final String? companyName;
  final String userId;
  final String contactPerson;
  final String workEmail;
  final String phone;
  final String eventType;
  final DateTime eventDate;
  final String eventTime;
  final String eventLocation;
  final int numberOfGuests;
  final String? packageId;
  final String? packageName;
  final List<String> dietaryRestrictions;
  final String serviceType;
  final String budgetRange;
  final String? specialRequests;
  final String status;
  final double? quotedPrice;
  final String? adminNotes;
  final DateTime createdAt;
  final DateTime? respondedAt;

  const CateringRequest({
    required this.id,
    this.companyId,
    this.companyName,
    required this.userId,
    required this.contactPerson,
    required this.workEmail,
    required this.phone,
    required this.eventType,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.numberOfGuests,
    this.packageId,
    this.packageName,
    this.dietaryRestrictions = const [],
    required this.serviceType,
    required this.budgetRange,
    this.specialRequests,
    required this.status,
    this.quotedPrice,
    this.adminNotes,
    required this.createdAt,
    this.respondedAt,
  });

  factory CateringRequest.fromJson(Map<String, dynamic> json) =>
      CateringRequest(
        id: json['id'] as String,
        companyId: json['company_id'] as String?,
        companyName: json['company_name'] as String?,
        userId: json['user_id'] as String,
        contactPerson: json['contact_person'] as String,
        workEmail: json['work_email'] as String,
        phone: json['phone'] as String,
        eventType: json['event_type'] as String,
        eventDate: DateTime.parse(json['event_date'] as String),
        eventTime: json['event_time'] as String,
        eventLocation: json['event_location'] as String,
        numberOfGuests: json['number_of_guests'] as int,
        packageId: json['package_id'] as String?,
        packageName: json['package_name'] as String?,
        dietaryRestrictions:
            List<String>.from(json['dietary_restrictions'] as List? ?? []),
        serviceType: json['service_type'] as String,
        budgetRange: json['budget_range'] as String,
        specialRequests: json['special_requests'] as String?,
        status: json['status'] as String,
        quotedPrice: (json['quoted_price'] as num?)?.toDouble(),
        adminNotes: json['admin_notes'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        respondedAt: json['responded_at'] != null
            ? DateTime.parse(json['responded_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_id': companyId,
        'company_name': companyName,
        'user_id': userId,
        'contact_person': contactPerson,
        'work_email': workEmail,
        'phone': phone,
        'event_type': eventType,
        'event_date': eventDate.toIso8601String(),
        'event_time': eventTime,
        'event_location': eventLocation,
        'number_of_guests': numberOfGuests,
        'package_id': packageId,
        'package_name': packageName,
        'dietary_restrictions': dietaryRestrictions,
        'service_type': serviceType,
        'budget_range': budgetRange,
        'special_requests': specialRequests,
        'status': status,
        'quoted_price': quotedPrice,
        'admin_notes': adminNotes,
        'created_at': createdAt.toIso8601String(),
        'responded_at': respondedAt?.toIso8601String(),
      };

  bool get isPending => status == 'pending';
  bool get isQuoted => status == 'quoted';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';
}

class MealPrepPlan {
  final String id;
  final String name;
  final String? companyId;
  final String? companyName;
  final String creatorId;
  final String? packageId;
  final String? packageName;
  final String duration;
  final int mealsPerDay;
  final bool includesBreakfast;
  final bool includesLunch;
  final bool includesDinner;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final int? calorieTarget;
  final List<String> deliveryDays;
  final String deliveryAddress;
  final double? budget;
  final List<String> assignedEmployeeIds;
  final String? notes;
  final String status;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime? nextDelivery;

  const MealPrepPlan({
    required this.id,
    required this.name,
    this.companyId,
    this.companyName,
    required this.creatorId,
    this.packageId,
    this.packageName,
    required this.duration,
    required this.mealsPerDay,
    this.includesBreakfast = false,
    this.includesLunch = true,
    this.includesDinner = false,
    this.dietaryPreferences = const [],
    this.allergies = const [],
    this.calorieTarget,
    this.deliveryDays = const [],
    required this.deliveryAddress,
    this.budget,
    this.assignedEmployeeIds = const [],
    this.notes,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    this.nextDelivery,
  });

  factory MealPrepPlan.fromJson(Map<String, dynamic> json) => MealPrepPlan(
        id: json['id'] as String,
        name: json['name'] as String,
        companyId: json['company_id'] as String?,
        companyName: json['company_name'] as String?,
        creatorId: json['creator_id'] as String,
        packageId: json['package_id'] as String?,
        packageName: json['package_name'] as String?,
        duration: json['duration'] as String,
        mealsPerDay: json['meals_per_day'] as int,
        includesBreakfast: json['includes_breakfast'] as bool? ?? false,
        includesLunch: json['includes_lunch'] as bool? ?? true,
        includesDinner: json['includes_dinner'] as bool? ?? false,
        dietaryPreferences:
            List<String>.from(json['dietary_preferences'] as List? ?? []),
        allergies: List<String>.from(json['allergies'] as List? ?? []),
        calorieTarget: json['calorie_target'] as int?,
        deliveryDays: List<String>.from(json['delivery_days'] as List? ?? []),
        deliveryAddress: json['delivery_address'] as String,
        budget: (json['budget'] as num?)?.toDouble(),
        assignedEmployeeIds:
            List<String>.from(json['assigned_employee_ids'] as List? ?? []),
        notes: json['notes'] as String?,
        status: json['status'] as String,
        startDate: DateTime.parse(json['start_date'] as String),
        endDate: json['end_date'] != null
            ? DateTime.parse(json['end_date'] as String)
            : null,
        createdAt: DateTime.parse(json['created_at'] as String),
        nextDelivery: json['next_delivery'] != null
            ? DateTime.parse(json['next_delivery'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'company_id': companyId,
        'company_name': companyName,
        'creator_id': creatorId,
        'package_id': packageId,
        'package_name': packageName,
        'duration': duration,
        'meals_per_day': mealsPerDay,
        'includes_breakfast': includesBreakfast,
        'includes_lunch': includesLunch,
        'includes_dinner': includesDinner,
        'dietary_preferences': dietaryPreferences,
        'allergies': allergies,
        'calorie_target': calorieTarget,
        'delivery_days': deliveryDays,
        'delivery_address': deliveryAddress,
        'budget': budget,
        'assigned_employee_ids': assignedEmployeeIds,
        'notes': notes,
        'status': status,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'next_delivery': nextDelivery?.toIso8601String(),
      };

  bool get isActive => status == 'active';
  bool get isPaused => status == 'paused';
  bool get isDraft => status == 'draft';

  List<String> get mealTypes {
    final types = <String>[];
    if (includesBreakfast) types.add('Breakfast');
    if (includesLunch) types.add('Lunch');
    if (includesDinner) types.add('Dinner');
    return types;
  }
}
