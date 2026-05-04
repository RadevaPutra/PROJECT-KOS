import 'package:flutter/material.dart';
import 'dart:ui';
import '../model/sobatkos_models.dart';

class AdminBookingsReportScreen extends StatelessWidget {
  const AdminBookingsReportScreen({super.key});

  // Mock data for bookings
  static final List<Booking> bookings = [
    Booking(
      namaPenyewa: "Radeva Putra",
      nomorKamar: "Kamar Luxury #01",
      durasi: 12,
      tipePembayaran: "Full Payment",
      nominalBayar: 15000000,
      statusPembayaran: "Lunas",
      tanggal: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Booking(
      namaPenyewa: "Sobat Kos User",
      nomorKamar: "Kamar Modern #02",
      durasi: 6,
      tipePembayaran: "DP 50%",
      nominalBayar: 3600000,
      statusPembayaran: "Menunggu",
      tanggal: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Booking(
      namaPenyewa: "Andi Wijaya",
      nomorKamar: "Kamar Standard #05",
      durasi: 1,
      tipePembayaran: "Monthly",
      nominalBayar: 1200000,
      statusPembayaran: "Lunas",
      tanggal: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Data Booking", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    Color statusColor = booking.statusPembayaran == "Lunas" ? Colors.greenAccent : Colors.orangeAccent;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(booking.namaPenyewa, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: Text(booking.statusPembayaran, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.meeting_room, color: Color(0xFFDAA520), size: 16),
              const SizedBox(width: 8),
              Text(booking.nomorKamar, style: const TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white54, size: 14),
              const SizedBox(width: 8),
              Text("${booking.tanggal.day}/${booking.tanggal.month}/${booking.tanggal.year}", style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const Spacer(),
              Text("Rp ${booking.nominalBayar.toInt()}", style: const TextStyle(color: Color(0xFFDAA520), fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(color: Colors.white10, height: 25),
          Row(
            children: [
              Text("Durasi: ${booking.durasi} Bulan", style: const TextStyle(color: Colors.white60, fontSize: 13)),
              const Spacer(),
              Text(booking.tipePembayaran, style: const TextStyle(color: Colors.white60, fontSize: 13)),
            ],
          )
        ],
      ),
    );
  }
}
