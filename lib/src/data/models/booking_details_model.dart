import 'dart:convert';

BookingDetailsModel bookingDetailsModelFromJson(String str) =>
    BookingDetailsModel.fromJson(json.decode(str));

String bookingDetailsModelToJson(BookingDetailsModel data) =>
    json.encode(data.toJson());

class BookingDetailsModel {
  final String bookingId;
  final String serviceId;
  final String customerId;
  final String employeeId;
  final String bookingStatus;
  final String serviceName;
  final String providerName;
  final DateTime? bookDate;
  final double price;
  final String category;
  final String employeeContact;
  final String serviceDescription;
  final String paymentStatus;
  final String customerName;
  final String customerContactNumber;
  final String customerAddress;
  final String customerEmail;
  final String addInfoOne;
  final String addInfoTwo;
  final String addInfoThree;
  final String iconUrl;

  BookingDetailsModel(
      {required this.bookingId,
      required this.serviceId,
      required this.customerId,
      required this.employeeId,
      required this.customerEmail,
      required this.bookingStatus,
      required this.serviceName,
      required this.providerName,
      required this.bookDate,
      required this.customerAddress,
      required this.price,
      required this.customerContactNumber,
      required this.category,
      required this.customerName,
      required this.employeeContact,
      required this.serviceDescription,
      required this.paymentStatus,
      required this.addInfoOne,
      required this.addInfoTwo,
      required this.addInfoThree,
      required this.iconUrl});

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
        bookingId: json["bookingId"] ?? "",
        serviceId: json["serviceId"] ?? "",
        customerId: json["customerId"] ?? "",
        employeeId: json["employeeId"] ?? "",
        bookingStatus: json["bookingStatus"] ?? "",
        serviceName: json["serviceName"] ?? "",
        providerName: json["providerName"] ?? "",
        customerName: json["customerName"] ?? "",
        customerEmail: json["customerEmail"] ?? "",
        addInfoOne: json["addInfoOne"] ?? "",
        addInfoTwo: json["addInfoTwo"] ?? "",
        addInfoThree: json["addInfoThree"] ?? "",
        customerContactNumber: json["customerContactNumber"] ?? "",
        customerAddress: json["customerLocation"] ?? "",
        bookDate: json["bookDate"] != null
            ? DateTime.tryParse(json["bookDate"].toString())
            : DateTime(0, 0, 0, 0),
        price: (json["price"] is int)
            ? (json["price"] as int).toDouble()
            : (json["price"] ?? 0).toDouble(),
        category: json["category"] ?? "",
        employeeContact: json["employeeContact"] ?? "",
        serviceDescription: json["serviceDescription"] ?? "",
        paymentStatus: json["paymentStatus"] ?? "",
        iconUrl: json["iconUrl"] ?? "");
  }

  Map<String, dynamic> toJson() => {
        "bookingId": bookingId,
        "serviceId": serviceId,
        "customerId": customerId,
        "employeeId": employeeId,
        "bookingStatus": bookingStatus,
        "serviceName": serviceName,
        "providerName": providerName,
        "bookDate": bookDate?.toIso8601String(),
        "price": price,
        "category": category,
        "employeeContact": employeeContact,
        "serviceDescription": serviceDescription,
        "paymentStatus": paymentStatus,
      };
}
