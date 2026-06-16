class CompanyModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String website;
  final String industry;
  final String size;
  final String status; // pending | approved | rejected | suspended
  final String? logoUrl;
  final String? description;
  final String adminUserId;
  final String billingEmail;
  final String? taxId;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final int memberCount;
  final double monthlySpend;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.industry,
    required this.size,
    required this.status,
    this.logoUrl,
    this.description,
    required this.adminUserId,
    required this.billingEmail,
    this.taxId,
    required this.createdAt,
    this.approvedAt,
    this.rejectionReason,
    this.memberCount = 0,
    this.monthlySpend = 0,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String? ?? '',
        website: json['website'] as String? ?? '',
        industry: json['industry'] as String? ?? '',
        size: json['size'] as String? ?? '',
        status: json['status'] as String,
        logoUrl: json['logo_url'] as String?,
        description: json['description'] as String?,
        adminUserId: json['admin_user_id'] as String,
        billingEmail:
            json['billing_email'] as String? ?? json['email'] as String,
        taxId: json['tax_id'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        approvedAt: json['approved_at'] != null
            ? DateTime.parse(json['approved_at'] as String)
            : null,
        rejectionReason: json['rejection_reason'] as String?,
        memberCount: json['member_count'] as int? ?? 0,
        monthlySpend: (json['monthly_spend'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'website': website,
        'industry': industry,
        'size': size,
        'status': status,
        'logo_url': logoUrl,
        'description': description,
        'admin_user_id': adminUserId,
        'billing_email': billingEmail,
        'tax_id': taxId,
        'created_at': createdAt.toIso8601String(),
        'approved_at': approvedAt?.toIso8601String(),
        'rejection_reason': rejectionReason,
        'member_count': memberCount,
        'monthly_spend': monthlySpend,
      };

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isSuspended => status == 'suspended';

  String get initials {
    final words = name.trim().split(' ');
    if (words.length >= 2) return '${words[0][0]}${words[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'C';
  }

  CompanyModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? website,
    String? industry,
    String? size,
    String? status,
    String? logoUrl,
    String? description,
    String? adminUserId,
    String? billingEmail,
    String? taxId,
    DateTime? createdAt,
    DateTime? approvedAt,
    String? rejectionReason,
    int? memberCount,
    double? monthlySpend,
  }) =>
      CompanyModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        website: website ?? this.website,
        industry: industry ?? this.industry,
        size: size ?? this.size,
        status: status ?? this.status,
        logoUrl: logoUrl ?? this.logoUrl,
        description: description ?? this.description,
        adminUserId: adminUserId ?? this.adminUserId,
        billingEmail: billingEmail ?? this.billingEmail,
        taxId: taxId ?? this.taxId,
        createdAt: createdAt ?? this.createdAt,
        approvedAt: approvedAt ?? this.approvedAt,
        rejectionReason: rejectionReason ?? this.rejectionReason,
        memberCount: memberCount ?? this.memberCount,
        monthlySpend: monthlySpend ?? this.monthlySpend,
      );
}

class Department {
  final String id;
  final String companyId;
  final String name;
  final String? managerId;
  final int memberCount;

  const Department({
    required this.id,
    required this.companyId,
    required this.name,
    this.managerId,
    this.memberCount = 0,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json['id'] as String,
        companyId: json['company_id'] as String,
        name: json['name'] as String,
        managerId: json['manager_id'] as String?,
        memberCount: json['member_count'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_id': companyId,
        'name': name,
        'manager_id': managerId,
        'member_count': memberCount,
      };
}
