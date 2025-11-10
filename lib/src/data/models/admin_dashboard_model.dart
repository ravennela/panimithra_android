// To parse this JSON data, do
//
//     final adminDashboardModel = adminDashboardModelFromJson(jsonString);

import 'dart:convert';

AdminDashboardModel adminDashboardModelFromJson(String str) =>
    AdminDashboardModel.fromJson(json.decode(str));

String adminDashboardModelToJson(AdminDashboardModel data) =>
    json.encode(data.toJson());

class AdminDashboardModel {
  int? currentMonthUsers;
  int? previousMonthuser;
  int? currentMonthEmployees;
  int? previousMonthEmployees;
  int? totalBookingsCompleted;
  int? totalBookingsPending;
  int? totalBookinsCancelled;
  double? revenue;
  int? totalBookings;
  int? pendingBookings;
  int? completedBookings;
  int? cancelledBookings;
  int? rejectedBookings;
  int? inporgressBookings;
  int? completedBookingsByPreviousMonth;
  int? pendingdBookingsByPreviouMonth;
  List<City>? cityBookings;
  List<City>? cityEmployee;
  int? totalBookingsRejected;

  AdminDashboardModel({
    this.currentMonthUsers,
    this.previousMonthuser,
    this.currentMonthEmployees,
    this.previousMonthEmployees,
    this.totalBookingsCompleted,
    this.totalBookingsPending,
    this.totalBookinsCancelled,
    this.revenue,
    this.totalBookings,
    this.pendingBookings,
    this.completedBookings,
    this.cancelledBookings,
    this.rejectedBookings,
    this.inporgressBookings,
    this.completedBookingsByPreviousMonth,
    this.pendingdBookingsByPreviouMonth,
    this.cityBookings,
    this.cityEmployee,
    this.totalBookingsRejected,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) =>
      AdminDashboardModel(
        currentMonthUsers: json["currentMonthUsers"],
        previousMonthuser: json["previousMonthuser"],
        currentMonthEmployees: json["currentMonthEmployees"],
        previousMonthEmployees: json["previousMonthEmployees"],
        totalBookingsCompleted: json["totalBookingsCompleted"],
        totalBookingsPending: json["totalBookingsPending"],
        totalBookinsCancelled: json["totalBookinsCancelled"],
        revenue: json["revenue"]?.toDouble(),
        totalBookings: json["totalBookings"],
        pendingBookings: json["pendingBookings"],
        completedBookings: json["completedBookings"],
        cancelledBookings: json["cancelledBookings"],
        rejectedBookings: json["rejectedBookings"],
        inporgressBookings: json["inporgressBookings"],
        completedBookingsByPreviousMonth:
            json["completedBookingsByPreviousMonth"],
        pendingdBookingsByPreviouMonth: json["pendingdBookingsByPreviouMonth"],
        cityBookings: json["cityBookings"] == null
            ? []
            : List<City>.from(
                json["cityBookings"]!.map((x) => City.fromJson(x))),
        cityEmployee: json["cityEmployee"] == null
            ? []
            : List<City>.from(
                json["cityEmployee"]!.map((x) => City.fromJson(x))),
        totalBookingsRejected: json["totalBookingsRejected"],
      );

  Map<String, dynamic> toJson() => {
        "currentMonthUsers": currentMonthUsers,
        "previousMonthuser": previousMonthuser,
        "currentMonthEmployees": currentMonthEmployees,
        "previousMonthEmployees": previousMonthEmployees,
        "totalBookingsCompleted": totalBookingsCompleted,
        "totalBookingsPending": totalBookingsPending,
        "totalBookinsCancelled": totalBookinsCancelled,
        "revenue": revenue,
        "totalBookings": totalBookings,
        "pendingBookings": pendingBookings,
        "completedBookings": completedBookings,
        "cancelledBookings": cancelledBookings,
        "rejectedBookings": rejectedBookings,
        "inporgressBookings": inporgressBookings,
        "completedBookingsByPreviousMonth": completedBookingsByPreviousMonth,
        "pendingdBookingsByPreviouMonth": pendingdBookingsByPreviouMonth,
        "cityBookings": cityBookings == null
            ? []
            : List<dynamic>.from(cityBookings!.map((x) => x.toJson())),
        "cityEmployee": cityEmployee == null
            ? []
            : List<dynamic>.from(cityEmployee!.map((x) => x.toJson())),
        "totalBookingsRejected": totalBookingsRejected,
      };
}

class City {
  String? city;
  int? count;

  City({
    this.city,
    this.count,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        city: json["city"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "count": count,
      };
}
