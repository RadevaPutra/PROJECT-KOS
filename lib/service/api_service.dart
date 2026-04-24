import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/jaykos_models.dart';

class ApiService {
  // IP Emulator Android: 10.0.2.2, Localhost: 127.0.0.1
  static const String BASE_URL = "http://10.0.2.2:8080/NamaProjectAnda"; 

  // Auth logic
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/logincontroller'),
        body: {'username': username, 'password': password},
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // Get Rooms logic
  Future<List<Room>> getRooms() async {
    try {
      final response = await http.get(Uri.parse('$BASE_URL/RoomController?action=list'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Room.fromJson(data)).toList();
      } else {
        throw Exception('Gagal memuat kamar: ${response.statusCode}');
      }
    } catch (e) {
       // For demo/development if server is not running, return some mock data
       return _getMockRooms();
    }
  }

  List<Room> _getMockRooms() {
    return [
      Room(id: 1, nomorKamar: "101", harga: 1500000, status: "Tersedia", gambar: "room1.jpg", deskripsi: "Kamar nyaman dengan AC dan WiFi."),
      Room(id: 2, nomorKamar: "102", harga: 1200000, status: "Penuh", gambar: "room2.jpg", deskripsi: "Kamar minimalis hemat biaya."),
      Room(id: 3, nomorKamar: "201", harga: 2000000, status: "Tersedia", gambar: "room3.jpg", deskripsi: "Kamar VIP dengan balkon."),
      Room(id: 4, nomorKamar: "202", harga: 1800000, status: "Tersedia", gambar: "room4.jpg", deskripsi: "Kamar luas untuk berdua."),
    ];
  }

  // Booking logic
  Future<bool> createBooking(int roomId, int durasi, double total) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/Bookingcontroller'),
        body: {
          'room_id': roomId.toString(),
          'durasi': durasi.toString(),
          'total_harga': total.toString(),
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
