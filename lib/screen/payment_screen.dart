import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatelessWidget {
  final double totalBayar;
  final String namaKamar;

  const PaymentScreen({super.key, required this.totalBayar, required this.namaKamar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Pembayaran", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Ringkasan Tagihan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
            ),
            child: Column(
              children: [
                const Text("Total Tagihan", style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 10),
                Text(
                  "Rp ${totalBayar.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFF8C00)),
                ),
                const SizedBox(height: 5),
                Text("Kamar $namaKamar", style: const TextStyle(color: Colors.blueGrey, fontSize: 16)),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text("Metode Pembayaran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                
                // E-Wallet Section
                _paymentTile(context, "GoPay", Icons.account_balance_wallet, Colors.blue, "70001081933053869"),
                _paymentTile(context, "QRIS", Icons.qr_code_scanner, Colors.pink, "", isQR: true),
                
                const SizedBox(height: 25),
                const Text("Transfer Bank", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 10),
                
                // Bank Section
                _paymentTile(context, "Bank BCA", Icons.account_balance, Colors.blue.shade900, "7670752148"),
                _paymentTile(context, "Bank Mandiri", Icons.account_balance, Colors.yellow.shade800, "8870852148"),
                _paymentTile(context, "Bank BNI", Icons.account_balance, Colors.orange.shade900, "9970952148"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentTile(BuildContext context, String title, IconData icon, Color color, String detail, {bool isQR = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showPaymentDetail(context, title, detail, isQR: isQR),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("Instruksi Terkirim!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            const Text(
              "Silahkan kirim foto bukti transfer Anda melalui chat WhatsApp yang baru saja terbuka.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C00)),
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mengirim pesan ke WhatsApp
  void _sendWhatsAppConfirmation(String method) async {
    String adminNumber = "6281234567890"; // Ganti dengan nomor WhatsApp Admin Anda (awali dengan 62)
    String message = 
        "Halo Admin Jaykos, saya ingin konfirmasi pembayaran.\n\n"
        "*Detail Pesanan:*\n"
        "• Kamar: $namaKamar\n"
        "• Metode: $method\n"
        "• Total: Rp ${totalBayar.toStringAsFixed(0)}\n\n"
        "Saya telah melakukan transfer. Mohon segera diproses. Terima kasih!";

    var whatsappUrl = Uri.parse("https://wa.me/$adminNumber?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      // Beri pesan jika WhatsApp tidak terinstall
      debugPrint("Tidak bisa membuka WhatsApp");
    }
  }

  void _showPaymentDetail(BuildContext context, String title, String detail, {bool isQR = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Agar rounded corner terlihat
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garis handle atas
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 25),
              
              Text("Detail Pembayaran $title", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),

              if (isQR)
                // Menampilkan Barcode QRIS yang sesuai dengan gambar Anda
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(
                    'assets/images/qris_barcode.png', // Pastikan file image_c12618.png disimpan dengan nama ini di folder assets
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                )
              else
                // Menampilkan Nomor VA atau Rekening
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nomor Rekening / VA", style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectableText(
                            detail, 
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: Color(0xFFFF8C00)),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: detail));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Nomor berhasil disalin")),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 35),
              
              // Tombol Konfirmasi Bayar
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Tutup Bottom Sheet
                    
                    // 1. Kirim pesan ke WhatsApp
                    _sendWhatsAppConfirmation(title); 
                    
                    // 2. Tampilkan dialog sukses di aplikasi
                    _showSuccessDialog(context); 
                  },
                  child: const Text(
                    "SAYA SUDAH BAYAR", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
