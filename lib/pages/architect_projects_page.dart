import 'package:flutter/material.dart';
import '../services/project_service.dart';
import '../models/project.dart';
import '../core/theme.dart';
import '../widgets/add_project.dart';
import '../widgets/project_list_item.dart';

class ArchitectProjectsPage extends StatefulWidget {
  const ArchitectProjectsPage({super.key});

  @override
  State<ArchitectProjectsPage> createState() => _ArchitectProjectsPageState();
}

class _ArchitectProjectsPageState extends State<ArchitectProjectsPage> {
  final ProjectService _projectService = ProjectService();
  final List<Project> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() => _isLoading = true);
    try {
      final projects = await _projectService.getProjects();
      if (mounted) {
        setState(() {
          _projects.clear();
          _projects.addAll(projects);
          _isLoading = false;
        });

        if (_projects.isEmpty) {
          print('DEBUG: Project list is empty from server');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat memuat proyek: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddProject(
        onSave: (success) {
          if (success) {
            _loadProjects();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Proyek berhasil ditambahkan!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Kelola Proyek',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProjects),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProjects,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _projects.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: _buildEmptyState(),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _projects.length,
                itemBuilder: (context, index) {
                  final project = _projects[index];
                  return ProjectListItem(
                    project: project,
                    onLoadProjects: _loadProjects,
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProjectDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Belum ada proyek',
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddProjectDialog,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Buat Proyek Pertama',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _loadProjects,
            icon: const Icon(Icons.refresh),
            label: const Text('Muat Ulang Data'),
          ),
        ],
      ),
    );
  }
}
