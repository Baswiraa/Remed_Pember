import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:kegiatan_mahasiswa/models/activity.dart'; 

class FirebaseService {
  final DatabaseReference _activitiesRef =
      FirebaseDatabase.instance.ref().child('activities');

  Future<void> addActivity(Activity activity, {File? imageFile}) async {


    final activityData = activity.toJson();
    

    await _activitiesRef.child(activity.id).set(activityData);
  }

  Stream<List<Activity>> getActivities() {
    return _activitiesRef.onValue.map((event) {
      final List<Activity> activities = [];
      final Map<dynamic, dynamic>? activitiesMap = event.snapshot.value as Map?;

      if (activitiesMap != null) {
        activitiesMap.forEach((key, value) {
          activities.add(Activity.fromJson(key as String, Map<String, dynamic>.from(value)));
        });
      }
      return activities;
    });
  }

  Future<void> updateActivity(Activity activity, {File? newImageFile}) async {
    if (activity.id.isEmpty) {
      throw Exception("Activity ID tidak boleh kosong untuk operasi update.");
    }

    final activityData = activity.toJson();

    await _activitiesRef.child(activity.id).update(activityData);
  }

  Future<void> deleteActivity(String activityId) async {

    await _activitiesRef.child(activityId).remove();
  }
}