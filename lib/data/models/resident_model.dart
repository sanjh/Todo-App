class ResidentModel {
  final String id;
  final String name;

  ResidentModel({
    required this.id,
    required this.name,
  });

  factory ResidentModel.fromjson(Map<String, dynamic> json, String id) {
    return ResidentModel(
      id: id,
      name: json['name'],
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'name': name,
    };
  }
}
