import 'dart:io';
import 'package:flutter/material.dart';
import '../models/project.dart';
import '../core/theme.dart';
import 'edit_project.dart';
import 'delete_project.dart';

class ProjectListItem extends StatelessWidget {
  final Project project;
  final VoidCallback onLoadProjects;

  const ProjectListItem({
    super.key,
    required this.project,
    required this.onLoadProjects,
  });

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditProject(
        project: project,
        onSave: (success) {
          if (success) {
            onLoadProjects();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Proyek berhasil diperbarui!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteProject(
        projectId: project.id,
        projectTitle: project.title,
        onDelete: (success) {
          if (success) {
            onLoadProjects();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Proyek berhasil dihapus'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUrl = project.imageUrl.startsWith('http');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isUrl
                    ? Image.network(
                        project.imageUrl,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 80,
                          width: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image),
                        ),
                      )
                    : Image.file(
                        File(project.imageUrl),
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 80,
                          width: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (val) {
                            if (val == 'edit') {
                              _showEditDialog(context);
                            } else if (val == 'delete') {
                              _showDeleteDialog(context);
                            }
                          },
                          icon: const Icon(Icons.more_vert, size: 20),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      project.category,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(), // Placeholder to keep price on the right
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Harga:',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                  Text(
                    'Rp ${project.budget.toInt().toString()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
