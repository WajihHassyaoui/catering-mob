class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.plattercatering.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String registerClient = '/auth/register/client';
  static const String registerCompany = '/auth/register/company';
  static const String forgotPassword = '/auth/forgot-password';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String refreshToken = '/auth/refresh';

  // Client — Meals
  static const String meals = '/meals';
  static String mealById(String id) => '/meals/$id';
  static const String mealCategories = '/meals/categories';

  // Client — Orders
  static const String myOrders = '/orders/my';
  static const String createOrder = '/orders';
  static String orderById(String id) => '/orders/$id';
  static String cancelOrder(String id) => '/orders/$id/cancel';

  // Client — Group Orders
  static const String myGroupOrders = '/group-orders/my';
  static const String joinGroupOrder = '/group-orders/join';
  static String groupOrderById(String id) => '/group-orders/$id';
  static String submitGroupOrderItems(String id) => '/group-orders/$id/items';

  // Client — Meal Prep
  static const String myMealPrep = '/meal-prep/my';

  // Client — Catering Requests
  static const String createCateringRequest = '/catering-requests';

  // Client — Notifications
  static const String notifications = '/notifications';
  static String markNotificationRead(String id) => '/notifications/$id/read';

  // Client — Favorites
  static const String favorites = '/favorites';
  static String toggleFavorite(String mealId) => '/favorites/$mealId';

  // Company
  static const String companyDashboard = '/company/dashboard';
  static const String companyProfile = '/company/profile';

  // Company — Members
  static const String companyMembers = '/company/members';
  static const String inviteMember = '/company/members/invite';
  static String memberById(String id) => '/company/members/$id';
  static String updateMemberPermissions(String id) =>
      '/company/members/$id/permissions';
  static String removeMember(String id) => '/company/members/$id';

  // Company — Departments
  static const String departments = '/company/departments';
  static String departmentById(String id) => '/company/departments/$id';

  // Company — Group Orders
  static const String companyGroupOrders = '/company/group-orders';
  static String companyGroupOrderById(String id) => '/company/group-orders/$id';
  static String reviewGroupOrder(String id) =>
      '/company/group-orders/$id/review';

  // Company — Catering
  static const String companyCateringRequests = '/company/catering-requests';
  static String companyCateringById(String id) =>
      '/company/catering-requests/$id';

  // Company — Meal Prep
  static const String companyMealPrep = '/company/meal-prep';
  static String companyMealPrepById(String id) => '/company/meal-prep/$id';

  // Company — Orders
  static const String companyOrders = '/company/orders';

  // Company — Billing
  static const String companyInvoices = '/company/invoices';
  static String invoiceById(String id) => '/company/invoices/$id';
  static const String companyReports = '/company/reports';

  // Admin — Dashboard
  static const String adminDashboard = '/admin/dashboard';

  // Admin — Companies
  static const String adminCompanies = '/admin/companies';
  static String approveCompany(String id) => '/admin/companies/$id/approve';
  static String rejectCompany(String id) => '/admin/companies/$id/reject';
  static String suspendCompany(String id) => '/admin/companies/$id/suspend';

  // Admin — Clients
  static const String adminClients = '/admin/clients';
  static String adminClientById(String id) => '/admin/clients/$id';

  // Admin — Meals
  static const String adminMeals = '/admin/meals';
  static String adminMealById(String id) => '/admin/meals/$id';

  // Admin — Catering Packages
  static const String adminCateringPackages = '/admin/catering-packages';
  static String adminCateringPackageById(String id) =>
      '/admin/catering-packages/$id';

  // Admin — Meal Prep Packages
  static const String adminMealPrepPackages = '/admin/meal-prep-packages';
  static String adminMealPrepPackageById(String id) =>
      '/admin/meal-prep-packages/$id';

  // Admin — Orders
  static const String adminOrders = '/admin/orders';
  static String adminOrderById(String id) => '/admin/orders/$id';

  // Admin — Group Orders
  static const String adminGroupOrders = '/admin/group-orders';
  static String adminGroupOrderById(String id) => '/admin/group-orders/$id';

  // Admin — Catering Requests
  static const String adminCateringRequests = '/admin/catering-requests';
  static String adminCateringRequestById(String id) =>
      '/admin/catering-requests/$id';
  static String updateCateringRequestStatus(String id) =>
      '/admin/catering-requests/$id/status';

  // Admin — Payments & Invoices
  static const String adminPayments = '/admin/payments';
  static const String adminInvoices = '/admin/invoices';

  // Admin — Reports
  static const String adminReports = '/admin/reports';

  // Admin — Settings
  static const String adminSettings = '/admin/settings';

  // Admin — Categories
  static const String adminCategories = '/admin/categories';
}
