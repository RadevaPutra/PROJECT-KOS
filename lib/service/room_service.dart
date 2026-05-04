import '../model/sobatkos_models.dart';

class RoomService {
  // Static list to maintain data across screens during the session
  static List<Room> _rooms = [
    Room(
      id: 1,
      nomorKamar: "Kamar Luxury #01",
      harga: 1500000,
      gambar: "assets/images/kamar_1.jpg",
      deskripsi: "Kamar mewah dengan fasilitas lengkap dan desain modern.",
      status: "Tersedia",
    ),
    Room(
      id: 2,
      nomorKamar: "Kamar Modern #02",
      harga: 1200000,
      gambar: "assets/images/kamar_2.jpg",
      deskripsi: "Kamar minimalis modern yang nyaman untuk mahasiswa.",
      status: "Tersedia",
    ),
  ];

  static List<Room> getRooms() => _rooms;

  static void addRoom(Room room) {
    _rooms.add(room);
  }

  static void deleteRoom(int id) {
    _rooms.removeWhere((r) => r.id == id);
  }

  static void updateRoomPrice(int id, double newPrice) {
    int index = _rooms.indexWhere((r) => r.id == id);
    if (index != -1) {
      Room old = _rooms[index];
      _rooms[index] = Room(
        id: old.id,
        nomorKamar: old.nomorKamar,
        harga: newPrice,
        gambar: old.gambar,
        deskripsi: old.deskripsi,
        status: old.status,
      );
    }
  }
}
