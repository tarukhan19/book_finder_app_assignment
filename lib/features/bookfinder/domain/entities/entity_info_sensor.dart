class SensorDataEntity {
  final double x;
  final double y;
  final double z;

  SensorDataEntity({required this.x, required this.y, required this.z});

  factory SensorDataEntity.fromMap(Map<String, dynamic> map) {
    return SensorDataEntity(
      x: (map['x'] ?? 0.0).toDouble(),
      y: (map['y'] ?? 0.0).toDouble(),
      z: (map['z'] ?? 0.0).toDouble(),
    );
  }
}
