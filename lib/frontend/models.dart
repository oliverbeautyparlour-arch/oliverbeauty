class ServiceModel {
  final String serviceId;
  final String serviceName;
  final String category;
  final int durationMins;
  final double price;
  final String description;
  final String image;
  final int totalBookings;

  ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.category,
    required this.durationMins,
    required this.price,
    required this.description,
    required this.image,
    this.totalBookings = 0,
  });
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: json['category'] ?? '',
      price: json['price'] ?? 0,
      durationMins: json['durationMins'] ?? 0,
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      totalBookings: json['totalBookings'] ?? 0,
    );
  }
}

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
      bookings: json["totalBookings"] ?? 0,
      customers: json["totalCustomers"] ?? 0,
      services: json["totalServices"] ?? 0,
      revenue: (json["revenue"] ?? 0).toDouble(),
    );
  }
}

class BookingModel {
  final String? bookingId;

  final String userId;

  final String serviceId;

  final String serviceName;

  final double bookedPrice;

  final int bookedDuration;

  final DateTime bookingDateTime;

  final String status;

  BookingModel({
    this.bookingId,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.bookedPrice,
    required this.bookedDuration,
    required this.bookingDateTime,
    this.status ='Pending',
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
     bookingId: json["_id"]?.toString(),

      userId: json["userId"],

      serviceId: json["serviceId"],

      serviceName: json["serviceName"],

      bookedPrice: (json["bookedPrice"]).toDouble(),

      bookedDuration: json["bookedDuration"],

      bookingDateTime: DateTime.parse(json["bookingDateTime"]),
      status: json['status'] ?? 'Confirmed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,

      "serviceId": serviceId,

      "serviceName": serviceName,

      "bookedPrice": bookedPrice,

      "bookedDuration": bookedDuration,

      "bookingDateTime": bookingDateTime.toIso8601String(),
      "status": status,
    };
  }

  BookingModel copyWith({
    String? bookingId,
    String? userId,
    String? serviceId,
    String? serviceName,
    double? bookedPrice,
    int? bookedDuration,
    DateTime? bookingDateTime,
    String? status,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      bookedPrice: bookedPrice ?? this.bookedPrice,
      bookedDuration: bookedDuration ?? this.bookedDuration,
      bookingDateTime: bookingDateTime ?? this.bookingDateTime,
      status: status ?? this.status,
    );
  }
}
/* Append these classes to your models.dart */

class AvailabilityModel {
  final String id;
  final String date; // "YYYY-MM-DD"
  final bool fullDayBlocked;
  final List<String> blockedSlots;
  final String reason;

  AvailabilityModel({
    required this.id,
    required this.date,
    required this.fullDayBlocked,
    required this.blockedSlots,
    required this.reason,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      AvailabilityModel(
        id: json['_id'] ?? '',
        date: json['date'] ?? '',
        fullDayBlocked: json['fullDayBlocked'] ?? false,
        blockedSlots: List<String>.from(json['blockedSlots'] ?? []),
        reason: json['reason'] ?? '',
      );
}

class OfferModel {
  final String id;
  final String title;
  final String subtitle;
  final String discountText;
  final String image;
  final DateTime? validTill;

  OfferModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.discountText,
    required this.image,
    this.validTill,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        subtitle: json['subtitle'] ?? '',
        discountText: json['discountText'] ?? '',
        image: json['image'] ?? '',
        validTill: json['validTill'] != null
            ? DateTime.tryParse(json['validTill'])
            : null,
      );
}
final List<Map<String, String>> testimonials = [
  {
    'name': 'Priya S.',
    'text': 'Amazing service! The staff was very professional and friendly.',
    'stars': '5',
  },
  {
    'name': 'Neha R.',
    'text': 'Best salon experience ever. Highly recommended to everyone!',
    'stars': '5',
  },
  {
    'name': 'Anjali K.',
    'text': 'Loved the makeup! It was perfect for my special day.',
    'stars': '5',
  },
];
