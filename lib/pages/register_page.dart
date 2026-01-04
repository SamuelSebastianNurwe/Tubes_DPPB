import 'package:flutter/material.dart';
import '../core/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _userFormKey = GlobalKey<FormState>();
  final _architectFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Akun',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.secondaryColor,
          tabs: const [
            Tab(text: 'Sebagai Pengguna'),
            Tab(text: 'Sebagai Arsitek'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildUserForm(), _buildArchitectForm()],
      ),
    );
  }

  Widget _buildUserForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _userFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(label: 'Nama Lengkap', icon: Icons.person),
            const SizedBox(height: 16),
            _buildTextField(label: 'Email', icon: Icons.email),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Password',
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Implement registration logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registrasi Pengguna Berhasil')),
                );
                Navigator.pop(context); // Go back to Login
              },
              child: const Text('Daftar Sekarang'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArchitectForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _architectFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(label: 'Nama Lengkap', icon: Icons.person),
            const SizedBox(height: 16),
            _buildTextField(label: 'Email', icon: Icons.email),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Password',
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Spesialisasi (Contoh: Minimalis, Industrial)',
              icon: Icons.design_services,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Pengalaman (Tahun)',
              icon: Icons.history,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Implement architect registration logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registrasi Arsitek Berhasil')),
                );
                Navigator.pop(context); // Go back to Login
              },
              child: const Text('Daftar Sebagai Arsitek'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.secondaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
