class Activity {
  final String id;
  final String namaKegiatan;
  final String deskripsi;
  final String tanggal;
  final String kategori;
  final String foto;

  Activity({
    required this.id,
    required this.namaKegiatan,
    required this.deskripsi,
    required this.tanggal,
    required this.kategori,
    required this.foto,
  });

  factory Activity.fromJson(String id, Map<String, dynamic> json) {
    return Activity(
      id: id,
      namaKegiatan: json['namaKegiatan'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      tanggal: json['tanggal'] ?? '',
      kategori: json['kategori'] ?? '',
      foto: json['foto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'namaKegiatan': namaKegiatan,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
      'kategori': kategori,
      'foto': foto,
    };
  }
}
