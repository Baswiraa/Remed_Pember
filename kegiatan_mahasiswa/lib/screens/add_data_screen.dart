import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:kegiatan_mahasiswa/models/activity.dart';
import 'package:kegiatan_mahasiswa/services/firebase_service.dart';
import 'package:kegiatan_mahasiswa/main.dart';
import 'package:firebase_database/firebase_database.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();

  String namaKegiatan = '';
  String deskripsi = '';
  String tanggal = '';
  String kategori = 'Kuliah';
  bool tanggalError = false;
  File? _pickedImage;

  final kategoriList = ['Kuliah', 'Organisasi', 'Lainnya'];
  late TextEditingController _tanggalController;

  @override
  void initState() {
    super.initState();
    _tanggalController = TextEditingController(text: tanggal);
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto dari Kamera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _simpanKegiatan() async {
    final isValidForm = _formKey.currentState!.validate();
    final isTanggalValid = tanggal.trim().isNotEmpty;

    setState(() {
      tanggalError = !isTanggalValid;
    });

    if (isValidForm && isTanggalValid) {
      final String newActivityId = FirebaseDatabase.instance.ref("activities").push().key!;

      String photoPath = 'assets/placeholder.png';
      if (_pickedImage != null) {
      }

      final newActivity = Activity(
        id: newActivityId,
        namaKegiatan: namaKegiatan,
        deskripsi: deskripsi,
        tanggal: tanggal,
        kategori: kategori,
        foto: photoPath,
      );

      try {
        await _firebaseService.addActivity(newActivity, imageFile: _pickedImage);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kegiatan berhasil disimpan!")),
        );
        Navigator.pop(context, true);
      } catch (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menyimpan: $error")));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryDarkColor,
              onPrimary: lightTextColor,
              onSurface: darkTextColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryDarkColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        tanggal = DateFormat('yyyy-MM-dd').format(picked);
        _tanggalController.text = tanggal;
        tanggalError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Tambah Data",
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    buildLabel("Nama Kegiatan :"),
                    buildBoxInput(
                      child: TextFormField(
                        controller: TextEditingController(text: namaKegiatan),
                        style: const TextStyle(color: lightTextColor),
                        decoration: InputDecoration(
                          hintText: 'Masukkan nama kegiatan',
                          hintStyle: TextStyle(color: lightTextColor.withOpacity(0.7)),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Wajib diisi' : null,
                        onChanged: (value) => namaKegiatan = value,
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildLabel("Kategori :"),
                    buildBoxInput(
                      child: DropdownButtonFormField<String>(
                        value: kategori,
                        dropdownColor: secondaryDarkColor,
                        iconEnabledColor: lightTextColor,
                        style: const TextStyle(color: lightTextColor),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        ),
                        items: kategoriList.map((kat) {
                          return DropdownMenuItem(
                            value: kat,
                            child: Text(
                              kat,
                              style: const TextStyle(color: lightTextColor),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => kategori = value);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildLabel("Tanggal :"),
                    buildBoxInput(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _tanggalController,
                            style: const TextStyle(color: lightTextColor),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration: InputDecoration(
                              hintText: 'Pilih tanggal',
                              hintStyle: TextStyle(color: lightTextColor.withOpacity(0.7)),
                              suffixIcon: Icon(Icons.calendar_today, color: lightTextColor.withOpacity(0.7)),
                            ),
                          ),
                          if (tanggalError)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                "Tanggal wajib diisi",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildLabel("Deskripsi (Optional):"),
                    buildBoxInput(
                      minHeight: 80,
                      child: TextFormField(
                        controller: TextEditingController(text: deskripsi),
                        style: const TextStyle(color: lightTextColor),
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Masukkan deskripsi',
                          hintStyle: TextStyle(color: lightTextColor.withOpacity(0.7)),
                        ),
                        onChanged: (value) => deskripsi = value,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          buildLabel("Dokumentasi :"),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _showImageSourceActionSheet(context),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: primaryDarkColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                image: _pickedImage != null
                                    ? DecorationImage(
                                        image: FileImage(_pickedImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _pickedImage == null
                                  ? Icon(Icons.camera_alt, size: 50, color: darkTextColor.withOpacity(0.7))
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanKegiatan,
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: lightTextColor),
                  ),
                ),
              ),
            ],
          ),
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

  Widget buildBoxInput({required Widget child, double minHeight = 48}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: secondaryDarkColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
