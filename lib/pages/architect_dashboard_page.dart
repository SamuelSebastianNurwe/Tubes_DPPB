import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/stat_card.dart';
import 'architect_projects_page.dart';
import 'profile_page.dart';

class ArchitectDashboardPage extends StatefulWidget {
  const ArchitectDashboardPage({super.key});

  @override
  State<ArchitectDashboardPage> createState() => _ArchitectDashboardPageState();
}

class _ArchitectDashboardPageState extends State<ArchitectDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ArchitectHomeContent(),
    const ArchitectProjectsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Proyek'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class ArchitectHomeContent extends StatelessWidget {
  const ArchitectHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Halo, Arsitek',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Dashboard Anda',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Section
            Row(
              children: const [
                StatCard(
                  title: 'Total Proyek',
                  value: '24',
                  icon: Icons.folder_open,
                ),
                SizedBox(width: 16),
                StatCard(
                  title: 'Rating',
                  value: '4.8',
                  icon: Icons.star,
                  isRating: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const IncomeCard(
              title: 'Pendapatan Bulan Ini',
              value: 'Rp 15.000.000',
            ),

            const SizedBox(height: 24),

            // Incoming Requests
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Permintaan Masuk',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
              ],
            ),
            _buildRequestCard(
              context,
              'Ibu Sarah',
              'Renovasi Dapur Modern',
              'Rp 5.000.000',
              'Baru saja',
            ),
            _buildRequestCard(
              context,
              'Pak Budi',
              'Desain Rumah 2 Lantai',
              'Rp 12.000.000',
              '2 jam lalu',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(
    BuildContext context,
    String name,
    String project,
    String budget,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.secondaryColor.withAlpha(50),
            child: Text(
              name[0],
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$name • $budget',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
        ],
      ),
    );
  }
}
