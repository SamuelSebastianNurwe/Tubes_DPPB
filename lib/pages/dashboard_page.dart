import 'dart:io';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/project_service.dart';
import '../core/data.dart';
import '../models/architect.dart';
import '../models/project.dart';
import '../core/theme.dart';
import '../widgets/kartu_arsitek.dart';
import '../widgets/dashboard_project_card.dart';
import 'detail_arsitek_page.dart';
import 'orders_page.dart';
import 'profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  final ProjectService _projectService = ProjectService();
  bool _isLoggedIn = false;
  String _userName = 'Pengguna';
  List<Project> _recentProjects = [];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadProjects();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      final userData = await _authService.getUserData();
      final role = userData['role'];

      if (role == 'arsitek') {
        Navigator.pushReplacementNamed(context, '/architect_dashboard');
        return;
      }

      if (mounted) {
        setState(() {
          _isLoggedIn = true;
          _userName = userData['name'] ?? 'Pengguna';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
        });
      }
    }
  }

  Future<void> _loadProjects() async {
    final projects = await _projectService.getProjects();
    if (!mounted) return;
    setState(() {
      _recentProjects = projects;
    });
  }

  void _onItemTapped(int index) {
    if (index != 0 && !_isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login untuk mengakses fitur ini'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushNamed(context, '/login').then((_) => _checkLoginStatus());
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      const OrdersPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $_userName',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Text(
              'Temukan Arsitek',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProjects,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari arsitek, gaya desain...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Banner/Promo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Konsultasi Gratis!',
                            style: TextStyle(
                              color: AppTheme.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Dapatkan saran awal untuk rumah impianmu.',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // PROJECTS SECTION (NEW)
              if (_recentProjects.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Proyek Terkini',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recentProjects.length,
                    itemBuilder: (context, index) {
                      return DashboardProjectCard(
                        project: _recentProjects[index],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rekomendasi Arsitek',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Lihat Semua'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Architects List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dummyArchitects.length,
                itemBuilder: (context, index) {
                  final architect = dummyArchitects[index];
                  return KartuArsitek(
                    architect: architect,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailArsitekPage(architect: architect),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
