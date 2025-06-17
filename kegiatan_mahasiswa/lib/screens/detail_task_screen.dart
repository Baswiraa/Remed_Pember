import 'package:flutter/material.dart';
import 'package:kegiatan_mahasiswa/models/activity.dart';
import 'package:kegiatan_mahasiswa/services/firebase_service.dart';
import 'package:kegiatan_mahasiswa/main.dart';

class DetailTaskScreen extends StatelessWidget {
  const DetailTaskScreen({super.key});

  void _hapusData(BuildContext context, Activity activity) async {
    final FirebaseService _firebaseService = FirebaseService();
    if (activity.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID Kegiatan tidak ditemukan.')),
      );
      return;
    }
    try {
      await _firebaseService.deleteActivity(activity.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kegiatan berhasil dihapus")),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menghapus: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Activity activity =
        ModalRoute.of(context)!.settings.arguments as Activity;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Detail Tugas",
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabel("Nama Kegiatan :"),
            buildBox(activity.namaKegiatan),
            const SizedBox(height: 12),
            buildLabel("Kategori :"),
            buildBox(activity.kategori),
            const SizedBox(height: 12),
            buildLabel("Tanggal :"),
            buildBox(activity.tanggal),
            const SizedBox(height: 12),
            buildLabel("Deskripsi :"),
            buildBox(activity.deskripsi, minHeight: 80),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  buildLabel("Dokumentasi :"),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: activity.foto.isNotEmpty
                        ? Image.asset(
                            activity.foto,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 120,
                              height: 120,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                            ),
                          )
                        : Image.asset(
                            'assets/placeholder.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _hapusData(context, activity),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: lightTextColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: darkTextColor,
      ),
    );
  }

  Widget buildBox(String text, {double minHeight = 48}) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondaryDarkColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: lightTextColor, fontSize: 16),
      ),
    );
  }
}
