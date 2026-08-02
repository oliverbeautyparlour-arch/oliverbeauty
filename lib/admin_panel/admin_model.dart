class DashboardModel {
  final int bookings;
  final int customers;
  final int services;
  final double revenue;

  DashboardModel({
    required this.bookings,
    required this.customers,
    required this.services,
    required this.revenue,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      bookings: json["totalBookings"],
      customers: json["totalCustomers"],
      services: json["totalServices"],
      revenue: (json["revenue"] ?? 0).toDouble(),
    );
  }
}

class TopServiceModel {
  final String serviceId;
  final String serviceName;
  final String category;
  final int totalBookings;
  final double price;

  TopServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.category,
    required this.totalBookings,
    required this.price,
  });

  factory TopServiceModel.fromJson(Map<String, dynamic> json) {
    return TopServiceModel(
      serviceId: json["serviceId"] ?? "",
      serviceName: json["serviceName"] ?? "",
      category: json["category"] ?? "",
      totalBookings: json["totalBookings"] ?? 0,
      price: (json["price"] ?? 0).toDouble(),
    );
  }
}