import '../models/user_model.dart';
import '../models/company_model.dart';
import '../models/order_model.dart';
import '../models/group_order_model.dart';
import '../models/catering_request_model.dart';
import '../models/invoice_model.dart';

class MockData {
  // ── Users ──────────────────────────────────────────────────────────────────

  static final UserModel clientUser = UserModel(
    id: 'u_client_1',
    email: 'alex.morgan@email.com',
    fullName: 'Alex Morgan',
    phone: '+1 (555) 234-5678',
    role: 'client',
    companyId: 'co_1',
    isEmailVerified: true,
    createdAt: DateTime(2024, 3, 10),
  );

  static final UserModel companyUser = UserModel(
    id: 'u_company_1',
    email: 'admin@techflow.com',
    fullName: 'Jordan Lee',
    phone: '+1 (555) 987-6543',
    role: 'company',
    companyId: 'co_1',
    isEmailVerified: true,
    createdAt: DateTime(2024, 2, 5),
  );

  static final UserModel adminUser = UserModel(
    id: 'u_admin_1',
    email: 'admin@plattercatering.com',
    fullName: 'Sarah Chen',
    phone: '+1 (555) 100-2000',
    role: 'admin',
    isEmailVerified: true,
    createdAt: DateTime(2024, 1, 1),
  );

  // ── Companies ─────────────────────────────────────────────────────────────

  static final CompanyModel approvedCompany = CompanyModel(
    id: 'co_1',
    name: 'TechFlow Solutions',
    email: 'admin@techflow.com',
    phone: '+1 (555) 987-6543',
    website: 'https://techflow.com',
    industry: 'Technology',
    size: '51–200 employees',
    status: 'approved',
    adminUserId: 'u_company_1',
    billingEmail: 'billing@techflow.com',
    taxId: 'EIN-12-3456789',
    createdAt: DateTime(2024, 2, 5),
    approvedAt: DateTime(2024, 2, 7),
    memberCount: 48,
    monthlySpend: 6240.00,
  );

  static final CompanyModel pendingCompany = CompanyModel(
    id: 'co_2',
    name: 'Green Leaf Media',
    email: 'team@greenleaf.io',
    phone: '+1 (555) 444-3333',
    website: 'https://greenleaf.io',
    industry: 'Media & Marketing',
    size: '11–50 employees',
    status: 'pending',
    adminUserId: 'u_company_2',
    billingEmail: 'finance@greenleaf.io',
    createdAt: DateTime(2024, 6, 1),
    memberCount: 18,
    monthlySpend: 0,
  );

  static final List<CompanyModel> allCompanies = [
    approvedCompany,
    pendingCompany,
    CompanyModel(
      id: 'co_3',
      name: 'Apex Financial Group',
      email: 'ops@apexfin.com',
      phone: '+1 (555) 222-1111',
      website: 'https://apexfin.com',
      industry: 'Finance',
      size: '201–500 employees',
      status: 'approved',
      adminUserId: 'u_company_3',
      billingEmail: 'billing@apexfin.com',
      taxId: 'EIN-98-7654321',
      createdAt: DateTime(2024, 1, 20),
      approvedAt: DateTime(2024, 1, 22),
      memberCount: 127,
      monthlySpend: 18500.00,
    ),
  ];

  // ── Company Members ────────────────────────────────────────────────────────

