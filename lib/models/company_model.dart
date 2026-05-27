class CompanyModel {
  final String id;
  final String name;
  final int staffCount;
  final int totalVisits;

  CompanyModel({
    required this.id,
    required this.name,
    this.staffCount = 0,
    this.totalVisits = 0,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      staffCount: map['staff_count'] ?? 0,
      totalVisits: map['total_visits'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
