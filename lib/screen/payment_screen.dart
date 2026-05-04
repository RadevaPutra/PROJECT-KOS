import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class PaymentScreen extends StatelessWidget {
  final double totalBayar;
  final String namaKamar;

  const PaymentScreen({super.key, required this.totalBayar, required this.namaKamar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Metode Pembayaran", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      body: Column(
        children: [
          // Ringkasan Tagihan (Premium Glass)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
            decoration: BoxDecoration(
              color: const Color(0xFFDAA520).withOpacity(0.15),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(35)),
              border: Border.all(color: const Color(0xFFDAA520).withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Text("TOTAL TAGIHAN", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 15),
                Text(
                  "Rp ${totalBayar.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFFDAA520)),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("Kamar $namaKamar", style: const TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(25),
              children: [
                const Text("Pilih Metode Bayar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                const SizedBox(height: 20),
                
                // E-Wallet Section
                _paymentTile(context, "GoPay / E-Wallet", Icons.account_balance_wallet, const Color(0xFFDAA520), "70001081933053869"),
                _paymentTile(context, "QRIS (Semua E-Wallet)", Icons.qr_code_scanner, const Color(0xFFDEB887), "", isQR: true),
                
                const SizedBox(height: 30),
                const Text("TRANSFER BANK", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 1.2)),
                const SizedBox(height: 15),
                
                // Bank Section
                _paymentTile(context, "Bank BCA", Icons.account_balance, const Color(0xFFDAA520), "7670752148"),
                _paymentTile(context, "Bank Mandiri", Icons.account_balance, const Color(0xFFDEB887), "8870852148"),
                _paymentTile(context, "Bank BNI", Icons.account_balance, const Color(0xFFDAA520), "9970952148"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentTile(BuildContext context, String title, IconData icon, Color color, String detail, {bool isQR = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: () => _showPaymentDetail(context, title, detail, isQR: isQR),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), 
          side: BorderSide(color: const Color(0xFFDAA520).withOpacity(0.3)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFFDAA520), size: 80),
            const SizedBox(height: 20),
            const Text("Instruksi Terkirim!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
            const SizedBox(height: 10),
            const Text(
              "Silahkan kirim foto bukti transfer Anda melalui chat WhatsApp yang baru saja terbuka.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDAA520),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("MENGERTI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sendWhatsAppConfirmation(String method) async {
    String adminNumber = "6281234567890";
    String message = 
        "Halo Admin SobatKos, saya ingin konfirmasi pembayaran.\n\n"
        "*Detail Pesanan:*\n"
        "â€¢ Kamar: $namaKamar\n"
        "â€¢ Metode: $method\n"
        "â€¢ Total: Rp ${totalBayar.toStringAsFixed(0)}\n\n"
        "Saya telah melakukan transfer. Mohon segera diproses. Terima kasih!";

    var whatsappUrl = Uri.parse("https://wa.me/$adminNumber?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    }
  }

  void _showPaymentDetail(BuildContext context, String title, String detail, {bool isQR = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFF110D0A),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
            border: Border.all(color: const Color(0xFFDAA520).withOpacity(0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 30),
              
              Text("Bayar Via $title", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 30),

              if (isQR)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: const Color(0xFFDAA520).withOpacity(0.2), blurRadius: 20)],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/images/qris_sobatkos.png', height: 260, width: 260, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 15),
                      const Text("SCAN QRIS SOBATKOS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 1)),
                    ],
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("NOMOR REKENING / VA", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFDAA520).withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectableText(
                            detail,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFDAA520), letterSpacing: 2),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: Color(0xFFDAA520)),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: detail));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nomor disalin")));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDAA520),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showSuccessDialog(context);
                    _sendWhatsAppConfirmation(title);
                  },
                  child: const Text("KONFIRMASI PEMBAYARAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }


  Widget _buildBankIcon(String path, double width) {
    return Image.asset(
      path,
      width: width,
      errorBuilder: (context, error, stackTrace) => const SizedBox(), // Sembunyikan jika gambar belum ada
    );
  }
}

