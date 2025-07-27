import 'package:injectable/injectable.dart';

import '../entities/entity_info_sensor.dart';
import '../repositories/device_data_repository.dart';

/*
-- This GetSensorDataUseCase class is a use case in your clean architecture that provides
a stream of gyroscope sensor data from the repository layer.


 */
@lazySingleton
class GetSensorDataUseCase {
  final DeviceRepository repository;

  GetSensorDataUseCase(this.repository);

  Stream<SensorDataEntity> getGyroscopeData() {
    return repository.getGyroscopeStream().map((model) => SensorDataEntity(
      x: model.x,
      y: model.y,
      z: model.z,
    ));
  }
}
