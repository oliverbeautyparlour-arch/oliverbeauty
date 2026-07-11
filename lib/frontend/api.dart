import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'package:flutter/material.dart';

class ApiService {
  Future<List<ServiceModel>> getServices() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/getService'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List services = data['data'];

      return services
          .map((e) => ServiceModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load services');
    }
  }
Future<List<BookingModel>> getBookings() async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/getBookings'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    List bookings = data['data'];

    return bookings
        .map((e) => BookingModel.fromJson(e))
        .toList();
  } else {
    throw Exception('Failed to load bookings');
  }
 }
Future<bool> addBooking(BookingModel booking) async {
  try {
    final response = await http.post(
      Uri.parse("http://localhost:3000/addBookings"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(booking.toJson()),
    );
  print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");
    print("Request: ${jsonEncode(booking.toJson())}");
    if (response.statusCode == 201) {
      return true;
    }

    return false;
  } catch (e) {
    print(e);
    return false;
  }
}
 Future<List<ServiceModel>> getTopFive() async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/TopFive'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    List services = data['data'];

    return services
        .map((e) => ServiceModel.fromJson(e))
        .toList();
  } else {
    throw Exception('Failed to load top services');
  }
}

}


class BookingProvider extends ChangeNotifier {
  List<BookingModel> _bookings = [];

  List<BookingModel> get bookings => _bookings;

  Future<void> fetchBookings() async {
    _bookings = await ApiService().getBookings();
    notifyListeners();
  }
}

class ServiceProvider extends ChangeNotifier {
  List<ServiceModel> _services = [];

  List<ServiceModel> get services => _services;

  Future<void> fetchServices() async {
    _services = await ApiService().getServices();
    notifyListeners();
  }
}

class TopServiceProvider extends ChangeNotifier {
  List<ServiceModel> _topServices = [];

  List<ServiceModel> get topServices => _topServices;

  Future<void> fetchTopServices() async {
    _topServices = await ApiService().getTopFive();
    notifyListeners();
  }
}