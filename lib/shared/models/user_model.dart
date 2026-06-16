class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String role; // client | company | admin
  final String? avatarUrl;
  final String? companyId;
  final bool isEmailVerified;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.companyId,
    this.isEmailVerified = false,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        fullName: json['full_name'] as String,
        phone: json['phone'] as String? ?? '',
        role: json['role'] as String,
        avatarUrl: json['avatar_url'] as String?,
        companyId: json['company_id'] as String?,
        isEmailVerified: json['is_email_verified'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'phone': phone,
        'role': role,
        'avatar_url': avatarUrl,
        'company_id': companyId,
        'is_email_verified': isEmailVerified,
        'created_at': createdAt.toIso8601String(),
      };

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? role,
    String? avatarUrl,
    String? companyId,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        role: role ?? this.role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        companyId: companyId ?? this.companyId,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        createdAt: createdAt ?? this.createdAt,
      );

  String get firstName => fullName.split(' ').first;
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }
}

class AddressModel {
  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;
  final bool isDefault;
  final double? latitude;
  final double? longitude;

  const AddressModel({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    this.country = 'United States',
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'] as String,
        label: json['label'] as String,
        street: json['street'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
        zip: json['zip'] as String,
        country: json['country'] as String? ?? 'United States',
        isDefault: json['is_default'] as bool? ?? false,
        latitude: json['latitude'] as double?,
        longitude: json['longitude'] as double?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'street': street,
        'city': city,
        'state': state,
        'zip': zip,
        'country': country,
        'is_default': isDefault,
        'latitude': latitude,
        'longitude': longitude,
      };

  String get fullAddress => '$street, $city, $state $zip';
}

class CompanyMember {
  final String id;
  final String userId;
  final String companyId;
  final String fullName;
  final String email;
  final String phone;
  final String department;
  final String roleInCompany;
  final double? spendingLimit;
  final MemberPermissions permissions;
  final String status; // active | invited | suspended
  final DateTime joinedAt;

  const CompanyMember({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.department,
    required this.roleInCompany,
    this.spendingLimit,
    required this.permissions,
    required this.status,
    required this.joinedAt,
  });

  factory CompanyMember.fromJson(Map<String, dynamic> json) => CompanyMember(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        companyId: json['company_id'] as String,
        fullName: json['full_name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String? ?? '',
        department: json['department'] as String? ?? '',
        roleInCompany: json['role_in_company'] as String? ?? 'Employee',
        spendingLimit: json['spending_limit'] as double?,
        permissions: MemberPermissions.fromJson(
            json['permissions'] as Map<String, dynamic>? ?? {}),
        status: json['status'] as String,
        joinedAt: DateTime.parse(json['joined_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'company_id': companyId,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'department': department,
        'role_in_company': roleInCompany,
        'spending_limit': spendingLimit,
        'permissions': permissions.toJson(),
        'status': status,
        'joined_at': joinedAt.toIso8601String(),
      };

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }
}

class MemberPermissions {
  final bool canJoinGroupOrders;
  final bool canCreateGroupOrders;
  final bool canPlaceIndividualOrders;
  final bool canRequestCatering;
  final bool canApproveOrders;
  final bool canViewCompanyOrders;
  final bool canManageBilling;
  final bool isCompanyAdmin;

  const MemberPermissions({
    this.canJoinGroupOrders = true,
    this.canCreateGroupOrders = false,
    this.canPlaceIndividualOrders = true,
    this.canRequestCatering = false,
    this.canApproveOrders = false,
    this.canViewCompanyOrders = false,
    this.canManageBilling = false,
    this.isCompanyAdmin = false,
  });

  factory MemberPermissions.fromJson(Map<String, dynamic> json) =>
      MemberPermissions(
        canJoinGroupOrders: json['can_join_group_orders'] as bool? ?? true,
        canCreateGroupOrders: json['can_create_group_orders'] as bool? ?? false,
        canPlaceIndividualOrders:
            json['can_place_individual_orders'] as bool? ?? true,
        canRequestCatering: json['can_request_catering'] as bool? ?? false,
        canApproveOrders: json['can_approve_orders'] as bool? ?? false,
        canViewCompanyOrders: json['can_view_company_orders'] as bool? ?? false,
        canManageBilling: json['can_manage_billing'] as bool? ?? false,
        isCompanyAdmin: json['is_company_admin'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'can_join_group_orders': canJoinGroupOrders,
        'can_create_group_orders': canCreateGroupOrders,
        'can_place_individual_orders': canPlaceIndividualOrders,
        'can_request_catering': canRequestCatering,
        'can_approve_orders': canApproveOrders,
        'can_view_company_orders': canViewCompanyOrders,
        'can_manage_billing': canManageBilling,
        'is_company_admin': isCompanyAdmin,
      };
}
