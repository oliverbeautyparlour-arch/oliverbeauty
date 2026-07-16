import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webui/config.dart';
import 'models.dart';
import 'package:flutter/material.dart';

class ApiService {
Future<Map<String, dynamic>> signup({
  required String name,
  required String email,
  required String password,
  //required String number,
}) async {
  final response = await http.post(
    Uri.parse("${AppConfig.API_URL}/signup"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "name": name,
      "email": email,
      "password": password,
     // "number": int.parse(number),
    }),
  );

  return jsonDecode(response.body);
}
Future<Map<String, dynamic>> login({
  required String name,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse("${AppConfig.API_URL}/login"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "name": name,
      "password": password,
    }),
  );

  return jsonDecode(response.body);
}
  Future<Map<String, dynamic>> createOrder({
  required double amount,
}) async {
  final response = await http.post(
    Uri.parse("${AppConfig.API_URL}/createOrder"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "amount": amount,
    }),
  );

  return jsonDecode(response.body);
}

  Future<List<ServiceModel>> getServices() async {
    final response = await http.get(
      Uri.parse('${AppConfig.API_URL}/getService'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List services = data['data'];

      return services.map((e) => ServiceModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<List<BookingModel>> getBookings() async {
    final response = await http.get(
      Uri.parse('${AppConfig.API_URL}/getBookings'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List bookings = data['data'];

      return bookings.map((e) => BookingModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<bool> addBooking(BookingModel booking) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.API_URL}/booking"),
        headers: {"Content-Type": "application/json"},
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
    final response = await http.get(Uri.parse('$AppConfig.API_URL}/TopFive'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List services = data['data'];

      return services.map((e) => ServiceModel.fromJson(e)).toList();
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


class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  String? userId;
  String? name;
  String? email;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    userId = prefs.getString("userId");
    name = prefs.getString("name");
    email = prefs.getString("email");

    _isLoggedIn = userId != null;

    notifyListeners();
  }

  void login({
    required String id,
    required String userName,
    required String userEmail,
  }) {
    _isLoggedIn = true;
    userId = id;
    name = userName;
    email = userEmail;

    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    userId = null;
    name = null;
    email = null;

    notifyListeners();
  }
}