import 'package:flutter/material.dart';
import 'dart:ui';
import 'screen/home_screen.dart';
import 'screen/login_screen.dart';
import 'widgets/animated_modern_background.dart';
import 'screen/profile_menus_screen.dart';

void main() => runApp(const SobatKosApp());

class SobatKosApp extends StatelessWidget {
  const SobatKosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SobatKos',
      theme: ThemeData(
        primaryColor: const Color(0xFFDAA520), // Goldenrod
        scaffoldBackgroundColor: Colors.transparent, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFDAA520),
          primary: const Color(0xFFDAA520),
          secondary: const Color(0xFFDEB887),
        ),
        fontFamily: 'Segoe UI',
        useMaterial3: true,
      ),
      builder: (context, child) {
        return AnimatedModernBackground(child: child);
      },
      home: const MainNavigation(isLoggedIn: false), // Default not logged in
    );
  }
}

// --- NAVIGASI UTAMA ---
class MainNavigation extends StatefulWidget {
  final bool isLoggedIn;
  const MainNavigation({super.key, this.isLoggedIn = false});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoggedIn) {
      // If not logged in, just show HomeScreen without bottom navigation
      return Scaffold(
        body: HomeScreenContent(isLoggedIn: false),
      );
    }

    final List<Widget> pages = [
      HomeScreenContent(isLoggedIn: true),
      const FavoriteScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true, // Allow body to flow under the floating navbar
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)], // Premium dark slate gradient
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDAA520).withOpacity(0.3), // Gold shadow glow
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFFDEB887), // BurlyWood
            unselectedItemColor: Colors.white54,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'Favorit'),
              BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'Riwayat'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }
}

// --- HALAMAN 2: FAVORIT ---
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  static final List<Map<String, String>> favRooms = [
    {"name": "Kamar 01", "price": "1.500.000", "img": "assets/images/kamar_1.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Koleksi Favorit", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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
          const Text("Belum ada kamar favorit", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildFavCard(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            item['img']!,
            width: 65,
            height: 65,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(width: 65, height: 65, color: Colors.grey[200]),
          ),
        ),
        title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text("Rp ${item['price']}", style: const TextStyle(color: Color(0xFFDAA520), fontWeight: FontWeight.bold)),
        ),
        trailing: const Icon(Icons.favorite, color: Colors.redAccent, size: 28),
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

  static final List<TransactionModel> transactions = [
    TransactionModel(
      roomName: "Kamar 01",
      date: "24 Apr 2026",
      amount: "1.500.000",
      method: "GoPay",
      status: "Berhasil",
      statusColor: const Color(0xFF10B981), // Emerald
    ),
    TransactionModel(
      roomName: "Kamar 03",
      date: "24 Apr 2026",
      amount: "300.000",
      method: "Bank BCA (DP)",
      status: "Menunggu",
      statusColor: const Color(0xFFF59E0B), // Amber
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1), // Glassy background
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
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
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
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
              Container(width: 2, height: 80, color: Colors.white24),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 25),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.roomName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Rp ${data.amount}", style: const TextStyle(color: Color(0xFFDAA520), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(data.date, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: data.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(data.status, style: TextStyle(color: data.statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    Text(data.method, style: const TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
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
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Header Profil dengan Gradasi Modern Blue
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDAA520), Color(0xFFDEB887)], // Goldenrod to BurlyWood
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 8))],
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
                      backgroundImage: AssetImage('assets/images/kamar_1.jpg'), // Fallback placeholder
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "SobatKos User",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Modern Living Experience",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _profileMenu(Icons.person_outline, "Informasi Pribadi", onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoScreen()));
                }),
                _profileMenu(Icons.security, "Keamanan & Password", onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityScreen()));
                }),
                _profileMenu(Icons.notifications_none, "Notifikasi", onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
                }),
                _profileMenu(Icons.help_center_outlined, "Bantuan", onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterScreen()));
                }),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(indent: 20, endIndent: 20, color: Colors.black12),
                ),
                _profileMenu(
                  Icons.logout, 
                  "Keluar", 
                  color: const Color(0xFFEF4444), // Red-500
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
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

  Widget _profileMenu(IconData icon, String title, {Color color = const Color(0xFF1E293B), VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08), 
          borderRadius: BorderRadius.circular(12)
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
      onTap: onTap ?? () {},
    );
  }
}