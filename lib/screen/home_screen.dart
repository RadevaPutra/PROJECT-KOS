import 'package:flutter/material.dart';
import 'dart:ui';
import '../model/jaykos_models.dart';
import '../widgets/room_card.dart';
import '../widgets/custom_route.dart';
import '../widgets/category_item.dart';
import 'booking_screen.dart';
import 'login_screen.dart';
import 'room_list_page.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  // Daftar data dummy
  final List<Room> allRooms = [
    Room(id: 1, nomorKamar: "01", harga: 1500000, gambar: "assets/images/kamar_1.jpg", deskripsi: "Fasilitas lengkap, AC, KM Dalam", status: "Available"),
    Room(id: 2, nomorKamar: "02", harga: 1200000, gambar: "assets/images/kamar_2.jpg", deskripsi: "Free WiFi, Kasur Queen Size", status: "Available"),
    Room(id: 3, nomorKamar: "03", harga: 1800000, gambar: "assets/images/kamar_3.jpg", deskripsi: "View Bagus, Balkon Pribadi", status: "Available"),
    Room(id: 4, nomorKamar: "04", harga: 1350000, gambar: "assets/images/kamar_4.jpg", deskripsi: "Dekat Kampus, Parkir Luas", status: "Sold"),
    Room(id: 5, nomorKamar: "05", harga: 1100000, gambar: "assets/images/kamar_5.jpg", deskripsi: "Strategis, Aman 24 Jam", status: "Available"),
    Room(id: 6, nomorKamar: "06", harga: 2000000, gambar: "assets/images/kamar_6.jpg", deskripsi: "Eksklusif, Full Furnished", status: "Available"),
  ];

  final List<RoomCategory> categories = [
    RoomCategory(title: "Putra", icon: Icons.male, images: ["assets/images/kamar_1.jpg", "assets/images/kamar_2.jpg"]),
    RoomCategory(title: "Putri", icon: Icons.female, images: ["assets/images/kamar_3.jpg", "assets/images/kamar_4.jpg"]),
    RoomCategory(title: "VIP", icon: Icons.star, images: ["assets/images/kamar_5.jpg", "assets/images/kamar_6.jpg"]),
    RoomCategory(title: "Campur", icon: Icons.group, images: ["assets/images/kamar_7.jpg", "assets/images/kamar_8.jpeg"]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFF8C00),
        title: const Text(
          "JAYKOS",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
          TextButton(
            onPressed: () {
              Navigator.push(context, SlideRoute(page: const LoginPage()));
            },
            child: const Text("Login", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(),
                
                // Kategori Kamar Section
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                  child: Text("Kategori Kamar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: categories.map((cat) => CategoryItem(
                      title: cat.title, 
                      icon: cat.icon, 
                      onTap: () {
                        Navigator.push(context, SlideRoute(page: RoomListPage(category: cat)));
                      }
                    )).toList(),
                  ),
                ),

                const SizedBox(height: 25), // Spasi antar section yang lebih terkontrol

                // Rekomendasi Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Rekomendasi Untukmu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 15),
                _buildRecommendationList(),

                const SizedBox(height: 25),

                // Semua Kamar Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Semua Kamar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 15),
                _buildAllRoomsGrid(),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(color: const Color(0xFFFF8C00).withOpacity(0.2), shape: BoxShape.circle),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          left: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.15), shape: BoxShape.circle),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Temukan HKamar\nTernyamanmu",
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Cari lokasi atau nama kos...",
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationList() {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: 3,
        itemBuilder: (context, index) {
          final room = allRooms[index];
          return Container(
            width: 170,
            margin: const EdgeInsets.only(right: 15),
            child: RoomCard(
              room: room,
              onTap: () {
                Navigator.push(context, SlideRoute(page: BookingPage(room: room)));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllRoomsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemCount: allRooms.length,
      itemBuilder: (context, index) {
        final room = allRooms[index];
        return RoomCard(
          room: room,
          onTap: () {
            Navigator.push(context, SlideRoute(page: BookingPage(room: room)));
          },
        );
      },
    );
  }
}
