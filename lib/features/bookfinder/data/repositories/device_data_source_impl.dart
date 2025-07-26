import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/device_data_repository.dart';
import '../models/sys_battery_info.dart';
import '../models/sys_sensor_info.dart';
import '../models/sys_system_info.dart';

@LazySingleton(as: DeviceRepository)
class DeviceDataSourceImpl implements DeviceRepository {
  static const MethodChannel _channel = MethodChannel('device_features');
  static const EventChannel _accelerometerChannel = EventChannel('accelerometer_stream');
  static const EventChannel _gyroscopeChannel = EventChannel('gyroscope_stream');

  @override
  Future<SystemInfoModel> getSystemInfo() async {
    try {
      final result = await _channel.invokeMethod('getSystemInfo');
      return SystemInfoModel.fromMap(Map<String, dynamic>.from(result));
    } catch (e) {
      throw Exception('Failed to get system info: $e');
    }
  }

  @override
  Future<BatteryInfoModel> getBatteryInfo() async {
    try {
      final result = await _channel.invokeMethod('getBatteryInfo');
      return BatteryInfoModel.fromMap(Map<String, dynamic>.from(result));
    } catch (e) {
      throw Exception('Failed to get battery info: $e');
    }
  }

  @override
  Future<void> toggleTorch(bool enabled) async {
    try {
      await _channel.invokeMethod('toggleTorch', {'enabled': enabled});
    } catch (e) {
      throw Exception('Failed to toggle torch: $e');
    }
  }

  @override
  Future<bool> getTorchState() async {
    try {
      final result = await _channel.invokeMethod('getTorchState');
      return result ?? false;
    } catch (e) {
      throw Exception('Failed to get torch state: $e');
    }
  }

  @override
  Stream<SensorDataModel> getAccelerometerStream() {
    return _accelerometerChannel
        .receiveBroadcastStream()
        .map((data) {
      print("Accelerometer data received: $data"); // Add debug log
      return SensorDataModel.fromMap(Map<String, dynamic>.from(data));
    });
  }

  @override
  Stream<SensorDataModel> getGyroscopeStream() {
    return _gyroscopeChannel
        .receiveBroadcastStream()
        .map((data) {
      print("Gyroscope data received: $data"); // Add debug log
      return SensorDataModel.fromMap(Map<String, dynamic>.from(data));
    });
  }
}