import 'package:flutter/material.dart';
import 'dart:ui';

// --- Reusable Modern Card Wrapper ---
class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const ModernCard({super.key, required this.child, this.padding = const EdgeInsets.all(20)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

// --- Reusable Modern AppBar ---
PreferredSizeWidget _buildModernAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
  );
}

// --- Informasi Pribadi ---
class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildModernAppBar(context, "Informasi Pribadi"),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [Color(0xFFDAA520), Color(0xFFDEB887)]),
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage('assets/images/kamar_1.jpg'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Color(0xFFDAA520), shape: BoxShape.circle),
                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          ModernCard(
            child: Column(
              children: [
                _buildModernTextField("Nama Lengkap", "Gde Radeva", Icons.person_outline),
                const SizedBox(height: 20),
                _buildModernTextField("Email", "gderadeva@example.com", Icons.email_outlined),
                const SizedBox(height: 20),
                _buildModernTextField("Nomor Telepon", "081234567890", Icons.phone_android_outlined),
                const SizedBox(height: 20),
                _buildModernTextField("Instansi", "Telkom University", Icons.school_outlined),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDAA520),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                shadowColor: const Color(0xFFDAA520).withOpacity(0.4),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildModernTextField(String label, String initialValue, IconData icon) {
    return TextFormField(
      initialValue: initialValue,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFDAA520), width: 2)),
        filled: true,
        fillColor: Colors.black.withOpacity(0.1),
      ),
    );
  }
}

// --- Keamanan & Password ---
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildModernAppBar(context, "Keamanan & Password"),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ubah Password", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text("Pastikan password baru Anda kuat dan sulit ditebak untuk keamanan akun.", style: TextStyle(color: Colors.white60, fontSize: 13)),
              ],
            ),
          ),
          ModernCard(
            child: Column(
              children: [
                _buildModernPasswordField("Password Lama"),
                const SizedBox(height: 20),
                _buildModernPasswordField("Password Baru"),
                const SizedBox(height: 20),
                _buildModernPasswordField("Konfirmasi Password Baru"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDAA520),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                shadowColor: const Color(0xFFDAA520).withOpacity(0.4),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password berhasil diubah')));
                Navigator.pop(context);
              },
              child: const Text("Ubah Password Now", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildModernPasswordField(String label) {
    return TextFormField(
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
        suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFDAA520), width: 2)),
        filled: true,
        fillColor: Colors.black.withOpacity(0.1),
      ),
    );
  }
}

// --- Notifikasi ---
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool pushPromo = true;
  bool pushUpdate = true;
  bool emailPromo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildModernAppBar(context, "Notifikasi"),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const Text("PUSH NOTIFICATION", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 15),
          ModernCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildModernSwitch("Promo & Diskon", "Dapatkan info promo terbaru", pushPromo, (v) => setState(() => pushPromo = v)),
                const Divider(color: Colors.white10, height: 1),
                _buildModernSwitch("Status Booking", "Dapatkan update status booking", pushUpdate, (v) => setState(() => pushUpdate = v)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text("EMAIL NOTIFICATION", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 15),
          ModernCard(
            padding: EdgeInsets.zero,
            child: _buildModernSwitch("Email Marketing", "Penawaran eksklusif via email", emailPromo, (v) => setState(() => emailPromo = v)),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSwitch(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF22D3EE),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
    );
  }
}

// --- Bantuan ---
class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildModernAppBar(context, "Pusat Bantuan"),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const Text("FAQ - PERTANYAAN POPULER", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 15),
          ModernCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildModernFaqItem("Bagaimana cara booking kamar?"),
                const Divider(color: Colors.white10, height: 1),
                _buildModernFaqItem("Metode pembayaran apa saja?"),
                const Divider(color: Colors.white10, height: 1),
                _buildModernFaqItem("Cara membatalkan booking?"),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text("HUBUNGI KAMI", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 15),
          _buildContactCard(Icons.email_outlined, "Email Support", "support@sobatkos.com"),
          const SizedBox(height: 15),
          _buildContactCard(Icons.phone_outlined, "Hotline 24/7", "0811-2233-4455"),
        ],
      ),
    );
  }

  Widget _buildModernFaqItem(String question) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(color: Colors.white, fontSize: 14)),
      iconColor: const Color(0xFFDAA520),
      collapsedIconColor: Colors.white60,
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            "Anda dapat melakukan hal ini langsung dari menu yang tersedia di aplikasi kami. Jika ada kendala, silakan hubungi tim support.",
            style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.5),
          ),
        )
      ],
    );
  }

  Widget _buildContactCard(IconData icon, String title, String value) {
    return ModernCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFDAA520).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFFDAA520)),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(color: Colors.white60, fontSize: 13)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.white30),
        ],
      ),
    );
  }
}
