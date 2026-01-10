import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'PaniMithra'**
  String get appName;

  /// No description provided for @trustedServicePartner.
  ///
  /// In en, this message translates to:
  /// **'Your Trusted Service Partner'**
  String get trustedServicePartner;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @iAmServiceProvider.
  ///
  /// In en, this message translates to:
  /// **'I am a Service Provider'**
  String get iAmServiceProvider;

  /// No description provided for @iAmUser.
  ///
  /// In en, this message translates to:
  /// **'I am a User'**
  String get iAmUser;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back 👋'**
  String get welcomeBack;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginToContinue;

  /// No description provided for @emailId.
  ///
  /// In en, this message translates to:
  /// **'Email Id'**
  String get emailId;

  /// No description provided for @enterEmailId.
  ///
  /// In en, this message translates to:
  /// **'Enter your email id'**
  String get enterEmailId;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login Successful'**
  String get loginSuccessful;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @fieldCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get fieldCannotBeEmpty;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @telugu.
  ///
  /// In en, this message translates to:
  /// **'Telugu'**
  String get telugu;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinPanimithra.
  ///
  /// In en, this message translates to:
  /// **'Join Panimithra'**
  String get joinPanimithra;

  /// No description provided for @fillDetailsToStart.
  ///
  /// In en, this message translates to:
  /// **'Fill in your details to get started'**
  String get fillDetailsToStart;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @addressDetails.
  ///
  /// In en, this message translates to:
  /// **'Address Details'**
  String get addressDetails;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'Address Line 1'**
  String get addressLine1;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get selectState;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our'**
  String get agreeToTerms;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get registrationSuccessful;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employees;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @myService.
  ///
  /// In en, this message translates to:
  /// **'My Service'**
  String get myService;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @newUsers.
  ///
  /// In en, this message translates to:
  /// **'New Users'**
  String get newUsers;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @inprogress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inprogress;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @totalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error in loading'**
  String get errorLoading;

  /// No description provided for @exploreServices.
  ///
  /// In en, this message translates to:
  /// **'Explore Services'**
  String get exploreServices;

  /// No description provided for @nearLocation.
  ///
  /// In en, this message translates to:
  /// **'Near your location'**
  String get nearLocation;

  /// No description provided for @searchServices.
  ///
  /// In en, this message translates to:
  /// **'Search for services'**
  String get searchServices;

  /// No description provided for @noServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No Services Found'**
  String get noServicesFound;

  /// No description provided for @clearAllFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear All Filters'**
  String get clearAllFilters;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @minRating.
  ///
  /// In en, this message translates to:
  /// **'Minimum Rating'**
  String get minRating;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @myDashboard.
  ///
  /// In en, this message translates to:
  /// **'My Dashboard'**
  String get myDashboard;

  /// No description provided for @performanceOverview.
  ///
  /// In en, this message translates to:
  /// **'Performance Overview'**
  String get performanceOverview;

  /// No description provided for @todaySummary.
  ///
  /// In en, this message translates to:
  /// **'Today Summary'**
  String get todaySummary;

  /// No description provided for @activeBookings.
  ///
  /// In en, this message translates to:
  /// **'Active Bookings'**
  String get activeBookings;

  /// No description provided for @earningsSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Earnings Snapshot'**
  String get earningsSnapshot;

  /// No description provided for @revenueTrend.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend'**
  String get revenueTrend;

  /// No description provided for @totalAssigned.
  ///
  /// In en, this message translates to:
  /// **'Total Assigned'**
  String get totalAssigned;

  /// No description provided for @currentMonthEarnings.
  ///
  /// In en, this message translates to:
  /// **'Current Month Earnings'**
  String get currentMonthEarnings;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @happeningToday.
  ///
  /// In en, this message translates to:
  /// **'Here\'s what\'s happening with your bookings today.'**
  String get happeningToday;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @cityAnalytics.
  ///
  /// In en, this message translates to:
  /// **'City Analytics'**
  String get cityAnalytics;

  /// No description provided for @employeeRegistrationsByCity.
  ///
  /// In en, this message translates to:
  /// **'Employee Registrations by City'**
  String get employeeRegistrationsByCity;

  /// No description provided for @bookingsByCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookings by City'**
  String get bookingsByCityTitle;

  /// No description provided for @bookingStatusOverview.
  ///
  /// In en, this message translates to:
  /// **'Booking Status Overview'**
  String get bookingStatusOverview;

  /// No description provided for @manageServiceCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Service Categories'**
  String get manageServiceCategories;

  /// No description provided for @manageSubscriptionPlans.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription Plans'**
  String get manageSubscriptionPlans;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profileSettings;

  /// No description provided for @noServicesMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find anything matching your filters.\nTry broadening your search criteria.'**
  String get noServicesMessage;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @fairEstimate.
  ///
  /// In en, this message translates to:
  /// **'FAIR ESTIMATE'**
  String get fairEstimate;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @enterValidOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 6-digit OTP'**
  String get enterValidOtp;

  /// No description provided for @otpVerified.
  ///
  /// In en, this message translates to:
  /// **'Otp Verified Successfully'**
  String get otpVerified;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to'**
  String get otpSentTo;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLengthError;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @min8Chars.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters required'**
  String get min8Chars;

  /// No description provided for @atLeastOneNumber.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one number'**
  String get atLeastOneNumber;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating ...'**
  String get updating;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit mobile number'**
  String get invalidPhoneNumber;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 123 Main St'**
  String get addressHint;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'Anytown'**
  String get cityHint;

  /// No description provided for @pincodeHint.
  ///
  /// In en, this message translates to:
  /// **'500001'**
  String get pincodeHint;

  /// No description provided for @passwordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsMismatch;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @contactProvider.
  ///
  /// In en, this message translates to:
  /// **'Contact Provider'**
  String get contactProvider;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @callProvider.
  ///
  /// In en, this message translates to:
  /// **'Call Provider'**
  String get callProvider;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @bookingCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled successfully'**
  String get bookingCancelledSuccess;

  /// No description provided for @bookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking Summary'**
  String get bookingSummary;

  /// No description provided for @bookingId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingId;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTime;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @providerInfo.
  ///
  /// In en, this message translates to:
  /// **'Provider Information'**
  String get providerInfo;

  /// No description provided for @serviceDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get serviceDetails;

  /// No description provided for @serviceItems.
  ///
  /// In en, this message translates to:
  /// **'Service Items'**
  String get serviceItems;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @serviceImages.
  ///
  /// In en, this message translates to:
  /// **'Service Images'**
  String get serviceImages;

  /// No description provided for @openingImage.
  ///
  /// In en, this message translates to:
  /// **'Opening image...'**
  String get openingImage;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get paymentDetails;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @baseService.
  ///
  /// In en, this message translates to:
  /// **'Base Service'**
  String get baseService;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get serviceFee;

  /// No description provided for @taxes.
  ///
  /// In en, this message translates to:
  /// **'Taxes'**
  String get taxes;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @cancelBookingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking? This action cannot be undone.'**
  String get cancelBookingConfirmation;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @employeeNameDefault.
  ///
  /// In en, this message translates to:
  /// **'Employee Name'**
  String get employeeNameDefault;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @supportLegal.
  ///
  /// In en, this message translates to:
  /// **'Support & Legal'**
  String get supportLegal;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @oopsSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get oopsSomethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @signOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out from your account?'**
  String get signOutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @errorLoadingBookings.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Bookings'**
  String get errorLoadingBookings;

  /// No description provided for @noBookingsFound.
  ///
  /// In en, this message translates to:
  /// **'No Bookings Found'**
  String get noBookingsFound;

  /// No description provided for @yourBookingsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your bookings will appear here'**
  String get yourBookingsWillAppearHere;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get priceHighToLow;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @errorLoadingService.
  ///
  /// In en, this message translates to:
  /// **'Error loading Service'**
  String get errorLoadingService;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get somethingWentWrong;

  /// No description provided for @startsFrom.
  ///
  /// In en, this message translates to:
  /// **'starts from'**
  String get startsFrom;

  /// No description provided for @yearsExp.
  ///
  /// In en, this message translates to:
  /// **'{value}+ years exp'**
  String yearsExp(String value);

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @aboutService.
  ///
  /// In en, this message translates to:
  /// **'About Service'**
  String get aboutService;

  /// No description provided for @whatsIncluded.
  ///
  /// In en, this message translates to:
  /// **'What\'s Included'**
  String get whatsIncluded;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @bookingCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Booking Created Successfully'**
  String get bookingCreatedSuccessfully;

  /// No description provided for @bookServiceNow.
  ///
  /// In en, this message translates to:
  /// **'Book Service Now'**
  String get bookServiceNow;

  /// No description provided for @allReviews.
  ///
  /// In en, this message translates to:
  /// **'All Reviews'**
  String get allReviews;

  /// No description provided for @errorLoadingReviews.
  ///
  /// In en, this message translates to:
  /// **'Error loading Reviews'**
  String get errorLoadingReviews;

  /// No description provided for @serviceByWithId.
  ///
  /// In en, this message translates to:
  /// **'Service by {name} • ID: {id}'**
  String serviceByWithId(String name, String id);

  /// No description provided for @noReviewsYetExclamation.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet!'**
  String get noReviewsYetExclamation;

  /// No description provided for @beFirstToShare.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your experience.'**
  String get beFirstToShare;

  /// No description provided for @checkConnectionTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get checkConnectionTryAgain;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @generalQuestions.
  ///
  /// In en, this message translates to:
  /// **'General Questions'**
  String get generalQuestions;

  /// No description provided for @noFaqsFound.
  ///
  /// In en, this message translates to:
  /// **'No FAQs found'**
  String get noFaqsFound;

  /// No description provided for @searchTopicOrQuestion.
  ///
  /// In en, this message translates to:
  /// **'Search topic or question...'**
  String get searchTopicOrQuestion;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get howCanWeHelp;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @browseFaqs.
  ///
  /// In en, this message translates to:
  /// **'Browse FAQs'**
  String get browseFaqs;

  /// No description provided for @quickAnswers.
  ///
  /// In en, this message translates to:
  /// **'Quick answers to common questions'**
  String get quickAnswers;

  /// No description provided for @getInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in Touch'**
  String get getInTouch;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get emailUs;

  /// No description provided for @supportTeam.
  ///
  /// In en, this message translates to:
  /// **'Support team'**
  String get supportTeam;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get callUs;

  /// No description provided for @tollFree.
  ///
  /// In en, this message translates to:
  /// **'Toll-free'**
  String get tollFree;

  /// No description provided for @stillNeedAssistance.
  ///
  /// In en, this message translates to:
  /// **'Still need assistance?'**
  String get stillNeedAssistance;

  /// No description provided for @teamAvailable247.
  ///
  /// In en, this message translates to:
  /// **'Our team is usually available 24/7 to help you with any issues.'**
  String get teamAvailable247;

  /// No description provided for @versionWithVal.
  ///
  /// In en, this message translates to:
  /// **'Version {value}'**
  String versionWithVal(Object value);

  /// No description provided for @empoweringExcellence.
  ///
  /// In en, this message translates to:
  /// **'Empowering Service Excellence'**
  String get empoweringExcellence;

  /// No description provided for @whoWeAre.
  ///
  /// In en, this message translates to:
  /// **'Who We Are'**
  String get whoWeAre;

  /// No description provided for @whoWeAreContent.
  ///
  /// In en, this message translates to:
  /// **'Panimithra is a next-generation workforce and service management platform designed to bridge the gap between administrators and field professionals. We leverage technology to create seamless operational workflows.'**
  String get whoWeAreContent;

  /// No description provided for @whatWeDo.
  ///
  /// In en, this message translates to:
  /// **'What We Do'**
  String get whatWeDo;

  /// No description provided for @whatWeDoContent.
  ///
  /// In en, this message translates to:
  /// **'We provide a comprehensive ecosystem for managing service requests, tracking real-time activities, and empowering service providers with data-driven insights and secure communication tools.'**
  String get whatWeDoContent;

  /// No description provided for @ourVision.
  ///
  /// In en, this message translates to:
  /// **'Our Vision'**
  String get ourVision;

  /// No description provided for @ourVisionContent.
  ///
  /// In en, this message translates to:
  /// **'To redefine the service industry by delivering a platform where efficiency meets quality, enabling professionals to focus on what they do best while we handle the operational complexity.'**
  String get ourVisionContent;

  /// No description provided for @appInformation.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInformation;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @panimithraMobile.
  ///
  /// In en, this message translates to:
  /// **'Panimithra Mobile'**
  String get panimithraMobile;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @adminManaged.
  ///
  /// In en, this message translates to:
  /// **'Admin Managed'**
  String get adminManaged;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Panimithra'**
  String get copyright;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved.'**
  String get allRightsReserved;

  /// No description provided for @secureYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Secure Your Account'**
  String get secureYourAccount;

  /// No description provided for @resetRegularlyMessage.
  ///
  /// In en, this message translates to:
  /// **'Reset your password regularly to keep your account safe.'**
  String get resetRegularlyMessage;

  /// No description provided for @reEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get reEnterNewPassword;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @bookingDate.
  ///
  /// In en, this message translates to:
  /// **'Booking Date'**
  String get bookingDate;

  /// No description provided for @confirmCancellation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancellation'**
  String get confirmCancellation;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @noInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get noInternetMessage;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error occurred. Please try again later.'**
  String get serverError;

  /// No description provided for @networkTimeout.
  ///
  /// In en, this message translates to:
  /// **'Network timeout. Please check your connection.'**
  String get networkTimeout;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again.'**
  String get sessionExpired;

  /// No description provided for @sessionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please login again.'**
  String get sessionExpiredMessage;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again'**
  String get validationError;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Data Available'**
  String get noDataAvailable;

  /// No description provided for @noDataMessage.
  ///
  /// In en, this message translates to:
  /// **'There is no data to display at the moment'**
  String get noDataMessage;

  /// No description provided for @refreshButton.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshButton;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @loadingPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Loading, please wait...'**
  String get loadingPleaseWait;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Error Occurred'**
  String get errorOccurred;

  /// No description provided for @tryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get tryAgainLater;

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'Check Connection'**
  String get checkConnection;

  /// No description provided for @connectionLost.
  ///
  /// In en, this message translates to:
  /// **'Connection Lost'**
  String get connectionLost;

  /// No description provided for @reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting...'**
  String get reconnecting;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @manageAssignedBookings.
  ///
  /// In en, this message translates to:
  /// **'Manage all your assigned service bookings here.'**
  String get manageAssignedBookings;

  /// No description provided for @bookingStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Booking status updated successfully'**
  String get bookingStatusUpdated;

  /// No description provided for @refreshList.
  ///
  /// In en, this message translates to:
  /// **'Refresh List'**
  String get refreshList;

  /// No description provided for @manageYourOfferings.
  ///
  /// In en, this message translates to:
  /// **'Manage your offerings'**
  String get manageYourOfferings;

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addService;

  /// No description provided for @noServicesOffered.
  ///
  /// In en, this message translates to:
  /// **'No services offered yet'**
  String get noServicesOffered;

  /// No description provided for @createFirstServiceMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your first service to start reaching customers and growing your business.'**
  String get createFirstServiceMessage;

  /// No description provided for @createService.
  ///
  /// In en, this message translates to:
  /// **'Create Service'**
  String get createService;

  /// No description provided for @createNewService.
  ///
  /// In en, this message translates to:
  /// **'Create New Service'**
  String get createNewService;

  /// No description provided for @serviceCreationTip.
  ///
  /// In en, this message translates to:
  /// **'Complete details to list your service. High-quality info attracts more customers!'**
  String get serviceCreationTip;

  /// No description provided for @includedItems.
  ///
  /// In en, this message translates to:
  /// **'Included Items'**
  String get includedItems;

  /// No description provided for @pricingAndTime.
  ///
  /// In en, this message translates to:
  /// **'Pricing & Time'**
  String get pricingAndTime;

  /// No description provided for @availableDays.
  ///
  /// In en, this message translates to:
  /// **'Available Days'**
  String get availableDays;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @selectSubCategory.
  ///
  /// In en, this message translates to:
  /// **'Select SubCategory'**
  String get selectSubCategory;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get serviceName;

  /// No description provided for @serviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Leaky Faucet Repair'**
  String get serviceNameHint;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the service you offer...'**
  String get descriptionHint;

  /// No description provided for @serviceLocation.
  ///
  /// In en, this message translates to:
  /// **'Service Location'**
  String get serviceLocation;

  /// No description provided for @serviceLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter service area or address'**
  String get serviceLocationHint;

  /// No description provided for @additionalInfo1.
  ///
  /// In en, this message translates to:
  /// **'Additional Info 1'**
  String get additionalInfo1;

  /// No description provided for @additionalInfo1Hint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Tools included'**
  String get additionalInfo1Hint;

  /// No description provided for @additionalInfo2.
  ///
  /// In en, this message translates to:
  /// **'Additional Info 2'**
  String get additionalInfo2;

  /// No description provided for @additionalInfo2Hint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 30 days warranty'**
  String get additionalInfo2Hint;

  /// No description provided for @additionalInfo3.
  ///
  /// In en, this message translates to:
  /// **'Additional Info 3'**
  String get additionalInfo3;

  /// No description provided for @additionalInfo3Hint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Free consultation'**
  String get additionalInfo3Hint;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price (₹)'**
  String get price;

  /// No description provided for @priceHint.
  ///
  /// In en, this message translates to:
  /// **'500'**
  String get priceHint;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @selectDuration.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectDuration;

  /// No description provided for @availabilityWindow.
  ///
  /// In en, this message translates to:
  /// **'Availability Window'**
  String get availabilityWindow;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @duration30Min.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get duration30Min;

  /// No description provided for @duration1Hour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get duration1Hour;

  /// No description provided for @duration2Hours.
  ///
  /// In en, this message translates to:
  /// **'2 hours'**
  String get duration2Hours;

  /// No description provided for @durationHalfDay.
  ///
  /// In en, this message translates to:
  /// **'Half day'**
  String get durationHalfDay;

  /// No description provided for @durationFullDay.
  ///
  /// In en, this message translates to:
  /// **'Full day'**
  String get durationFullDay;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @clickToUploadCoverImage.
  ///
  /// In en, this message translates to:
  /// **'Click to upload cover image'**
  String get clickToUploadCoverImage;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please Select Category'**
  String get pleaseSelectCategory;

  /// No description provided for @pleaseSelectSubCategory.
  ///
  /// In en, this message translates to:
  /// **'Please Select Sub Category'**
  String get pleaseSelectSubCategory;

  /// No description provided for @pleaseSelectDuration.
  ///
  /// In en, this message translates to:
  /// **'Please Select Duration'**
  String get pleaseSelectDuration;

  /// No description provided for @pleaseSelectTimings.
  ///
  /// In en, this message translates to:
  /// **'Please Select Timings'**
  String get pleaseSelectTimings;

  /// No description provided for @startTimeBeforeEndTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time must be before End Time'**
  String get startTimeBeforeEndTime;

  /// No description provided for @serviceCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service Created Successfully'**
  String get serviceCreatedSuccessfully;

  /// No description provided for @noCategoryAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Category Available'**
  String get noCategoryAvailable;

  /// No description provided for @noSubCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No SubCategories Available'**
  String get noSubCategoriesAvailable;

  /// No description provided for @editService.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get editService;

  /// No description provided for @updateService.
  ///
  /// In en, this message translates to:
  /// **'Update Service'**
  String get updateService;

  /// No description provided for @serviceUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service Updated Successfully'**
  String get serviceUpdatedSuccessfully;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
