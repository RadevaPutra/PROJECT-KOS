import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'screen/login_screen.dart';

void main() => runApp(const JaykosApp());

class JaykosApp extends StatelessWidget {
  const JaykosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jaykos Room Booking',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF8C00), // Warna Orange Jaykos
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8C00),
          primary: const Color(0xFFFF8C00),
          secondary: const Color(0xFF007BFF),
        ),
        fontFamily: 'Segoe UI',
        useMaterial3: true,
      ),
      home: const MainNavigation(), // Kita mulai dari Navigasi Utama
    );
  }
}

// --- NAVIGASI UTAMA ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = [
    HomeScreenContent(),
    FavoriteScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF8C00),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// --- HALAMAN 2: FAVORIT ---
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  // Contoh data yang sudah difavoritkan
  static final List<Map<String, String>> favRooms = [
    {"name": "Kamar 01", "price": "1.500.000", "img": "assets/images/kamar_1.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Koleksi Favorit", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: favRooms.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favRooms.length,
              itemBuilder: (context, i) => _buildFavCard(favRooms[i]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text("Belum ada kamar favorit", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildFavCard(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            item['img']!,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(width: 60, height: 60, color: Colors.grey[200]),
          ),
        ),
        title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Rp ${item['price']}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.favorite, color: Colors.red),
      ),
    );
  }
}

// --- MODEL DATA TRANSAKSI ---
class TransactionModel {
  final String roomName;
  final String date;
  final String amount;
  final String method;
  final String status;
  final Color statusColor;

  TransactionModel({
    required this.roomName,
    required this.date,
    required this.amount,
    required this.method,
    required this.status,
    required this.statusColor,
  });
}

// --- HALAMAN 3: RIWAYAT ---
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Data ini nantinya bisa diisi dari database atau shared_preferences
  static final List<TransactionModel> transactions = [
    TransactionModel(
      roomName: "Kamar 01",
      date: "24 Apr 2026",
      amount: "1.500.000",
      method: "GoPay",
      status: "Berhasil",
      statusColor: Colors.green,
    ),
    TransactionModel(
      roomName: "Kamar 03",
      date: "24 Apr 2026",
      amount: "300.000",
      method: "Bank BCA (DP)",
      status: "Menunggu",
      statusColor: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark mode background
      appBar: AppBar(
        title: const Text("Riwayat Booking", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSummaryHeader(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(25),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return _buildTimelineCard(transactions[index], index == transactions.length - 1);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statTile("Total", "${transactions.length}"),
          _statTile("Berhasil", "1"),
          _statTile("Pending", "1"),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }

  Widget _buildTimelineCard(TransactionModel data, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: data.statusColor,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: data.statusColor.withOpacity(0.5), blurRadius: 8)],
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 80, color: Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 25),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.roomName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Rp ${data.amount}", style: const TextStyle(color: Color(0xFFFF8C00), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(data.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const Divider(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: data.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(data.status, style: TextStyle(color: data.statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    Text(data.method, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

// --- HALAMAN 4: PROFIL ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header Profil dengan Gradasi
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))],
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: AssetImage('assets/avatar.jpg'), // Pastikan file ini ada
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Gde Radeva",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Student @ Telkom University",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _profileMenu(Icons.person_outline, "Informasi Pribadi"),
                _profileMenu(Icons.security, "Keamanan & Password"),
                _profileMenu(Icons.notifications_none, "Notifikasi"),
                _profileMenu(Icons.help_center_outlined, "Bantuan"),
                const Divider(indent: 20, endIndent: 20),
                _profileMenu(
                  Icons.logout, 
                  "Keluar", 
                  color: Colors.red,
                  onTap: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => const LoginPage())
                    );
                  }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _profileMenu(IconData icon, String title, {Color color = Colors.black87, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap ?? () {},
    );
  }
}