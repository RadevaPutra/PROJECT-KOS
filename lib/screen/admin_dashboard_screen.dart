import 'package:flutter/material.dart';
import 'dart:ui';
import 'login_screen.dart';
import 'admin_manage_rooms_screen.dart';
import 'admin_bookings_report_screen.dart';
import 'admin_financial_screen.dart';
import 'admin_user_management_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Admin SobatKos", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Color(0xFFDAA520), Color(0xFFDEB887)]),
                  ),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.admin_panel_settings, color: Color(0xFFDAA520), size: 30),
                  ),
                ),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Selamat Datang,", style: TextStyle(fontSize: 14, color: Colors.white70)),
                    Text("Super Admin!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 35),
            
            // Statistics Cards
            Row(
              children: [
                Expanded(child: _statCard("Total Kamar", "12", Icons.meeting_room, const Color(0xFFDAA520))),
                const SizedBox(width: 15),
                Expanded(child: _statCard("Booking Baru", "5", Icons.notifications_active, const Color(0xFFDEB887))),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _statCard("Lunas", "8", Icons.check_circle, const Color(0xFFDAA520))),
                const SizedBox(width: 15),
                Expanded(child: _statCard("Total Laporan", "24", Icons.description, const Color(0xFFDEB887))),
              ],
            ),
            const SizedBox(height: 35),
            
            const Text(
              "Menu Utama Admin",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _adminMenu(Icons.meeting_room, "Kelola Kamar", "Update data kamar", const Color(0xFFDAA520), () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminManageRoomsScreen()));
                }),
                _adminMenu(Icons.book_online, "Data Booking", "Cek pesanan user", const Color(0xFFDEB887), () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminBookingsReportScreen()));
                }),
                _adminMenu(Icons.bar_chart, "Keuangan", "Statistik bulanan", const Color(0xFFDAA520), () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminFinancialScreen()));
                }),
                _adminMenu(Icons.people, "Data User", "Kelola pelanggan", const Color(0xFFDEB887), () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminUserManagementScreen()));
                }),
                _adminMenu(Icons.logout, "Keluar", "Logout aplikasi", const Color(0xFFEF4444), () {
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }



  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 15),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.white60)),
        ],
      ),
    );
  }

  Widget _adminMenu(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: color),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

