class ApiConstants {
  static const String baseUrl = 'http://192.168.1.120:8080';
  //static const String baseUrl = 'https://cf377302fb18.ngrok-free.app';
  //static const String baseUrl ='https://panimithra-564205773146.us-central1.run.app';

  // static const String baseUrl = "https://panimithra.onrender.com";
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
  static const String fetchAllReviews = "$baseUrl/review/fetch-all-reviews";
  static const String fetchUserProfile = "$baseUrl/auth/user-profile";
  static const String fetchAdminDashboardApi =
      "$baseUrl/dashboard/admin-dashboard";
  static const String deletePlanApi = "$baseUrl/auth/delete-plan";
  static const String fetchEmployeeDashboardApi =
      "$baseUrl/dashboard/employee-dashboard";

  static const String deleteSubCategoryApi =
      "$baseUrl/subcategory/delete-sub-category";

  static const String updateServiceApi = "$baseUrl/service/update-service";

  static const String registerToken = "$baseUrl/auth/register-token";

  static const String deleteCategoryApi = "$baseUrl/categories/delte-category";

  static const String fetchCategoryByIdApi =
      "$baseUrl/categories/fetch-category-by-id";
  static const String fetchSubCategoryByIdApi =
      "$baseUrl/subcategory/fetch-subcategory-by-id";
  static const String updateCategoryApi = "$baseUrl/categories/update-category";
  static const String updateSubCategoryApi =
      "$baseUrl/subcategory/update-subcategory";
  static const String changeUserStatusApi = "$baseUrl/auth/change-user-status";

  static const String updatePaymentStatusApi =
      "$baseUrl/bookings/update-payment-status";

  static const String claudinaryBaseUrl = "https://api.cloudinary.com/v1_1";
  static const String fetchPlanById = "$baseUrl/auth/get-plan";
  static const String updatePlan = "$baseUrl/auth/update-plan";
  static const String gcpApi = "$baseUrl/api/files/upload";

  static const String faqApi = "$baseUrl/auth/faq";
  static const String apiKey = 'YOUR_API_KEY_HERE';
  static const String token = "token";
  static const String userId = "userId";
  static const String userName = "user_name";
  static const String emailId = "email_id";
  static const String role = "huvg";
  static const String latitude = "lat";
  static const String longitude = "long";
  static const Duration timeout = Duration(seconds: 30);

  static const presetName = "my_unsigned_preset";
  static const cloudName = "dwtslw4zt";
  static const clientSecret = "hVf6qLazJ1SuAmVfKoQ3IbUESGI";

  static const folderName = "my_photos";
}
