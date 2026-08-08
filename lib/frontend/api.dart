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
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.apiUrl}/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      final decoded = jsonDecode(response.body);
      final Map<String, dynamic> body = decoded is Map<String, dynamic>
          ? decoded
          : {};

      // Normalize: always guarantee a "success" bool is present.
      return {
        "success": response.statusCode >= 200 && response.statusCode < 300,
        "message": body["message"] ?? "Something went wrong",
        "data": body["data"] ?? body["user"],
        ...body,
      };
    } catch (e) {
      return {"success": false, "message": "Network error. Please try again."};
    }
  }

  Future<Map<String, dynamic>> login({
    required String name,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.apiUrl}/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "password": password}),
      );

      final decoded = jsonDecode(response.body);
      final Map<String, dynamic> body = decoded is Map<String, dynamic>
          ? decoded
          : {};

      return {
        "success": response.statusCode >= 200 && response.statusCode < 300,
        "message": body["message"] ?? "Something went wrong",
        "data": body["data"] ?? body["user"],
        ...body,
      };
    } catch (e) {
      return {"success": false, "message": "Network error. Please try again."};
    }
  }

  Future<bool> updateProfile({
    required String userId,
    required String name,
    required String email,
  }) async {
    final response = await http.put(
      Uri.parse("${AppConfig.apiUrl}/updateProfile/$userId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email}),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> createOrder({required double amount}) async {
    final response = await http.post(
      Uri.parse("${AppConfig.apiUrl}/createOrder"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"amount": amount}),
    );

    return jsonDecode(response.body);
  }

  Future<List<ServiceModel>> getServices() async {
    final response = await http.get(
      Uri.parse('${AppConfig.apiUrl}/getService'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List services = data['data'];

      return services.map((e) => ServiceModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<List<BookingModel>> getBookings(String userId) async {
    final response = await http.get(
      Uri.parse("${AppConfig.apiUrl}/getBookings/$userId"),
    );

    print("Bookings status: ${response.statusCode}");
    print("Bookings body: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List bookings = data['data'];

      return bookings.map((e) => BookingModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }
    Future<bool> logoutUser(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.apiUrl}/logout/$userId"),
        headers: {"Content-Type": "application/json"},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> addBooking(BookingModel booking) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.apiUrl}/booking"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(booking.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }


  Future<Map<String, dynamic>> resetPasswordDirect({
  required String email,
  required String newPassword,
}) async {
  try {
    final response = await http.post(
      Uri.parse('${AppConfig.apiUrl}/auth/reset-password-direct'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'newPassword': newPassword}),
    );
    return jsonDecode(response.body);
  } catch (e) {
    return {"success": false, "message": "Network error. Please try again."};
  }
}

  Future<Map<String, dynamic>> googleLogin(String accessToken) async {
    final response = await http.post(
      Uri.parse("${AppConfig.apiUrl}/googleLogin"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"accessToken": accessToken}),
    );

    return jsonDecode(response.body);
  }

  Future<List<ServiceModel>> getTopFive() async {
    final response = await http.get(Uri.parse('${AppConfig.apiUrl}/TopFive'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List services = data['data'];

      return services.map((e) => ServiceModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load top services');
    }
  }

  Future<DashboardModel> getDashboard() async {
    final response = await http.get(Uri.parse("${AppConfig.apiUrl}/dashboard"));

    if (response.statusCode == 200) {
      return DashboardModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load dashboard');
    }
  }

  Future<bool> addService({
    required String serviceName,
    required String category,
    required int durationMins,
    required double price,
    required String description,
     String? image,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.apiUrl}/addService"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "serviceName": serviceName,
          "category": category,
          "durationMins": durationMins,
          "price": price,
          "description": description,
          "image": image,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateService({
    required String serviceId,
    required String serviceName,
    required String category,
    required int durationMins,
    required double price,
    required String description,
     String? image,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("${AppConfig.apiUrl}/updateService/$serviceId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "serviceName": serviceName,
          "category": category,
          "durationMins": durationMins,
          "price": price,
          "description": description,
          "image": image
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await http.get(
        Uri.parse("${AppConfig.apiUrl}/profile/$userId"),
        headers: {"Content-Type": "application/json"},
      );

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
Future<Map<String, dynamic>> getAvailability(String date) async {
  try {
    final response =
        await http.get(Uri.parse('${AppConfig.apiUrl}/availability/$date'));
    return jsonDecode(response.body);
  } catch (e) {
    return {
      "success": false,
      "fullDayBlocked": false,
      "adminBlockedSlots": [],
      "bookedSlots": [],
    };
  }
}
 
Future<bool> setAvailability({
  required String date,
  required bool fullDayBlocked,
  required List<String> blockedSlots,
  String reason = "",
}) async {
  try {
    final response = await http.post(
      Uri.parse('${AppConfig.apiUrl}/admin/availability'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "date": date,
        "fullDayBlocked": fullDayBlocked,
        "blockedSlots": blockedSlots,
        "reason": reason,
      }),
    );
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
 
Future<List<AvailabilityModel>> getAllAvailability() async {
  final response =
      await http.get(Uri.parse('${AppConfig.apiUrl}/admin/availability'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List entries = data['data'];
    return entries.map((e) => AvailabilityModel.fromJson(e)).toList();
  }
  throw Exception('Failed to load availability');
}
 
Future<bool> deleteAvailability(String id) async {
  try {
    final response = await http
        .delete(Uri.parse('${AppConfig.apiUrl}/admin/availability/$id'));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
 
// ── Offers ────────────────────────────────────────────────────
 
Future<List<OfferModel>> getOffers() async {
  final response = await http.get(Uri.parse('${AppConfig.apiUrl}/offers'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List offers = data['data'];
    return offers.map((e) => OfferModel.fromJson(e)).toList();
  }
  throw Exception('Failed to load offers');
}
 
Future<bool> addOffer({
  required String title,
  required String subtitle,
  required String discountText,
  required String image,
  DateTime? validTill,
}) async {
  try {
    final response = await http.post(
      Uri.parse('${AppConfig.apiUrl}/admin/addOffer'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "subtitle": subtitle,
        "discountText": discountText,
        "image": image,
        "validTill": validTill?.toIso8601String(),
      }),
    );
    return response.statusCode == 201;
  } catch (e) {
    return false;
  }
}
 
Future<bool> deleteOffer(String id) async {
  try {
    final response =
        await http.delete(Uri.parse('${AppConfig.apiUrl}/admin/offers/$id'));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
 


}

class BookingProvider extends ChangeNotifier {
  List<BookingModel> _bookings = [];
  bool isLoading = false;

  List<BookingModel> get bookings => _bookings;

  Future<void> fetchBookings(String userId) async {
    isLoading = true;
    notifyListeners();
    try {
      print("Fetching bookings for userId: $userId");
      _bookings = await ApiService().getBookings(userId);
      print("Bookings fetched: ${_bookings.length}");
    } catch (e) {
      debugPrint('fetchBookings error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> cancelBooking(String bookingId) async {
    try {
      final res = await http.patch(
        Uri.parse('${AppConfig.apiUrl}/bookings/$bookingId/cancel'),
        headers: {'Content-Type': 'application/json'},
      );
      print("Cancel status: ${res.statusCode}");
      print("Cancel body: ${res.body}");
      if (res.statusCode == 200) {
        final idx = _bookings.indexWhere((b) => b.bookingId == bookingId);
        if (idx != -1) {
          _bookings[idx] = _bookings[idx].copyWith(status: 'cancelled');
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('cancelBooking error: $e');
      return false;
    }
  }

  Future<bool> rescheduleBooking(String bookingId, DateTime newDateTime) async {
    try {
      final res = await http.patch(
        Uri.parse('${AppConfig.apiUrl}/bookings/$bookingId/reschedule'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'bookingDateTime': newDateTime.toIso8601String()}),
      );
      if (res.statusCode == 200) {
        final idx = _bookings.indexWhere((b) => b.bookingId == bookingId);
        if (idx != -1) {
          _bookings[idx] = _bookings[idx].copyWith(
            bookingDateTime: newDateTime,
          );
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('reschedule Booking error: $e');
      return false;
    }
  }


}

class ServiceProvider extends ChangeNotifier {
  List<ServiceModel> _services = [];
  bool _isLoading = false;

  List<ServiceModel> get services => _services;
  bool get isLoading => _isLoading;

  Future<void> fetchServices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _services = await ApiService().getServices();
    } catch (e) {
      debugPrint(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }
}

class TopServiceProvider extends ChangeNotifier {
  List<ServiceModel> _topServices = [];

  bool _isLoading = false;
  List<ServiceModel> get topServices => _topServices;
  bool get isLoading => _isLoading;

  Future<void> fetchTopServices() async {
    _isLoading = true;
    notifyListeners();
    try {
      _topServices = await ApiService().getTopFive();
    } catch (e) {
      debugPrint(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }
}

class DashboardProvider extends ChangeNotifier {
  DashboardModel? _dashboard;
  bool _isLoading = false;

  DashboardModel? get dashboard => _dashboard;
  bool get isLoading => _isLoading;

  Future<void> fetchDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      _dashboard = await ApiService().getDashboard();
    } catch (e) {
      debugPrint(e.toString());
    }

    _isLoading = false;
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

  void updateProfile({required String userName, required String userEmail}) {
    name = userName;
    email = userEmail;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      if (userId != null) {
        await ApiService().logoutUser(userId!); // instance call, not static
      }
    } catch (e) {
      debugPrint('Logout API failed: $e');
    }
    await prefs.clear();
    _isLoggedIn = false;
    userId = null;
    name = null;
    email = null;

    notifyListeners();
  }
}
class OfferProvider extends ChangeNotifier {
  List<OfferModel> _offers = [];
  bool isLoading = false;
 
  List<OfferModel> get offers => _offers;
 
  Future<void> fetchOffers() async {
    isLoading = true;
    notifyListeners();
    try {
      _offers = await ApiService().getOffers();
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}