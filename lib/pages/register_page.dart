import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _authService = AuthService();
  bool _isLoading = false;

  // User Form Controllers
  final _userFormKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();

  // Architect Form Controllers
  final _architectFormKey = GlobalKey<FormState>();
  final _archNameController = TextEditingController();
  final _archEmailController = TextEditingController();
  final _archPasswordController = TextEditingController();
  final _archSpecializationController = TextEditingController();
  final _archExperienceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPasswordController.dispose();
    _archNameController.dispose();
    _archEmailController.dispose();
    _archPasswordController.dispose();
    _archSpecializationController.dispose();
    _archExperienceController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister({
    required String name,
    required String email,
    required String password,
    required String role,
    String? specialization,
    int? experience,
  }) async {
    setState(() {
      _isLoading = true;
    });

    final result = await _authService.register(
      name: name,
      email: email,
      password: password,
      role: role,
      specialization: specialization,
      experience: experience,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi Berhasil! Silakan Login.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Go back to Login
    } else {
      String errorMessage = result['message'] ?? 'Registration failed';
      if (result['errors'] != null) {
        // Simple error formatting if errors is a Map (Laravel validation errors)
        final errors = result['errors'] as Map<String, dynamic>;
        errorMessage = errors.values.join('\n');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
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
            _buildTextField(
              controller: _userNameController,
              label: 'Nama Lengkap',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _userEmailController,
              label: 'Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _userPasswordController,
              label: 'Password',
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_userFormKey.currentState!.validate()) {
                        _handleRegister(
                          name: _userNameController.text,
                          email: _userEmailController.text,
                          password: _userPasswordController.text,
                          role: 'user',
                        );
                      }
                    },
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text('Daftar Sekarang'),
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
            _buildTextField(
              controller: _archNameController,
              label: 'Nama Lengkap',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _archEmailController,
              label: 'Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _archPasswordController,
              label: 'Password',
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _archSpecializationController,
              label: 'Spesialisasi (Contoh: Minimalis, Industrial)',
              icon: Icons.design_services,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _archExperienceController,
              label: 'Pengalaman (Tahun)',
              icon: Icons.history,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_architectFormKey.currentState!.validate()) {
                        _handleRegister(
                          name: _archNameController.text,
                          email: _archEmailController.text,
                          password: _archPasswordController.text,
                          role: 'architect',
                          specialization: _archSpecializationController.text,
                          experience: int.tryParse(
                            _archExperienceController.text,
                          ),
                        );
                      }
                    },
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text('Daftar Sebagai Arsitek'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
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
