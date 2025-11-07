class ApiConstants {
  static const String baseUrl = 'http://localhost:8080';
  //static const String baseUrl = "https://panimithra.onrender.com";
  static const String login = '$baseUrl/auth/login';
  static const String registration = "/auth/create-user";
  static const String fetchCategoryApi = "$baseUrl/categories/fetch-category";

  static const String createCategoryApi = "$baseUrl/categories/create-category";
  static const String fetchSubCategories =
      "$baseUrl/subcategory/fetch-sub-category";
  static const String createSubCategoryApi =
      "$baseUrl/subcategory/create-subcategory";
  static const String fetchService = "$baseUrl/service/getAllService";
  static const String createService = "/service/create-service";
  static const String findServiceScreen = "/service/find-service";
  static const String searchService = "/service/search";
  static const String createSubscriptionPlanApi = "$baseUrl/auth/plan-creation";
  static const String fetchPlanApi = "$baseUrl/auth/fetch-plans";
  static const String fetchUsers = "$baseUrl/auth/getAllUsers";
  static const String fetchEmployeePlans = "$baseUrl/subcription/employee-plan";
  static const String orderCreationApi = "$baseUrl/payments/checkout";

  static const String getServiceById = "$baseUrl/service/getServiceById";
  static const String createBooking = "$baseUrl/bookings/create";
  static const String fetchBookings = "$baseUrl/bookings/fetch-bookings";
  static const String updateBookingStatus = "$baseUrl/bookings/update-booking";
  static const String addReviewApi = "$baseUrl/review/create-review";
  static const String topFiveRatings = "$baseUrl/review/top-ratings";
  static const String bookingsById = "$baseUrl/bookings/booking-byid";

  static const String apiKey = 'YOUR_API_KEY_HERE';
  static const String token = "token";
  static const String userId = "userId";
  static const String userName = "user_name";
  static const String emailId = "email_id";
  static const String role = "huvg";
  static const Duration timeout = Duration(seconds: 30);
}
