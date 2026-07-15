class ServiceModel {
  final String serviceId;
  final String serviceName;
  final String category;
  final int durationMins;
  final double price;
  final String description;
  final String image;

  ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.category,
    required this.durationMins,
    required this.price,
    required this.description,
    required this.image,
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

  final String paymentType;

  final String status;

  BookingModel({
    this.bookingId,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.bookedPrice,
    required this.bookedDuration,
    required this.bookingDateTime,
    required this.paymentType,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String,dynamic> json){

    return BookingModel(

      bookingId: json["bookingId"]?.toString(),

      userId: json["userId"],

      serviceId: json["serviceId"],

      serviceName: json["serviceName"],

      bookedPrice: (json["bookedPrice"]).toDouble(),

      bookedDuration: json["bookedDuration"],

      bookingDateTime: DateTime.parse(json["bookingDateTime"]),

      paymentType: json["paymentType"],

      status: json["status"],

    );

  }

  Map<String,dynamic> toJson(){

    return {

      "userId": userId,

      "serviceId": serviceId,

      "serviceName": serviceName,

      "bookedPrice": bookedPrice,

      "bookedDuration": bookedDuration,

      "bookingDateTime": bookingDateTime.toIso8601String(),

      "paymentType": paymentType,

      "status": status,

    };

  }

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
