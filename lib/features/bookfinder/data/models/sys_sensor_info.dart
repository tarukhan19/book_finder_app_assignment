class SensorDataModel {
  final double x;
  final double y;
  final double z;

  SensorDataModel({
    required this.x,
    required this.y,
    required this.z,
  });

  factory SensorDataModel.fromMap(Map<String, dynamic> map) {
    return SensorDataModel(
      x: (map['x'] ?? 0.0).toDouble(),
      y: (map['y'] ?? 0.0).toDouble(),
      z: (map['z'] ?? 0.0).toDouble(),
    );
  }
}