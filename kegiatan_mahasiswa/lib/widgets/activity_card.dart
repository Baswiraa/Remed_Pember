import 'package:flutter/material.dart';
import 'package:kegiatan_mahasiswa/models/activity.dart';
import 'package:kegiatan_mahasiswa/main.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onDelete;

  const ActivityCard({
    super.key,
    required this.activity,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, '/detail', arguments: activity);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: secondaryDarkColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: activity.foto.isNotEmpty
                    ? Image.asset(
                        activity.foto,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                        ),
                      )
                    : Image.asset(
                        "assets/placeholder.png",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.namaKegiatan,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: lightTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Tanggal : ${activity.tanggal}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: lightTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.kategori,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: lightTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
