class VisitModel {
  final String id;
  final String staffId;
  final String? companyId;
  final String locationName;
  final double latitude;
  final double longitude;
  final String? photoUrl;
  final String? notes;
  final double? distanceInKm;
  final DateTime createdAt;

  VisitModel({
    required this.id,
    required this.staffId,
    this.companyId,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    this.photoUrl,
    this.notes,
    this.distanceInKm,
    required this.createdAt,
  });

  factory VisitModel.fromMap(Map<String, dynamic> map) {
    return VisitModel(
      id: map['id'],
      staffId: map['staff_id'],
      companyId: map['company_id'],
      locationName: map['location_name'] ?? '',
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      photoUrl: map['photo_url'],
      notes: map['notes'],
      distanceInKm: map['distance_in_km'] != null ? (map['distance_in_km'] as num).toDouble() : null,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'staff_id': staffId,
      'company_id': companyId,
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'photo_url': photoUrl,
      'notes': notes,
      'distance_in_km': distanceInKm,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
