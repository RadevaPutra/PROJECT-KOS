import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, 
        backgroundColor: Colors.transparent, 
        iconTheme: const IconThemeData(color: Colors.black)
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.lock_reset, size: 100, color: Color(0xFFFF8C00)),
            const SizedBox(height: 20),
            const Text("Lupa Password?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "Masukkan email terdaftar. Kami akan mengirimkan instruksi untuk mengatur ulang password Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const TextField(decoration: InputDecoration(labelText: "Email Terdaftar", border: OutlineInputBorder())),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C00)),
                onPressed: () {
                   // Logic Reset Password
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text("Instruksi reset telah dikirim ke email Anda")),
                   );
                },
                child: const Text("Kirim Instruksi", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