  static final List<CompanyMember> members = [
    CompanyMember(
      id: 'mem_1',
      userId: 'u_client_1',
      companyId: 'co_1',
      fullName: 'Alex Morgan',
      email: 'alex.morgan@techflow.com',
      phone: '+1 (555) 234-5678',
      department: 'Engineering',
      roleInCompany: 'Senior Engineer',
      spendingLimit: 150.0,
      permissions: const MemberPermissions(
        canJoinGroupOrders: true,
        canPlaceIndividualOrders: true,
      ),
      status: 'active',
      joinedAt: DateTime(2024, 3, 10),
    ),
    CompanyMember(
      id: 'mem_2',
      userId: 'u_2',
      companyId: 'co_1',
      fullName: 'Priya Sharma',
      email: 'priya.sharma@techflow.com',
      phone: '+1 (555) 345-6789',
      department: 'Product',
      roleInCompany: 'Product Manager',
      spendingLimit: 200.0,
      permissions: const MemberPermissions(
        canJoinGroupOrders: true,
        canCreateGroupOrders: true,
        canPlaceIndividualOrders: true,
      ),
      status: 'active',
      joinedAt: DateTime(2024, 3, 15),
    ),
    CompanyMember(
      id: 'mem_3',
      userId: 'u_3',
      companyId: 'co_1',
      fullName: 'Marcus Williams',
      email: 'marcus.w@techflow.com',
      phone: '+1 (555) 456-7890',
      department: 'Design',
      roleInCompany: 'UX Designer',
      spendingLimit: 100.0,
      permissions: const MemberPermissions(
        canJoinGroupOrders: true,
        canPlaceIndividualOrders: true,
      ),
      status: 'active',
      joinedAt: DateTime(2024, 4, 2),
    ),
    CompanyMember(
      id: 'mem_4',
      userId: 'u_4',
      companyId: 'co_1',
      fullName: 'Sofia Rodriguez',
      email: 'sofia.r@techflow.com',
      phone: '+1 (555) 567-8901',
      department: 'Marketing',
      roleInCompany: 'Marketing Lead',
      spendingLimit: null,
      permissions: const MemberPermissions(
        canJoinGroupOrders: true,
        canCreateGroupOrders: true,
        canPlaceIndividualOrders: true,
        canRequestCatering: true,
        isCompanyAdmin: true,
      ),
      status: 'active',
      joinedAt: DateTime(2024, 2, 8),
    ),
    CompanyMember(
      id: 'mem_5',
      userId: 'u_5',
      companyId: 'co_1',
      fullName: 'Daniel Kim',
      email: 'daniel.kim@techflow.com',
      phone: '+1 (555) 678-9012',
      department: 'Engineering',
      roleInCompany: 'DevOps Engineer',
      spendingLimit: 120.0,
      permissions: const MemberPermissions(
        canJoinGroupOrders: true,
        canPlaceIndividualOrders: true,
      ),
      status: 'invited',
      joinedAt: DateTime(2024, 6, 10),
    ),
  ];

  // ── Orders ─────────────────────────────────────────────────────────────────

