import 'package:injectable/injectable.dart';

import '../entities/entity_info_sensor.dart';
import '../repositories/device_data_repository.dart';

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
