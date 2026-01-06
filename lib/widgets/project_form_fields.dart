import 'dart:io';
import 'package:flutter/material.dart';

class ProjectFormFields {
  static Widget buildTextField(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hint,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Sebutkan $hint',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildFilePreview(String path) {
    final isNetwork = path.startsWith('http');
    final isImage =
        path.toLowerCase().endsWith('.jpg') ||
        path.toLowerCase().endsWith('.png') ||
        path.toLowerCase().endsWith('.jpeg');

    if (isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isNetwork
            ? Image.network(path, height: 100, width: 100, fit: BoxFit.cover)
            : Image.file(
                File(path),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.insert_drive_file, color: Colors.blue),
            SizedBox(width: 8),
            Text('File Dokumen', style: TextStyle(color: Colors.blue)),
          ],
        ),
      );
    }
  }

  static Widget buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    );
  }
}
