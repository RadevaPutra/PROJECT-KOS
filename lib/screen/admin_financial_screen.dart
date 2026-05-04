import 'package:flutter/material.dart';
import 'dart:ui';

class AdminFinancialScreen extends StatelessWidget {
  const AdminFinancialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Laporan Keuangan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
            _buildMainStatsCard(),
            const SizedBox(height: 30),
            const Text("Detail Pendapatan", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildIncomeDetail("Kamar Luxury", 0.75, "Rp 45.000.000", const Color(0xFFDAA520)),
            _buildIncomeDetail("Kamar Modern", 0.45, "Rp 12.600.000", const Color(0xFFDEB887)),
            _buildIncomeDetail("Kamar Standard", 0.30, "Rp 8.400.000", Colors.blueGrey),
            const SizedBox(height: 40),
            _buildRecentTransactions(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFDAA520).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDAA520).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          const Text("Total Pendapatan", style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 10),
          const Text("Rp 66.000.000", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _smallStat("Bulan Ini", "Rp 12.5M", Icons.trending_up, Colors.greenAccent),
              _smallStat("Target", "Rp 80M", Icons.flag, Colors.blueAccent),
            ],
          )
        ],
      ),
    );
  }

  Widget _smallStat(String label, String val, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildIncomeDetail(String title, double progress, String amount, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text(amount, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Transaksi Terakhir", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _txRow("Pembayaran #1024", "Rp 1.500.000", "2 Jam Lalu"),
          const Divider(color: Colors.white10),
          _txRow("Pembayaran #1023", "Rp 3.600.000", "5 Jam Lalu"),
          const Divider(color: Colors.white10),
          _txRow("Pembayaran #1022", "Rp 1.200.000", "Kemarin"),
        ],
      ),
    );
  }

  Widget _txRow(String title, String amt, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          Text(amt, style: const TextStyle(color: Color(0xFFDAA520), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
