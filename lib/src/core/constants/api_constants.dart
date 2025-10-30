class ApiConstants {
  static const String baseUrl = 'http://localhost:8080';
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

  static const String apiKey = 'YOUR_API_KEY_HERE';
  static const String token = "token";
  static const String userId = "userId";
  static const String userName = "user_name";
  static const String emailId = "email_id";
  static const String role = "huvg";
  static const Duration timeout = Duration(seconds: 30);
}
