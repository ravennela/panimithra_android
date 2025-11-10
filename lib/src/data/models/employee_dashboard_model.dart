// To parse this JSON data, do
//
//     final employeeDashboardModel = employeeDashboardModelFromJson(jsonString);

import 'dart:convert';

EmployeeDashboardModel employeeDashboardModelFromJson(String str) =>
    EmployeeDashboardModel.fromJson(json.decode(str));

String employeeDashboardModelToJson(EmployeeDashboardModel data) =>
    json.encode(data.toJson());

class EmployeeDashboardModel {
  String? employeeName;
  int? totalBookings;
  int? bookingsInprogress;
  int? bookingsCompleted;
  int? bookingsRejected;
  int? bookingsCancelled;
  double? revenue;
  List<MonthWiseRevenue>? monthWiseRevenue;

  EmployeeDashboardModel({
    this.employeeName,
    this.totalBookings,
    this.bookingsInprogress,
    this.bookingsCompleted,
    this.revenue,
    this.bookingsCancelled,
    this.bookingsRejected,
    this.monthWiseRevenue,
  });

  factory EmployeeDashboardModel.fromJson(Map<String, dynamic> json) =>
      EmployeeDashboardModel(
        employeeName: json["employeeName"],
        totalBookings: json["totalBookings"],
        bookingsCancelled: json["cancelledBookings"],
        bookingsRejected: json["rejectedBookings"],
        bookingsInprogress: json["bookingsInprogress"],
        bookingsCompleted: json["bookingsCompleted"],
        revenue: json["revenue"],
        monthWiseRevenue: json["monthWiseRevenue"] == null
            ? []
            : List<MonthWiseRevenue>.from(json["monthWiseRevenue"]!
                .map((x) => MonthWiseRevenue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "employeeName": employeeName,
        "totalBookings": totalBookings,
        "bookingsInprogress": bookingsInprogress,
        "bookingsCompleted": bookingsCompleted,
        "revenue": revenue,
        "monthWiseRevenue": monthWiseRevenue == null
            ? []
            : List<dynamic>.from(monthWiseRevenue!.map((x) => x.toJson())),
      };
}

class MonthWiseRevenue {
  int? month;
  double? totalAmount;
  double? amount;
  String? monthName;

  MonthWiseRevenue({
    this.month,
    this.totalAmount,
    this.amount,
    this.monthName,
  });

  factory MonthWiseRevenue.fromJson(Map<String, dynamic> json) {
    int? month = json["month"];
    const monthNames = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return MonthWiseRevenue(
      month: month,
      totalAmount: json["totalAmount"] ?? 0.0,
      amount: json["amount"] ?? 0.0,
      monthName:
          (month != null && month >= 1 && month <= 12) ? monthNames[month] : '',
    );
  }

  Map<String, dynamic> toJson() => {
        "month": month,
        "totalAmount": totalAmount,
        "amount": amount,
        "monthName": monthName,
      };
}
