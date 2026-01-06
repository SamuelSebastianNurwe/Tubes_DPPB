import 'package:flutter/material.dart';
import '../services/project_service.dart';

class DeleteProject extends StatefulWidget {
  final String projectId;
  final String projectTitle;
  final Function(bool success) onDelete;

  const DeleteProject({
    super.key,
    required this.projectId,
    required this.projectTitle,
    required this.onDelete,
  });

  @override
  State<DeleteProject> createState() => _DeleteProjectState();
}

class _DeleteProjectState extends State<DeleteProject> {
  bool isDeleting = false;
  final ProjectService _projectService = ProjectService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hapus Proyek'),
      content: Text(
        'Apakah Anda yakin ingin menghapus proyek "${widget.projectTitle}"? Tindakan ini tidak dapat dibatalkan.',
      ),
      actions: [
        TextButton(
          onPressed: isDeleting ? null : () => Navigator.pop(context),
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: isDeleting ? null : _handleDelete,
          child: isDeleting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(
                  'Hapus',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _handleDelete() async {
    setState(() => isDeleting = true);
    final success = await _projectService.deleteProject(widget.projectId);
    if (mounted) {
      setState(() => isDeleting = false);
      Navigator.pop(context);
      widget.onDelete(success);
    }
  }
}
