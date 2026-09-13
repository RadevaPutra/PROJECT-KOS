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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Data User", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFFF58220).withOpacity(0.1),
            child: Text(user['name']![0], style: const TextStyle(color: Color(0xFFF58220), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name']!, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(user['email']!, style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(user['role']!, style: const TextStyle(color: Color(0xFF2563EB), fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("Joined ${user['join']}", style: const TextStyle(color: Colors.black38, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
