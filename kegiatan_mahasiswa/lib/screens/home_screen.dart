import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kegiatan_mahasiswa/models/activity.dart';
import 'package:kegiatan_mahasiswa/services/firebase_service.dart';
import 'package:kegiatan_mahasiswa/main.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Daily Activity",
            style: TextStyle(
              color: primaryDarkColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<Activity>>(
            stream: _firebaseService.getActivities(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Terjadi kesalahan: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada kegiatan",
                    style: TextStyle(color: darkTextColor),
                  ),
                );
              }

              final List<Activity> activities = snapshot.data!;
              activities.sort((a, b) {
                try {
                  final DateFormat formatter = DateFormat('yyyy-MM-dd');
                  final DateTime dateA = formatter.parse(a.tanggal);
                  final DateTime dateB = formatter.parse(b.tanggal);
                  return dateB.compareTo(dateA);
                } catch (e) {
                  return 0;
                }
              });

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/detail', arguments: activity);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
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
                              child: Image.asset(
                                activity.foto.isNotEmpty ? activity.foto : "assets/placeholder.png",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                                ),
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
                },
              );
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
