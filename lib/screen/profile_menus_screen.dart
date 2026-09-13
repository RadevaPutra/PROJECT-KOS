import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
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
  );
}

// --- Informasi Pribadi ---
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController(text: "Gde Radeva");
  final TextEditingController _emailController = TextEditingController(text: "gderadeva@example.com");
  final TextEditingController _phoneController = TextEditingController(text: "081234567890");
  final TextEditingController _instansiController = TextEditingController(text: "Telkom University");

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Color(0xFFF58220), Color(0xFF3577AD)]),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey,
                    backgroundImage: _imageFile != null 
                        ? FileImage(_imageFile!) as ImageProvider
                        : const AssetImage('assets/images/kamar_1.jpg'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFFF58220), shape: BoxShape.circle),
                      child: const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          ModernCard(
            child: Column(
              children: [
                _buildModernTextField("Nama Lengkap", _nameController, Icons.person_outline),
                const SizedBox(height: 20),
                _buildModernTextField("Email", _emailController, Icons.email_outlined),
                const SizedBox(height: 20),
                _buildModernTextField("Nomor Telepon", _phoneController, Icons.phone_android_outlined),
                const SizedBox(height: 20),
                _buildModernTextField("Instansi", _instansiController, Icons.school_outlined),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF58220),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                shadowColor: const Color(0xFFF58220).withOpacity(0.4),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil berhasil diperbarui')),
                );
                Navigator.pop(context);
              },
              child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildModernTextField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: Icon(icon, color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.black12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.black12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFF58220), width: 2)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.4),
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
                Text("Ubah Password", style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text("Pastikan password baru Anda kuat dan sulit ditebak untuk keamanan akun.", style: TextStyle(color: Colors.black54, fontSize: 13)),
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
                backgroundColor: const Color(0xFFF58220),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                shadowColor: const Color(0xFFF58220).withOpacity(0.4),
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
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
        suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.black12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.black12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFF58220), width: 2)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.4),
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
          const Text("PUSH NOTIFICATION", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 15),
          ModernCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildModernSwitch("Promo & Diskon", "Dapatkan info promo terbaru", pushPromo, (v) => setState(() => pushPromo = v)),
                const Divider(color: Colors.black12, height: 1),
                _buildModernSwitch("Status Booking", "Dapatkan update status booking", pushUpdate, (v) => setState(() => pushUpdate = v)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text("EMAIL NOTIFICATION", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
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
      activeColor: const Color(0xFFF58220),
      title: Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
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
          const Text("FAQ - PERTANYAAN POPULER", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 15),
          ModernCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildModernFaqItem("Bagaimana cara booking kamar?"),
                const Divider(color: Colors.black12, height: 1),
                _buildModernFaqItem("Metode pembayaran apa saja?"),
                const Divider(color: Colors.black12, height: 1),
                _buildModernFaqItem("Cara membatalkan booking?"),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text("HUBUNGI KAMI", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
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
      title: Text(question, style: const TextStyle(color: Colors.black87, fontSize: 14)),
      iconColor: const Color(0xFFF58220),
      collapsedIconColor: Colors.black54,
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            "Anda dapat melakukan hal ini langsung dari menu yang tersedia di aplikasi kami. Jika ada kendala, silakan hubungi tim support.",
            style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
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
            decoration: BoxDecoration(color: const Color(0xFFF58220).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFFF58220)),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(color: Colors.black54, fontSize: 13)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.black38),
        ],
      ),
    );
  }
}
