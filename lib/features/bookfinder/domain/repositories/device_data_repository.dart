import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_info_sensor.dart';
import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/entity_info_system.dart';

abstract class DeviceRepository {
  Future<SystemInfoEntity> getSystemInfo();
  Future<void> toggleTorch(bool enabled);
   Future<bool> getTorchState();
  Stream<SensorDataEntity> getGyroscopeStream();
}