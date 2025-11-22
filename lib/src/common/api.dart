// ignore_for_file: constant_identifier_names

import 'flavor_config.dart';

class API {
  static const BASE_URL = 'http://192.168.1.120:8080';
  //static String BASE_URL = FlavourConfig.instance.baseUrl;

  // Authentication
  static String LOGIN = '$BASE_URL/auth/login';
  static String REGISTER_PROVIDER = '$BASE_URL/auth/create-user';
  static String FORGOT_PASSWORD = '$BASE_URL/v1/auth/password/forgot';
  static String RESET_PASSWORD = '$BASE_URL/v1/profile/password';
  static String CHANGE_PASSWORD = '$BASE_URL/v1/auth/password/reset';
  static String REFRESH_TOKEN = '$BASE_URL/refresh_token';
  static String ACTIVATE_USERS = '$BASE_URL/v1/users';
  static String SITE_MANAGERS = '$BASE_URL/v1/users';
  static String PIN_CODE_API = 'http://www.postalpincode.in/api/pincode';
  static String FILE_UPLOAD = '$BASE_URL/v1/files';
  static String INACTIVE_USERS = '$BASE_URL/v1/users/inactive';

  static String EMPLOYEE = '$BASE_URL/v1/employees';
  static String SITE_MANAGER_STATS = '$BASE_URL/v1/users/stats';
  static String USER_PROFILE = '$BASE_URL/v1/profile';
  static String ADD_SERVICES = '$BASE_URL/v1/services';
  static String SERVICES = '$BASE_URL/v1/services';
  static String SITES = '$BASE_URL/v1/sites';
  static String MATERIALS = '$BASE_URL/v1/material';
  static String ASSIGN_MATERIALS = '$BASE_URL/v1/site-material';
  static String CONSTRUCTIONS = '$BASE_URL/v1/site-material';

  static String PUNCH_IN = '$BASE_URL/v1/attendance/punch';
  static String GET_PUNCH_IN_TIME = '$BASE_URL/v1/attendance/status';
  static String SAVE_TOKEN = "$BASE_URL/v1/users/token";
  static String NOTIFICATIONS_LIST = '$BASE_URL/v1/notification';
  static String SITE_EMPLOYEE = "$BASE_URL/v1/siteemployee";
  static String DAILY_TRACKER = "$BASE_URL/v1/site-services";
  static String PAYROLL = '$BASE_URL/v1/payroll';
  static String SITE_EMPLOYEE_DATE = "$BASE_URL/v1/employees/available";
  static String DIRECTOR_EXPENSE_OVERVIEW = "$BASE_URL/v1/home";
  static String LABOUR_SALARY_BY_MONTH_API = "$BASE_URL/v1/home/labour/month";
  static String FIND_EMPLOYEE_REPORTS = "$BASE_URL/v1/employees/joining";
  static String DOWNLOAD_EXCEL_API = "$BASE_URL/v1/reports/employee";
// Append service ID
}