  static final List<OrderModel> orders = [
    OrderModel(
      id: 'ord_1',
      orderNumber: 'PLT-2024-0047',
      userId: 'u_client_1',
      companyId: 'co_1',
      companyName: 'TechFlow Solutions',
      items: [
        const OrderItem(
          id: 'oi_1',
          mealId: 'm_1',
          mealName: 'Mediterranean Grain Bowl',
          unitPrice: 16.50,
          quantity: 2,
        ),
        const OrderItem(
          id: 'oi_2',
          mealId: 'm_12',
          mealName: 'Cold Brew Coffee',
          unitPrice: 6.00,
          quantity: 2,
        ),
      ],
      status: 'out_for_delivery',
      deliveryAddress:
          '150 Tech Park Drive, Suite 400, San Francisco, CA 94105',
      deliveryDate: DateTime.now().add(const Duration(hours: 1)),
      deliveryTime: '12:30 PM',
      subtotal: 45.00,
      deliveryFee: 5.00,
      tax: 4.50,
      total: 54.50,
      paymentMethod: 'invoice',
      paymentStatus: 'pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      statusHistory: [
        OrderStatusEvent(
          status: 'pending',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        OrderStatusEvent(
          status: 'confirmed',
          timestamp:
              DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        ),
        OrderStatusEvent(
          status: 'preparing',
          timestamp:
              DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        ),
        OrderStatusEvent(
          status: 'out_for_delivery',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        ),
      ],
    ),
    OrderModel(
      id: 'ord_2',
      orderNumber: 'PLT-2024-0039',
      userId: 'u_client_1',
      companyId: 'co_1',
      companyName: 'TechFlow Solutions',
      items: [
        const OrderItem(
          id: 'oi_3',
          mealId: 'm_2',
          mealName: 'Herb-Crusted Salmon',
          unitPrice: 24.00,
          quantity: 1,
        ),
        const OrderItem(
          id: 'oi_4',
          mealId: 'm_6',
          mealName: 'Roasted Tomato Bisque',
          unitPrice: 10.00,
          quantity: 1,
        ),
      ],
      status: 'delivered',
      deliveryAddress:
          '150 Tech Park Drive, Suite 400, San Francisco, CA 94105',
      deliveryDate: DateTime.now().subtract(const Duration(days: 3)),
      deliveryTime: '1:00 PM',
      subtotal: 34.00,
      deliveryFee: 5.00,
      tax: 3.40,
      total: 42.40,
      paymentMethod: 'invoice',
      paymentStatus: 'paid',
      createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 3)),
      statusHistory: [
        OrderStatusEvent(
          status: 'pending',
          timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 3)),
        ),
        OrderStatusEvent(
          status: 'confirmed',
          timestamp: DateTime.now()
              .subtract(const Duration(days: 3, hours: 2, minutes: 45)),
        ),
        OrderStatusEvent(
          status: 'delivered',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    ),
  ];

  // ── Group Orders ───────────────────────────────────────────────────────────

  static final List<GroupOrder> groupOrders = [
    GroupOrder(
      id: 'go_1',
      name: 'Wednesday Team Lunch',
      creatorId: 'u_company_1',
      creatorName: 'Jordan Lee',
      companyId: 'co_1',
      companyName: 'TechFlow Solutions',
      status: 'open',
      menuPackageName: 'Mediterranean Selection',
      deliveryAddress: '150 Tech Park Drive, Suite 400',
      deliveryDate: DateTime.now().add(const Duration(days: 2)),
      deliveryTime: '12:00 PM',
      orderDeadline: DateTime.now().add(const Duration(days: 1, hours: 16)),
      joinCode: 'TECH-LUNCH-42',
      participantCount: 12,
      maxParticipants: 30,
      participants: [
        GroupOrderParticipant(
          id: 'p_1',
          userId: 'u_client_1',
          userName: 'Alex Morgan',
          department: 'Engineering',
          hasSubmitted: true,
          submittedAt: DateTime.now().subtract(const Duration(hours: 4)),
          mealSelections: const [
            GroupOrderMealSelection(
              mealId: 'm_1',
              mealName: 'Mediterranean Grain Bowl',
              quantity: 1,
              unitPrice: 16.50,
            ),
          ],
        ),
        GroupOrderParticipant(
          id: 'p_2',
          userId: 'u_2',
          userName: 'Priya Sharma',
          department: 'Product',
          hasSubmitted: true,
          submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
          mealSelections: const [
            GroupOrderMealSelection(
              mealId: 'm_8',
              mealName: 'Vegan Buddha Bowl',
              quantity: 1,
              unitPrice: 15.50,
            ),
          ],
        ),
        const GroupOrderParticipant(
          id: 'p_3',
          userId: 'u_3',
          userName: 'Marcus Williams',
          department: 'Design',
          hasSubmitted: false,
        ),
      ],
      estimatedTotal: 198.00,
      paymentMethod: 'invoice',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    GroupOrder(
      id: 'go_2',
      name: 'Friday Engineering All-Hands',
      creatorId: 'u_company_1',
      creatorName: 'Jordan Lee',
      companyId: 'co_1',
      companyName: 'TechFlow Solutions',
      status: 'confirmed',
      menuPackageName: 'Premium Buffet',
      deliveryAddress: '150 Tech Park Drive, Main Conference Room',
      deliveryDate: DateTime.now().add(const Duration(days: 5)),
      deliveryTime: '11:45 AM',
      orderDeadline: DateTime.now().add(const Duration(days: 3)),
      joinCode: 'ENG-ALLHANDS-05',
      participantCount: 28,
      maxParticipants: 30,
      estimatedTotal: 812.00,
      paymentMethod: 'invoice',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  // ── Catering Requests ──────────────────────────────────────────────────────

  static final List<CateringRequest> cateringRequests = [
    CateringRequest(
      id: 'cr_1',
      companyId: 'co_1',
      companyName: 'TechFlow Solutions',
      userId: 'u_company_1',
      contactPerson: 'Jordan Lee',
      workEmail: 'jordan@techflow.com',
      phone: '+1 (555) 987-6543',
      eventType: 'Product Launch',
      eventDate: DateTime.now().add(const Duration(days: 21)),
      eventTime: '6:00 PM',
      eventLocation: '150 Tech Park Drive, Main Hall, San Francisco, CA',
      numberOfGuests: 85,
      packageId: 'cp_4',
      packageName: 'Corporate Gala Dinner',
      dietaryRestrictions: ['Vegetarian', 'Gluten-Free', 'Halal'],
      serviceType: 'Full-Service Catering',
      budgetRange: '\$5,000 – \$10,000',
      specialRequests:
          'We need branded table setups with our company colors (navy and gold). Please accommodate a separate vegan station.',
      status: 'quoted',
      quotedPrice: 8075.00,
      adminNotes:
          'Quoted for 85 guests at \$95/person. Includes branded table setup at no extra charge.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      respondedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    CateringRequest(
      id: 'cr_2',
      companyId: 'co_1',
      companyName: 'TechFlow Solutions',
      userId: 'u_company_1',
      contactPerson: 'Jordan Lee',
      workEmail: 'jordan@techflow.com',
      phone: '+1 (555) 987-6543',
      eventType: 'Team Lunch',
      eventDate: DateTime.now().subtract(const Duration(days: 10)),
      eventTime: '12:00 PM',
      eventLocation: '150 Tech Park Drive, Suite 400',
      numberOfGuests: 35,
      packageId: 'cp_2',
      packageName: 'Team Celebration Buffet',
      dietaryRestrictions: ['Vegetarian'],
      serviceType: 'Delivery + Setup',
      budgetRange: '\$1,000 – \$2,500',
      status: 'completed',
      quotedPrice: 1120.00,
      createdAt: DateTime.now().subtract(const Duration(days: 18)),
      respondedAt: DateTime.now().subtract(const Duration(days: 16)),
    ),
  ];

  // ── Invoices ───────────────────────────────────────────────────────────────

  static final List<InvoiceModel> invoices = [
    InvoiceModel(
      id: 'inv_1',
      invoiceNumber: 'INV-2024-0082',
      companyId: 'co_1',
      companyName: 'TechFlow Solutions',
      groupOrderId: 'go_2',
      invoiceType: 'group_order',
      lineItems: [
        const InvoiceLineItem(
          description: 'Friday Engineering All-Hands — 28 participants',
          quantity: 28,
          unitPrice: 29.00,
          total: 812.00,
        ),
        const InvoiceLineItem(
          description: 'Delivery & Setup Fee',
          quantity: 1,
          unitPrice: 45.00,
          total: 45.00,
        ),
      ],
      subtotal: 857.00,
      tax: 85.70,
      total: 942.70,
      status: 'pending',
      issuedAt: DateTime.now().subtract(const Duration(days: 2)),
      dueDate: DateTime.now().add(const Duration(days: 28)),
    ),
    InvoiceModel(
      id: 'inv_2',
      invoiceNumber: 'INV-2024-0071',
      companyId: 'co_1',
      companyName: 'TechFlow Solutions',
      cateringRequestId: 'cr_2',
      invoiceType: 'catering',
      lineItems: [
        const InvoiceLineItem(
          description: 'Team Celebration Buffet — 35 guests',
          quantity: 35,
          unitPrice: 32.00,
          total: 1120.00,
        ),
      ],
      subtotal: 1120.00,
      tax: 112.00,
      total: 1232.00,
      status: 'paid',
      issuedAt: DateTime.now().subtract(const Duration(days: 12)),
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      paidAt: DateTime.now().subtract(const Duration(days: 5)),
      paymentReference: 'ACH-TF-20240601',
    ),
  ];

  // ── Meal Prep Plans ────────────────────────────────────────────────────────

  static final List<MealPrepPlan> mealPrepPlans = [
    MealPrepPlan(
      id: 'mpp_1',
      name: 'Engineering Team — Weekly Lunch',
      companyId: 'co_1',
      companyName: 'TechFlow Solutions',
      creatorId: 'u_company_1',
      packageId: 'mp_1',
      packageName: 'Weekly Office Lunch Plan',
      duration: '4 Weeks',
      mealsPerDay: 1,
      includesLunch: true,
      dietaryPreferences: ['Standard', 'Vegetarian'],
      deliveryDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      deliveryAddress: '150 Tech Park Drive, Suite 400',
      budget: 5200.00,
      assignedEmployeeIds: ['mem_1', 'mem_2', 'mem_3', 'mem_5'],
      status: 'active',
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 21)),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      nextDelivery: DateTime.now().add(const Duration(days: 1)),
    ),
  ];

  // ── Notifications ──────────────────────────────────────────────────────────

  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif_1',
      userId: 'u_client_1',
      title: 'Order On Its Way! 🚚',
      body:
          'Your order PLT-2024-0047 is out for delivery. Estimated arrival: 12:30 PM.',
      type: 'order',
      referenceId: 'ord_1',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    NotificationModel(
      id: 'notif_2',
      userId: 'u_client_1',
      title: 'Group Order Reminder',
      body:
          'Don\'t forget to submit your meal selection for Wednesday Team Lunch. Deadline in 32 hours.',
      type: 'group_order',
      referenceId: 'go_1',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'notif_3',
      userId: 'u_client_1',
      title: 'Meal Prep Delivery Tomorrow',
      body:
          'Your weekly lunch plan delivery is scheduled for tomorrow. Check your plan for details.',
      type: 'meal_prep',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      id: 'notif_4',
      userId: 'u_company_1',
      title: 'Catering Quote Ready',
      body:
          'Your corporate catering request for the Product Launch has been quoted at \$8,075.',
      type: 'catering',
      referenceId: 'cr_1',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NotificationModel(
      id: 'notif_5',
      userId: 'u_company_1',
      title: 'New Invoice Issued',
      body:
          'Invoice INV-2024-0082 for \$942.70 has been issued. Due in 30 days.',
      type: 'invoice',
      referenceId: 'inv_1',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
}
