import 'package:flutter/material.dart';
import 'dart:ui';

class AdminUserManagementScreen extends StatelessWidget {
  const AdminUserManagementScreen({super.key});

  final List<Map<String, String>> users = const [
    {"name": "Radeva Putra", "email": "radeva@example.com", "role": "Pencari Kos", "join": "Jan 2026"},
    {"name": "Andi Wijaya", "email": "andi@example.com", "role": "Pencari Kos", "join": "Feb 2026"},
    {"name": "Siti Aminah", "email": "siti@example.com", "role": "Pencari Kos", "join": "Mar 2026"},
    {"name": "Budi Santoso", "email": "budi@example.com", "role": "Pencari Kos", "join": "Mar 2026"},
    {"name": "Dewi Sartika", "email": "dewi@example.com", "role": "Pencari Kos", "join": "Apr 2026"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Data User", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildUserCard(user);
        },
      ),
    );
  }

  Widget _buildUserCard(Map<String, String> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFFDAA520).withOpacity(0.2),
            child: Text(user['name']![0], style: const TextStyle(color: Color(0xFFDAA520), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(user['email']!, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(user['role']!, style: const TextStyle(color: Color(0xFFDAA520), fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("Joined ${user['join']}", style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
