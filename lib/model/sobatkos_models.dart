import 'package:flutter/material.dart';

class Room {
  final int id;
  final String nomorKamar;
  final double harga;
  final String gambar;
  final String deskripsi;
  final String status;

  Room({
    required this.id,
    required this.nomorKamar,
    required this.harga,
    required this.gambar,
    required this.deskripsi,
    required this.status,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? 0,
      nomorKamar: json['nomor_kamar'] ?? json['nomorKamar'] ?? "",
      harga: (json['harga'] ?? 0).toDouble(),
      gambar: json['gambar'] ?? "",
      deskripsi: json['deskripsi'] ?? "",
      status: json['status'] ?? "",
    );
  }
}

class Booking {
  final String namaPenyewa;
  final String nomorKamar;
  final int durasi;
  final String tipePembayaran;
  final double nominalBayar;
  final String statusPembayaran;
  final DateTime tanggal;

  Booking({
    required this.namaPenyewa,
    required this.nomorKamar,
    required this.durasi,
    required this.tipePembayaran,
    required this.nominalBayar,
    required this.statusPembayaran,
    required this.tanggal,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      namaPenyewa: json['nama_penyewa'] ?? "",
      nomorKamar: json['nomor_kamar'] ?? "",
      durasi: json['durasi'] ?? 0,
      tipePembayaran: json['tipe_pembayaran'] ?? "",
      nominalBayar: (json['nominal_bayar'] ?? 0).toDouble(),
      statusPembayaran: json['status_pembayaran'] ?? "",
      tanggal: json['tanggal'] != null ? DateTime.parse(json['tanggal']) : DateTime.now(),
    );
  }
}

class RoomCategory {
  final String title;
  final List<String> images;
  final IconData icon;

  RoomCategory({required this.title, required this.images, required this.icon});
}
