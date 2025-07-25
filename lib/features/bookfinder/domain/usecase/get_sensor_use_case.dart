import 'package:injectable/injectable.dart';

import '../entities/info_sensor.dart';
import '../repositories/device_data_repository.dart';

@lazySingleton
class GetSensorDataUseCase {
  final DeviceRepository repository;

  GetSensorDataUseCase(this.repository);

  Stream<SensorData> getAccelerometerData() {
    return repository.getAccelerometerStream().map((model) => SensorData(
      x: model.x,
      y: model.y,
      z: model.z,
    ));
  }

  Stream<SensorData> getGyroscopeData() {
    return repository.getGyroscopeStream().map((model) => SensorData(
      x: model.x,
      y: model.y,
      z: model.z,
    ));
  }
}
