import 'package:flutter/material.dart';
import 'dart:ui';
import '../model/sobatkos_models.dart';
import 'payment_screen.dart';
import 'login_screen.dart';
import '../widgets/custom_route.dart';

class RoomListPage extends StatefulWidget {
  final RoomCategory category;
  final bool isLoggedIn;

  const RoomListPage({super.key, required this.category, this.isLoggedIn = false});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  String selectedLocation = "Semua Lokasi";
  String selectedPriceSort = "Default";
  
  // Simulasi data kamar yang lebih detail agar bisa difilter
  late List<Map<String, dynamic>> displayRooms;

  String _getFacilities(String category, double price) {
    if (price < 1000000) {
      // Di bawah 1 juta: tidak ada AC, tidak ada WiFi, tidak ada Laundry
      if (category.toLowerCase() == "putri") {
        return "Kasur, Lemari, Kipas Angin, KM Luar, Dapur Bersama";
      }
      return "Kasur, Lemari, Kipas Angin, KM Luar";
    } 
    
    if (price >= 1500000) {
      // 1,5 juta ke atas: Include AC, WiFi, Laundry
      if (category.toLowerCase() == "putri") {
        return "Kasur Premium, Lemari Besar, AC, WiFi, Laundry, Meja Rias, KM Dalam, Dapur Bersama";
      } else if (category.toLowerCase() == "putra") {
        return "Kasur Premium, Lemari Besar, AC, WiFi, Laundry, Meja Belajar, KM Dalam";
      } else {
        return "King Bed, Smart TV, AC, WiFi Cepat, Laundry, Kulkas, KM Dalam (Water Heater)";
      }
    }
    
    // Harga antara 1 juta s/d di bawah 1,5 juta
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

  Map<String, dynamic> _generateRoomData(int index) {
    double calculatedPrice = 850000.0 + (index * 350000);
    final detail = baliDetails[index % baliDetails.length];
    
    return {
      "name": "Kamar ${widget.category.title} #0${index + 1}",
      "image": widget.category.images[index],
      "images_list": [
        widget.category.images[index],
        widget.category.images[(index + 1) % widget.category.images.length],
        widget.category.images[(index + 2) % widget.category.images.length],
      ],
      "price": calculatedPrice,
      "location": detail["area"],
      "facilities": _getFacilities(widget.category.title, calculatedPrice),
      "deskripsi": "${detail['deskripsi']}\n\nLokasi Kost sangat strategis dekat kemana2 dekat Kampus, Pusat Perbelanjaan dan Perkantoran, lingkungan kost tenang aman dan nyaman.\n\nHarga Kost Rp.${calculatedPrice.toInt()} /Bulan jika berminat silahkan hubungi pemilik Rumah Kost Telp/WA: 081316363399",
      "fasilitas_dalam_kamar": ["WIFI", "Tempat Tidur", "Lemari Pakaian", "Pemanas Air", "Kamar Mandi di Dalam Kamar"],
      "fasilitas_bersama": ["Ruang Tamu Bersama", "Dapur & Kompor bersama", "Tempat Parkir Mobil/Motor", "Petugas Keamanan / Security"],
      "lokasi_strategis": detail["strategis"],
      "spesifikasi": [
        "Harga Kost Harian: Rp.160.000",
        "Harga Kost Bulanan: Rp.${calculatedPrice.toInt()}",
        "Jumlah Kamar Tidur: 40 Kamar",
        "Jumlah Kamar Mandi: 40",
        "Kamar Mandi di dalam Semua",
        "Jenis Kost: Kost Campur",
        "Ukuran Kamar Kost: 3 x 4 m2",
        "Luas Bangunan Total: 800 m2",
        "Luas Tanah Total: 1000 m2",
        "Jumlah Lantai: 2 Lantai",
        "Garasi Mobil: 30",
        "Tempat Parkir Motor: 40 motor",
        "Daya Listrik: 900 Watt",
        "Sumber Air: PDAM",
        "Alamat Lengkap: ${detail['alamat']}",
      ],
      "details_singkat": [
        {"label": "Nama Kost", "value": detail['nama']},
        {"label": "Alamat", "value": detail['alamat']},
        {"label": "Tipe Kamar", "value": widget.category.title},
        {"label": "Luas Kamar", "value": "12 m²"},
        {"label": "Jumlah Kamar", "value": "40"},
      ]
    };
  }

  @override
  void initState() {
    super.initState();
    displayRooms = List.generate(widget.category.images.length, _generateRoomData);
  }

  void _applyFilter() {
    setState(() {
      if (selectedPriceSort == "Harga Terendah") {
        displayRooms.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (selectedPriceSort == "Harga Tertinggi") {
        displayRooms.sort((a, b) => b['price'].compareTo(a['price']));
      } else {
        displayRooms = List.generate(widget.category.images.length, _generateRoomData);
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

  void _showRoomDetails(BuildContext context, Map<String, dynamic> room) {
    if (!widget.isLoggedIn) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("User Not Found", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          content: const Text("Anda harus login atau register terlebih dahulu untuk dapat memilih dan booking kamar."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF58220),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, SlideRoute(page: const LoginPage()));
              },
              child: const Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      return;
    }

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
                color: Colors.white.withOpacity(0.95), // light modern theme
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
                            itemCount: (room['images_list'] as List).length,
                            onPageChanged: (idx) {
                              setStateSheet(() {
                                currentImageIndex = idx;
                              });
                            },
                            itemBuilder: (context, idx) {
                              String img = room['images_list'][idx];
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
                          children: List.generate((room['images_list'] as List).length, (idx) {
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
                                child: Text(room['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFFF58220), borderRadius: BorderRadius.circular(12)),
                                child: Text("Rp ${room['price'].toInt()}", style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey, size: 18),
                              const SizedBox(width: 6),
                              Text(room['location'], style: const TextStyle(color: Colors.grey, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Section: Deskripsi
                          Text(
                            room['deskripsi'] ?? "",
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
                            const SizedBox(height: 15),
                            const Text("Fasilitas Dalam Kamar:", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            ...(room['fasilitas_dalam_kamar'] as List<String>).map((item) => Text("- $item", style: const TextStyle(color: Colors.black54))),
                            
                            const SizedBox(height: 15),
                            const Text("Fasilitas Bersama:", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            ...(room['fasilitas_bersama'] as List<String>).map((item) => Text("- $item", style: const TextStyle(color: Colors.black54))),

                            const SizedBox(height: 15),
                            const Text("Lokasi Sangat Strategis:", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            ...(room['lokasi_strategis'] as List<String>).map((item) => Text("- $item", style: const TextStyle(color: Colors.black54))),

                            const SizedBox(height: 15),
                            const Text("Spesifikasi Kost:", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            ...(room['spesifikasi'] as List<String>).map((item) => Text("- $item", style: const TextStyle(color: Colors.black54))),

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
                          ...(room['details_singkat'] as List).map((detail) => Padding(
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
                            children: (room['fasilitas_dalam_kamar'] as List<String>).map((fasilitas) {
                              return SizedBox(
                                width: (MediaQuery.of(context).size.width - 65) / 2, // 2 columns approx
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
                          const Divider(color: Colors.white24, height: 40),

                          // Section: Fasilitas Umum
                          const Text("Fasilitas Umum", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 15,
                            runSpacing: 10,
                            children: (room['fasilitas_bersama'] as List<String>).map((fasilitas) {
                              return SizedBox(
                                width: (MediaQuery.of(context).size.width - 65) / 2, // 2 columns approx
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
                          Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Kamar ${widget.category.title}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.4)),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          // BAR FILTER (Lokasi & Harga)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              border: const Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                _buildFilterDropdown(
                  icon: Icons.location_on,
                  value: selectedLocation,
                  items: ["Semua Lokasi", "Denpasar", "Sesetan", "Canggu", "Kuta"],
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
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.white,
            style: const TextStyle(color: Colors.black87, fontSize: 12),
            icon: Icon(icon, size: 16, color: const Color(0xFFF58220)),
            items: items.map((String item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return GestureDetector(
      onTap: () => _showRoomDetails(context, room),
      child: Card(
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
    )); // Closes Card and GestureDetector
  }
}

