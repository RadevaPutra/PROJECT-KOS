import 'package:flutter/material.dart';
import 'dart:ui';
import '../model/sobatkos_models.dart';
import '../service/api_service.dart';
import 'payment_screen.dart';

class Voucher {
  final String nama;
  final double diskon;

  Voucher(this.nama, this.diskon);
}

class BookingPage extends StatefulWidget {
  final Room room;
  const BookingPage({Key? key, required this.room}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _durasi = 1;
  String _tipeBayar = "Lunas";
  Voucher? _selectedVoucher;

  final List<Voucher> _vouchers = [
    Voucher("Weekend Diskon 10%", 0.1),
    Voucher("Promo Mahasiswa Baru 15%", 0.15),
    Voucher("Cashback Kemerdekaan 20%", 0.20),
  ];

  @override
  Widget build(BuildContext context) {
    double totalSewa = widget.room.harga * _durasi;
    
    double diskonNominal = 0.0;
    if (_selectedVoucher != null) {
      diskonNominal = totalSewa * _selectedVoucher!.diskon;
    }
    double totalSetelahDiskon = totalSewa - diskonNominal;

    double harusBayar = (_tipeBayar == "DP") ? totalSetelahDiskon * 0.2 : totalSetelahDiskon;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Konfirmasi Booking", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(25),
              children: [
                // Room Info Summary (Glassmorphism)
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: widget.room.gambar.startsWith('assets/')
                            ? Image.asset(
                                widget.room.gambar,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
                              )
                            : Image.network(
                                "${ApiService.BASE_URL}/image/${widget.room.gambar}",
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
                              ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kamar ${widget.room.nomorKamar}",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Rp ${widget.room.harga.toStringAsFixed(0)} / bulan",
                              style: const TextStyle(color: Color(0xFFF58220), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                const Text(
                  "DETAIL PENYEWAAN",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 1.2),
                ),
                const SizedBox(height: 20),

                // Duration Stepper (Glassmorphism)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Durasi Sewa", style: TextStyle(color: Colors.black54, fontSize: 14)),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _durationButton(Icons.remove, () {
                            if (_durasi > 1) setState(() => _durasi--);
                          }),
                          Text(
                            "$_durasi Bulan",
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          _durationButton(Icons.add, () {
                            setState(() => _durasi++);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                const Text("METODE PEMBAYARAN", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _payTypeCard("Lunas", "Bayar Penuh", Icons.check_circle_outline)),
                    const SizedBox(width: 15),
                    Expanded(child: _payTypeCard("DP", "DP 20%", Icons.account_balance_wallet_outlined)),
                  ],
                ),
                const SizedBox(height: 35),

                const Text("VOUCHER DISKON", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Voucher>(
                      isExpanded: true,
                      hint: const Text("Pilih Voucher (Opsional)", style: TextStyle(color: Colors.black54)),
                      value: _selectedVoucher,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                      items: [
                        const DropdownMenuItem<Voucher>(
                          value: null,
                          child: Text("Tidak ada", style: TextStyle(color: Colors.black87)),
                        ),
                        ..._vouchers.map((Voucher v) {
                          return DropdownMenuItem<Voucher>(
                            value: v,
                            child: Text(v.nama, style: const TextStyle(color: Colors.black87)),
                          );
                        }),
                      ],
                      onChanged: (Voucher? newValue) {
                        setState(() {
                          _selectedVoucher = newValue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Summary Card (Premium Glass)
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF58220).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFF58220).withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      _summaryRow("Total Sewa", "Rp ${totalSewa.toStringAsFixed(0)}", false),
                      if (_selectedVoucher != null) ...[
                        const SizedBox(height: 10),
                        _summaryRow("Diskon (${(_selectedVoucher!.diskon * 100).toStringAsFixed(0)}%)", "- Rp ${diskonNominal.toStringAsFixed(0)}", false, color: Colors.red),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(color: Colors.white10),
                      ),
                      _summaryRow("Harus Dibayar", "Rp ${harusBayar.toStringAsFixed(0)}", true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.all(25),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        totalBayar: harusBayar,
                        namaKamar: widget.room.nomorKamar,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF58220),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  shadowColor: const Color(0xFFF58220).withOpacity(0.4),
                ),
                child: const Text(
                  "KONFIRMASI BOOKING",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _durationButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, color: Colors.black87, size: 24),
      ),
    );
  }

  Widget _payTypeCard(String type, String sub, IconData icon) {
    bool isSelected = _tipeBayar == type;
    return GestureDetector(
      onTap: () => setState(() => _tipeBayar = type),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF58220).withOpacity(0.1) : Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFFF58220) : Colors.black12, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFF58220) : Colors.black38, size: 28),
            const SizedBox(height: 12),
            Text(type, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.black87 : Colors.black54, fontSize: 16)),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(fontSize: 10, color: isSelected ? const Color(0xFFF58220) : Colors.black38)),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool isTotal, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: Colors.black54)),
        Text(value, style: TextStyle(
          fontSize: isTotal ? 20 : 16, 
          fontWeight: FontWeight.bold, 
          color: color ?? (isTotal ? const Color(0xFFF58220) : Colors.black87),
        )),
      ],
    );
  }

  Widget _buildErrorImage() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.white.withOpacity(0.1),
      child: const Icon(Icons.room_preferences, color: Colors.white30),
    );
  }
}

