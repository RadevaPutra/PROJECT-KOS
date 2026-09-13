import 'package:flutter/material.dart';
import 'dart:ui';
import '../model/sobatkos_models.dart';
import '../widgets/room_card.dart';
import '../widgets/custom_route.dart';
import 'booking_screen.dart';
import 'login_screen.dart';
import 'room_list_page.dart';

class HomeScreenContent extends StatefulWidget {
  final bool isLoggedIn;
  const HomeScreenContent({super.key, this.isLoggedIn = false});

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  // Daftar data dummy
  final List<Room> allRooms = [
    Room(id: 1, nomorKamar: "01", harga: 1500000, gambar: "assets/images/kamar_1.jpg", deskripsi: "Fasilitas lengkap, AC, KM Dalam", status: "Available"),
    Room(id: 2, nomorKamar: "02", harga: 1200000, gambar: "assets/images/kamar_2.jpg", deskripsi: "Free WiFi, Kasur Queen Size", status: "Available"),
    Room(id: 3, nomorKamar: "03", harga: 1600000, gambar: "assets/images/kamar_3.jpg", deskripsi: "View Bagus, Balkon Pribadi", status: "Available"),
    Room(id: 4, nomorKamar: "04", harga: 1000000, gambar: "assets/images/kamar_4.jpg", deskripsi: "Dekat Kampus, Parkir Luas", status: "Available"),
    Room(id: 5, nomorKamar: "05", harga: 1100000, gambar: "assets/images/kamar_5.jpg", deskripsi: "Strategis, Aman 24 Jam", status: "Available"),
    Room(id: 6, nomorKamar: "06", harga: 1350000, gambar: "assets/images/kamar_6.jpg", deskripsi: "Eksklusif, Full Furnished", status: "Available"),
  ];

  String searchQuery = "";

  List<Room> get displayedRooms {
    if (searchQuery.isEmpty) return allRooms;
    
    return allRooms.where((room) {
      int idx = allRooms.indexOf(room);
      Map<String, dynamic> roomInfo = _generateRoomData(room, idx);
      
      String roomName = "Kamar ${roomInfo['name']}".toLowerCase();
      String location = roomInfo['location'].toLowerCase();
      String description = roomInfo['deskripsi'].toLowerCase();
      
      String roomDetailsShortName = (roomInfo['details_singkat'] as List)
          .firstWhere((element) => element['label'] == 'Nama Kost', orElse: () => {'value': ''})['value']
          .toLowerCase();

      String query = searchQuery.toLowerCase();
      
      return roomName.contains(query) || location.contains(query) || description.contains(query) || roomDetailsShortName.contains(query);
    }).toList();
  }

