import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/project.dart';
import '../services/project_service.dart';
import '../core/theme.dart';
import 'project_form_fields.dart';

class EditProject extends StatefulWidget {
  final Project project;
  final Function(bool success) onSave;

  const EditProject({super.key, required this.project, required this.onSave});

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  late TextEditingController titleController;
  late TextEditingController budgetController;
  late TextEditingController descController;
  late TextEditingController categoryController;
  String? selectedFilePath;
  bool isSaving = false;
  final ProjectService _projectService = ProjectService();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.project.title);
    budgetController = TextEditingController(
      text: widget.project.budget.toInt().toString(),
    );
    descController = TextEditingController(text: widget.project.description);
    categoryController = TextEditingController(text: widget.project.category);
    selectedFilePath = widget.project.imageUrl;
  }

  @override
  void dispose() {
    titleController.dispose();
    budgetController.dispose();
    descController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      setState(() {
        selectedFilePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Proyek',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            ProjectFormFields.buildTextField(titleController, 'Judul Proyek'),
            const SizedBox(height: 16),
            ProjectFormFields.buildTextField(
              budgetController,
              'Harga',
              isNumber: true,
            ),
            const SizedBox(height: 16),
            ProjectFormFields.buildLabel('Kategori'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: ['2D', '3D'].contains(categoryController.text)
                  ? categoryController.text
                  : '3D',
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: [
                '2D',
                '3D',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                if (val != null) categoryController.text = val;
              },
            ),
            const SizedBox(height: 16),
            ProjectFormFields.buildTextField(
              descController,
              'Deskripsi',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ProjectFormFields.buildLabel('Gambar/File Proyek'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      selectedFilePath == null
                          ? 'Pilih File dari Laptop'
                          : 'File Terpilih',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedFilePath != null) ...[
              const SizedBox(height: 12),
              ProjectFormFields.buildFilePreview(selectedFilePath!),
            ],
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (titleController.text.isEmpty || selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan File harus diisi')),
      );
      return;
    }

    setState(() => isSaving = true);

    final projectData = Project(
      id: widget.project.id,
      title: titleController.text,
      imageUrl: selectedFilePath!,
      progress: 0.0,
      description: descController.text,
      budget: double.tryParse(budgetController.text) ?? 0,
      category: categoryController.text,
    );

    final result = await _projectService.updateProject(
      widget.project.id,
      projectData,
      imageFile: selectedFilePath!.startsWith('http')
          ? null
          : File(selectedFilePath!),
    );

    if (mounted) {
      setState(() => isSaving = false);
      if (result['success'] == true) {
        Navigator.pop(context);
        widget.onSave(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: ${result['message']}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
