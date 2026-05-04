import 'package:flutter/material.dart';
import 'dart:ui';
import '../model/sobatkos_models.dart';
import '../service/room_service.dart';

class AdminManageRoomsScreen extends StatefulWidget {
  const AdminManageRoomsScreen({super.key});

  @override
  State<AdminManageRoomsScreen> createState() => _AdminManageRoomsScreenState();
}

class _AdminManageRoomsScreenState extends State<AdminManageRoomsScreen> {
  late List<Room> rooms;

  @override
  void initState() {
    super.initState();
    _refreshRooms();
  }

  void _refreshRooms() {
    setState(() {
      rooms = List.from(RoomService.getRooms());
    });
  }

  void _showAddRoomDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B).withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), 
            side: const BorderSide(color: Colors.white10),
          ),
          title: const Text("Tambah Kamar Baru", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogField(nameController, "Nama Kamar", Icons.meeting_room),
                const SizedBox(height: 15),
                _buildDialogField(priceController, "Harga (Rp)", Icons.payments, isNumber: true),
                const SizedBox(height: 15),
                _buildDialogField(descController, "Deskripsi", Icons.description, maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDAA520)),
              onPressed: () {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  final newRoom = Room(
                    id: DateTime.now().millisecondsSinceEpoch,
                    nomorKamar: nameController.text,
                    harga: double.parse(priceController.text),
                    gambar: "assets/images/kamar_1.jpg", // Default placeholder
                    deskripsi: descController.text,
                    status: "Tersedia",
                  );
                  RoomService.addRoom(newRoom);
                  _refreshRooms();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Kamar berhasil ditambahkan"), backgroundColor: Colors.green),
                  );
                }
              },
              child: const Text("Simpan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPriceDialog(Room room) {
    final priceController = TextEditingController(text: room.harga.toInt().toString());

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B).withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), 
            side: const BorderSide(color: Colors.white10),
          ),
          title: Text("Edit Harga - ${room.nomorKamar}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          content: _buildDialogField(priceController, "Harga Baru (Rp)", Icons.payments, isNumber: true),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDAA520)),
              onPressed: () {
                if (priceController.text.isNotEmpty) {
                  RoomService.updateRoomPrice(room.id, double.parse(priceController.text));
                  _refreshRooms();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Harga berhasil diperbarui"), backgroundColor: Colors.blue),
                  );
                }
              },
              child: const Text("Update", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Room room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Hapus Kamar?", style: TextStyle(color: Colors.white)),
        content: Text("Apakah Anda yakin ingin menghapus ${room.nomorKamar}?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              RoomService.deleteRoom(room.id);
              _refreshRooms();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Kamar berhasil dihapus"), backgroundColor: Colors.redAccent),
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: const Color(0xFFDAA520)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white10)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDAA520))),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Kelola Kamar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: rooms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.meeting_room_outlined, size: 80, color: Colors.white24),
                  const SizedBox(height: 15),
                  const Text("Belum ada data kamar", style: TextStyle(color: Colors.white54, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                return _buildRoomTile(room);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFDAA520),
        onPressed: _showAddRoomDialog,
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }

  Widget _buildRoomTile(Room room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(room.gambar, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 80, height: 80, color: Colors.grey)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room.nomorKamar, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text("Rp ${room.harga.toInt()}", style: const TextStyle(color: Color(0xFFDAA520), fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                  child: Text(room.status, style: const TextStyle(color: Colors.greenAccent, fontSize: 10)),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                onPressed: () => _showEditPriceDialog(room),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _confirmDelete(room),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
