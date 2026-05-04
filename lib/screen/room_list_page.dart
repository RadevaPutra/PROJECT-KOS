import 'package:flutter/material.dart';
import 'dart:ui';
import '../model/sobatkos_models.dart';
import 'payment_screen.dart';

class RoomListPage extends StatefulWidget {
  final RoomCategory category;

  const RoomListPage({super.key, required this.category});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  String selectedLocation = "Semua Lokasi";
  String selectedPriceSort = "Default";
  
  // Simulasi data kamar yang lebih detail agar bisa difilter
  late List<Map<String, dynamic>> displayRooms;

  @override
  void initState() {
    super.initState();
    // Mengubah list gambar menjadi list objek data kamar dengan variasi harga dan lokasi
    displayRooms = List.generate(widget.category.images.length, (index) {
      return {
        "name": "Kamar ${widget.category.title} #0${index + 1}",
        "image": widget.category.images[index],
        "price": 1200000.0 + (index * 200000), // Variasi harga untuk testing filter
        "location": index % 2 == 0 ? "Denpasar" : "Sesetan",
        "facilities": "Kasur, Lemari, WiFi, KM Dalam",
      };
    });
  }

  void _applyFilter() {
    setState(() {
      // Logika Sorting Harga
      if (selectedPriceSort == "Harga Terendah") {
        displayRooms.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (selectedPriceSort == "Harga Tertinggi") {
        displayRooms.sort((a, b) => b['price'].compareTo(a['price']));
      } else {
        // Reset to default (original index)
        displayRooms = List.generate(widget.category.images.length, (index) {
          return {
            "name": "Kamar ${widget.category.title} #0${index + 1}",
            "image": widget.category.images[index],
            "price": 1200000.0 + (index * 200000),
            "location": index % 2 == 0 ? "Denpasar" : "Sesetan",
            "facilities": "Kasur, Lemari, WiFi, KM Dalam",
          };
        });
      }
    });
  }

  // Fungsi untuk menampilkan gambar full screen saat diklik
  void _showFullScreenImage(BuildContext context, String imagePath) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black, 
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Kamar ${widget.category.title}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
      body: Column(
        children: [
          // BAR FILTER (Lokasi & Harga)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                _buildFilterDropdown(
                  icon: Icons.location_on,
                  value: selectedLocation,
                  items: ["Semua Lokasi", "Denpasar", "Sesetan"],
                  onChanged: (val) => setState(() => selectedLocation = val!),
                ),
                const SizedBox(width: 10),
                _buildFilterDropdown(
                  icon: Icons.swap_vert,
                  value: selectedPriceSort,
                  items: ["Default", "Harga Terendah", "Harga Tertinggi"],
                  onChanged: (val) {
                    setState(() {
                      selectedPriceSort = val!;
                      _applyFilter();
                    });
                  },
                ),
              ],
            ),
          ),

          // LIST DAFTAR KAMAR
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: displayRooms.length,
              itemBuilder: (context, index) {
                final room = displayRooms[index];
                
                // Filter Lokasi
                if (selectedLocation != "Semua Lokasi" && room['location'] != selectedLocation) {
                  return const SizedBox.shrink();
                }

                return _buildRoomCard(room);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({required IconData icon, required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: const Color(0xFF1E293B),
            style: const TextStyle(color: Colors.white, fontSize: 12),
            icon: Icon(icon, size: 16, color: const Color(0xFFDAA520)),
            items: items.map((String item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showFullScreenImage(context, room['image']),
            child: Stack(
              children: [
                Image.asset(room['image'], height: 180, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.category.title,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(room['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Rp ${room['price'].toInt()}", style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(room['location'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Fasilitas: ${room['facilities']}", style: const TextStyle(color: Colors.black54, fontSize: 12)),
                const Divider(height: 30),
                
                // TOMBOL BOOKING SEKARANG
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDAA520),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            totalBayar: room['price'],
                            namaKamar: room['name'],
                          ),
                        ),
                      );
                    },
                    child: const Text("Booking Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

