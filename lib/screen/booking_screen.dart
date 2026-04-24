import 'package:flutter/material.dart';
import '../model/jaykos_models.dart';
import '../service/api_service.dart';
import 'payment_screen.dart';

class BookingPage extends StatefulWidget {
  final Room room;
  const BookingPage({Key? key, required this.room}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _durasi = 1;
  String _tipeBayar = "Lunas";

  @override
  Widget build(BuildContext context) {
    double totalSewa = widget.room.harga * _durasi;
    double harusBayar = (_tipeBayar == "DP") ? totalSewa * 0.2 : totalSewa;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Konfirmasi Booking", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFFFF8C00),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Room Info Summary
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!),
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
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Rp ${widget.room.harga.toStringAsFixed(0)} / bulan",
                              style: const TextStyle(color: Color(0xFFFF8C00), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  "Detail Penyewaan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // Duration Stepper replacement
                const Text("Durasi Sewa (Bulan)", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _durationButton(Icons.remove, () {
                      if (_durasi > 1) setState(() => _durasi--);
                    }),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "$_durasi Bulan",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _durationButton(Icons.add, () {
                      setState(() => _durasi++);
                    }),
                  ],
                ),
                const SizedBox(height: 25),

                const Text("Metode Pembayaran", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _payTypeCard("Lunas", "Bayar Penuh", Icons.check_circle_outline)),
                    const SizedBox(width: 15),
                    Expanded(child: _payTypeCard("DP", "DP 20%", Icons.account_balance_wallet_outlined)),
                  ],
                ),
                const SizedBox(height: 40),

                // Summary Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange[50]!, Colors.orange[100]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _summaryRow("Total Harga Sewa", "Rp ${totalSewa.toStringAsFixed(0)}", false),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: Colors.orange),
                      ),
                      _summaryRow("Nominal Harus Bayar", "Rp ${harusBayar.toStringAsFixed(0)}", true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.all(20),
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
                backgroundColor: const Color(0xFFFF8C00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                shadowColor: const Color(0xFFFF8C00).withOpacity(0.4),
              ),
              child: const Text(
                "KONFIRMASI BOOKING",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
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
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _payTypeCard(String type, String sub, IconData icon) {
    bool isSelected = _tipeBayar == type;
    return GestureDetector(
      onTap: () => setState(() => _tipeBayar = type),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF8C00) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? const Color(0xFFFF8C00) : Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(height: 8),
            Text(type, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
            Text(sub, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white70 : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(
          fontSize: isTotal ? 20 : 16, 
          fontWeight: FontWeight.bold, 
          color: isTotal ? Colors.green[700] : Colors.black,
        )),
      ],
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("Booking Berhasil!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Pemesanan Anda telah tercatat dalam sistem.", textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C00), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text("KEMBALI KE BERANDA", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[200],
      child: const Icon(Icons.room_preferences, color: Colors.grey),
    );
  }
}
