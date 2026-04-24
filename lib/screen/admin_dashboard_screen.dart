import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text("Admin Jaykos", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF007bff),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                 CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFF007bff),
                  child: Icon(Icons.admin_panel_settings, color: Colors.white),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Selamat Datang,", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text("Super Admin!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Statistics Cards
            Row(
              children: [
                Expanded(child: _statCard("Total Kamar", "12", Icons.meeting_room, Colors.blue)),
                const SizedBox(width: 15),
                Expanded(child: _statCard("Booking Baru", "5", Icons.notifications_active, Colors.orange)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _statCard("Lunas", "8", Icons.check_circle, Colors.green)),
                const SizedBox(width: 15),
                Expanded(child: _statCard("Total Laporan", "24", Icons.description, Colors.purple)),
              ],
            ),
            const SizedBox(height: 30),
            
            const Text(
              "Menu Utama",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                _adminMenu(Icons.meeting_room, "Kelola Kamar", "Update data kamar", Colors.blue),
                _adminMenu(Icons.book_online, "Data Booking", "Cek pesanan user", Colors.green),
                _adminMenu(Icons.bar_chart, "Laporan Keuangan", "Statistik bulanan", Colors.orange),
                _adminMenu(Icons.people, "Data User", "Kelola pelanggan", Colors.teal),
                _adminMenu(Icons.support_agent, "Bantuan", "Hubungi pengembang", Colors.indigo),
                _adminMenu(Icons.logout, "Logout", "Keluar aplikasi", Colors.red),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 15),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _adminMenu(IconData icon, String title, String subtitle, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: color),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
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
