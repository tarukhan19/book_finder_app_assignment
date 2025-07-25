import '../../data/models/sys_battery_info.dart';
import '../../data/models/sys_sensor_info.dart';
import '../../data/models/sys_system_info.dart';

abstract class DeviceRepository {
  Future<SystemInfoModel> getSystemInfo();
  Future<BatteryInfoModel> getBatteryInfo();
  Future<void> toggleTorch(bool enabled);
  Future<bool> getTorchState();
  Stream<SensorDataModel> getAccelerometerStream();
  Stream<SensorDataModel> getGyroscopeStream();
}