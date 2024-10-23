class Wilayah {
  String id;
  String propinsi;
  String kota;
  String kecamatan;
  String lat;
  String lon;

  Wilayah({
    required this.id,
    required this.propinsi,
    required this.kota,
    required this.kecamatan,
    required this.lat,
    required this.lon,
  });

  factory Wilayah.fromJson(Map<String, dynamic> json) {
    return Wilayah(
      id: json['id'] as String,
      propinsi: json['propinsi'] as String,
      kota: json['kota'] as String,
      kecamatan: json['kecamatan'] as String,
      lat: json['lat'] as String,
      lon: json['lon'] as String,
    );
  }
}