  // Room categories removed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Update background to transparent for the animated background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // Make app bar transparent
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.4)),
          ),
        ),
        title: const Text(
          "SOBATKOS",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.black87),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black87), onPressed: () {}),
          if (!widget.isLoggedIn)
            TextButton(
              onPressed: () {
                Navigator.push(context, SlideRoute(page: const LoginPage()));
              },
              child: const Text("Login", style: TextStyle(color: Color(0xFFF58220), fontWeight: FontWeight.bold)),
            ),
        ],
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(),
                
                // Kategori Kamar Removed

                // Rekomendasi Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Rekomendasi Untukmu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
                const SizedBox(height: 15),
                _buildRecommendationList(),

                const SizedBox(height: 25),

                // Semua Kamar Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Semua Kamar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
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

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF58220), Color(0xFF3577AD)], // Orange and Blue gradient
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Temukan Kamar\nTernyamanmu",
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
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      searchQuery = val;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
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
    final list = displayedRooms;
    if (list.isEmpty) return const SizedBox();
    
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: list.length > 3 ? 3 : list.length,
        itemBuilder: (context, index) {
          final room = list[index];
          return Container(
            width: 170,
            margin: const EdgeInsets.only(right: 15),
            child: RoomCard(
              room: room,
              onTap: () => _showRoomDetails(context, room, allRooms.indexOf(room)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllRoomsGrid() {
    final list = displayedRooms;
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text("Kos tidak ditemukan.", style: TextStyle(color: Colors.grey)),
        ),
      );
    }
    
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
      itemCount: list.length,
      itemBuilder: (context, index) {
        final room = list[index];
        return RoomCard(
          room: room,
          onTap: () => _showRoomDetails(context, room, allRooms.indexOf(room)),
        );
      },
    );
  }

  String _getFacilities(String category, double price) {
    if (price < 1000000) {
      if (category.toLowerCase() == "putri") {
        return "Kasur, Lemari, Kipas Angin, KM Luar, Dapur Bersama";
      }
      return "Kasur, Lemari, Kipas Angin, KM Luar";
    } 
    
    if (price >= 1500000) {
      if (category.toLowerCase() == "putri") {
        return "Kasur Premium, Lemari Besar, AC, WiFi, Laundry, Meja Rias, KM Dalam, Dapur Bersama";
      } else if (category.toLowerCase() == "putra") {
        return "Kasur Premium, Lemari Besar, AC, WiFi, Laundry, Meja Belajar, KM Dalam";
      } else {
        return "King Bed, Smart TV, AC, WiFi Cepat, Laundry, Kulkas, KM Dalam (Water Heater)";
      }
    }
    
    if (category.toLowerCase() == "putri") {
      return "Kasur Springbed, Lemari, WiFi, AC, KM Dalam, Dapur Bersama";
    } else if (category.toLowerCase() == "putra") {
      return "Kasur Springbed, Lemari, WiFi, AC, KM Dalam, Meja Belajar";
    } else {
      return "Queen Bed, Lemari, WiFi, AC, Kulkas Mini, KM Dalam";
    }
  }

  final List<Map<String, dynamic>> baliDetails = [
    {
      "nama": "Kost Pondok Indah",
      "alamat": "Jl. Tukad Batanghari No. 12, Panjer, Denpasar Selatan, Bali 80225",
      "area": "Denpasar",
      "strategis": ["Dekat Plaza Renon (5 menit)", "Dekat Universitas Udayana (7 menit)", "Dekat RS Sanglah (10 menit)"],
      "deskripsi": "Kost di Denpasar dekat kawasan kampus dan pusat perbelanjaan Plaza Renon."
    },
    {
      "nama": "Kost Griya Sesetan",
      "alamat": "Jl. Raya Sesetan Gang Mangga No. 5, Sesetan, Denpasar Selatan, Bali 80223",
      "area": "Sesetan",
      "strategis": ["Dekat Lapangan Pegok (3 menit)", "Dekat Tol Bali Mandara (10 menit)", "Dekat STMIK Primakara (8 menit)"],
      "deskripsi": "Kost nyaman di Sesetan, akses sangat mudah menuju gerbang Tol Bali Mandara."
    },
    {
      "nama": "Kost Taman Asri",
      "alamat": "Jl. Tukad Pakerisan No. 88, Panjer, Denpasar Selatan, Bali 80225",
      "area": "Denpasar",
      "strategis": ["Dekat STIKOM Bali (3 menit)", "Dekat Level 21 Mall (10 menit)", "Dekat Monumen Bajra Sandhi (8 menit)"],
      "deskripsi": "Lingkungan kost tenang dan aman, sangat dekat dengan kampus STIKOM Bali."
    },
    {
      "nama": "Kost Sesetan Permai",
      "alamat": "Jl. Gurita I No. 4, Sesetan, Denpasar Selatan, Bali 80223",
      "area": "Sesetan",
      "strategis": ["Dekat Lotte Mart (7 menit)", "Dekat Kawasan Sanglah (12 menit)", "Dekat Pasar Sesetan (4 menit)"],
      "deskripsi": "Lokasi strategis di Sesetan, kamar luas dan lingkungan bebas banjir."
    },
    {
      "nama": "Kost Denpasar Elite",
      "alamat": "Jl. Diponegoro Gang Cendrawasih No. 2, Denpasar Barat, Bali 80114",
      "area": "Denpasar",
      "strategis": ["Dekat Tiara Dewata (5 menit)", "Dekat RS Kasih Ibu (7 menit)", "Dekat Level 21 Mall (5 menit)"],
      "deskripsi": "Kost premium di pusat kota Denpasar, akses kemana saja sangat dekat."
    },
    {
      "nama": "Kost Sunset Sesetan",
      "alamat": "Jl. Pulau Moyo No. 99, Sesetan, Denpasar Selatan, Bali 80223",
      "area": "Sesetan",
      "strategis": ["Dekat Mall Bali Galeria (15 menit)", "Dekat Benoa (12 menit)", "Dekat Universitas Pendidikan Nasional (10 menit)"],
      "deskripsi": "Suasana tenang di Pulau Moyo Sesetan, akses transportasi mudah dan dekat minimarket."
    },
    {
      "nama": "Kost Canggu Paradise",
      "alamat": "Jl. Raya Batu Bolong No. 45, Canggu, Kuta Utara, Bali 80361",
      "area": "Canggu",
      "strategis": ["Dekat Pantai Batu Bolong (10 menit)", "Dekat Echo Beach (12 menit)", "Dekat Finns Beach Club (15 menit)"],
      "deskripsi": "Kost bernuansa tropis di Canggu, cocok untuk yang menyukai suasana pantai dan lifestyle modern."
    },
    {
      "nama": "Kost Kuta Center",
      "alamat": "Jl. Legian Gang Kenanga No. 8, Kuta, Bali 80361",
      "area": "Kuta",
      "strategis": ["Dekat Pantai Kuta (10 menit)", "Dekat Beachwalk (10 menit)", "Dekat Monumen Ground Zero (5 menit)"],
      "deskripsi": "Berada di jantung wisata Kuta, sangat padat fasilitas dan sangat dekat pusat perbelanjaan serta hiburan malam."
    }
  ];

  Map<String, dynamic> _generateRoomData(Room room, int index) {
    double calculatedPrice = room.harga;
    String categoryTitle = (index % 2 == 0) ? "Putri" : "Putra";
    final detail = baliDetails[index % baliDetails.length];
    
    return {
      "name": room.nomorKamar,
      "image": room.gambar,
      "images_list": [
        room.gambar,
        "assets/images/kamar_${(index + 1) % 6 + 1}.jpg",
        "assets/images/kamar_${(index + 3) % 6 + 1}.jpg",
      ],
      "price": calculatedPrice,
      "location": detail["area"],
      "facilities": _getFacilities(categoryTitle, calculatedPrice),
      "deskripsi": "${detail['deskripsi']}\n\nLokasi Kost sangat strategis dekat kemana2 dekat Kampus, Pusat Perbelanjaan dan Perkantoran, lingkungan kost tenang aman dan nyaman.\n\nHarga Kost Rp.${calculatedPrice.toInt()} /Bulan jika berminat silahkan hubungi pemilik Rumah Kost Telp/WA: 081316363399",
      "fasilitas_dalam_kamar": ["WIFI", "Tempat Tidur", "Lemari Pakaian", "Pemanas Air", "Kamar Mandi di Dalam Kamar"],
      "fasilitas_bersama": ["Ruang Tamu Bersama", "Dapur & Kompor bersama", "Tempat Parkir Mobil/Motor", "Petugas Keamanan / Security"],
      "lokasi_strategis": detail["strategis"],
      "spesifikasi": [
        "Harga Kost Harian: Rp.160.000",
        "Harga Kost Bulanan: Rp.${calculatedPrice.toInt()}",
        "Jumlah Kamar Tidur: 1 Kamar",
        "Jumlah Kamar Mandi: 1",
        "Kamar Mandi di dalam Semua",
        "Jenis Kost: Kost Campur",
        "Ukuran Kamar Kost: 3 x 4 m2",
        "Luas Bangunan Total: 800 m2",
        "Luas Tanah Total: 1000 m2",
        "Jumlah Lantai: 2 Lantai",
        "Garasi Mobil: 5 mobil",
        "Tempat Parkir Motor: 10 motor",
        "Daya Listrik: 900 Watt",
        "Sumber Air: PDAM",
        "Alamat Lengkap: ${detail["alamat"]}",
      ],
      "details_singkat": [
        {"label": "Nama Kost", "value": detail["nama"]},
        {"label": "Alamat", "value": detail["alamat"]},
        {"label": "Tipe Kamar", "value": categoryTitle},
        {"label": "Luas Kamar", "value": "12 m²"},
        {"label": "Jumlah Kamar", "value": "40"},
      ]
    };
  }

  void _showRoomDetails(BuildContext context, Room parentRoom, int index) {
    // Selalu tampilkan detail kamar, baik sudah login maupun belum
    Map<String, dynamic> roomInfo = _generateRoomData(parentRoom, index);
    bool isExpanded = false;
    int currentImageIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateSheet) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                        child: SizedBox(
                          height: 250,
                          child: PageView.builder(
                            itemCount: (roomInfo['images_list'] as List).length,
                            onPageChanged: (idx) {
                              setStateSheet(() {
                                currentImageIndex = idx;
                              });
                            },
                            itemBuilder: (context, idx) {
                              String img = roomInfo['images_list'][idx];
                              return img.startsWith('assets/') 
                                  ? Image.asset(img, width: double.infinity, fit: BoxFit.cover) 
                                  : Image.network(img, width: double.infinity, fit: BoxFit.cover);
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate((roomInfo['images_list'] as List).length, (idx) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: currentImageIndex == idx ? 20 : 8,
                              decoration: BoxDecoration(
                                color: currentImageIndex == idx ? const Color(0xFFF58220) : Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 15,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                          style: IconButton.styleFrom(backgroundColor: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text("Kamar ${roomInfo['name']}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFFF58220), borderRadius: BorderRadius.circular(12)),
                                child: Text("Rp ${roomInfo['price'].toInt()}", style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey, size: 18),
                              const SizedBox(width: 6),
                              Text(roomInfo['location'], style: const TextStyle(color: Colors.grey, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Section: Deskripsi
                          Text(
                            roomInfo['deskripsi'] ?? "",
                            maxLines: isExpanded ? null : 3,
                            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
                          ),
                          if (!isExpanded)
                            GestureDetector(
                              onTap: () => setStateSheet(() => isExpanded = true),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text("Selengkapnya", style: TextStyle(color: Color(0xFFF58220), fontWeight: FontWeight.bold)),
                              ),
                            ),
                          if (isExpanded) ...[
                            const SizedBox(height: 15),
                            const Text("Fasilitas Dalam Kamar:", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            ...(roomInfo['fasilitas_dalam_kamar'] as List<String>).map((item) => Text("- $item", style: const TextStyle(color: Colors.black54))),
                            
                            const SizedBox(height: 15),
                            const Text("Fasilitas Bersama:", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            ...(roomInfo['fasilitas_bersama'] as List<String>).map((item) => Text("- $item", style: const TextStyle(color: Colors.black54))),

                            const SizedBox(height: 15),
                            const Text("Lokasi Sangat Strategis:", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            ...(roomInfo['lokasi_strategis'] as List<String>).map((item) => Text("- $item", style: const TextStyle(color: Colors.black54))),

                            const SizedBox(height: 15),
                            const Text("Spesifikasi Kost:", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            ...(roomInfo['spesifikasi'] as List<String>).map((item) => Text("- $item", style: const TextStyle(color: Colors.black54))),

                            GestureDetector(
                              onTap: () => setStateSheet(() => isExpanded = false),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                                child: Text("Sembunyikan", style: TextStyle(color: Color(0xFFF58220), fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                          const Divider(color: Colors.black12, height: 40),
                          
                          // Section: Details Table
                          const Text("Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 15),
                          ...(roomInfo['details_singkat'] as List).map((detail) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 120, child: Text(detail['label'], style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                                Expanded(child: Text(detail['value'], style: const TextStyle(color: Colors.black54))),
                              ],
                            ),
                          )),
                          const Divider(color: Colors.black12, height: 40),

                          // Section: Fasilitas Kamar
                          const Text("Fasilitas Kamar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 15,
                            runSpacing: 10,
                            children: (roomInfo['fasilitas_dalam_kamar'] as List<String>).map((fasilitas) {
                              return SizedBox(
                                width: (MediaQuery.of(context).size.width - 65) / 2,
                                child: Row(
                                  children: [
                                    const Icon(Icons.circle, color: Colors.black54, size: 6),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(fasilitas, style: const TextStyle(color: Colors.black87, fontSize: 14))),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const Divider(color: Colors.black12, height: 40),

                          // Section: Fasilitas Umum
                          const Text("Fasilitas Umum", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 15,
                            runSpacing: 10,
                            children: (roomInfo['fasilitas_bersama'] as List<String>).map((fasilitas) {
                              return SizedBox(
                                width: (MediaQuery.of(context).size.width - 65) / 2,
                                child: Row(
                                  children: [
                                    const Icon(Icons.circle, color: Colors.black54, size: 6),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(fasilitas, style: const TextStyle(color: Colors.black87, fontSize: 14))),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Tombol Booking Sekarang — cek login di sini
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF58220),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                        ),
                        onPressed: () {
                          // Jika user belum login, tampilkan popup "User Not Found"
                          if (!widget.isLoggedIn) {
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: const Text(
                                  "User Not Found",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                content: const Text(
                                  "Anda harus login atau register terlebih dahulu untuk dapat mem-booking kamar.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(dialogContext),
                                    child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF58220),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(dialogContext); // tutup dialog
                                      Navigator.pop(context);       // tutup bottom sheet
                                      Navigator.push(context, SlideRoute(page: const LoginPage()));
                                    },
                                    child: const Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }
                          // Jika sudah login, lanjut ke halaman booking
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingPage(
                                room: parentRoom,
                              ),
                            ),
                          );
                        },
                        child: const Text("Booking Sekarang", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }
}
