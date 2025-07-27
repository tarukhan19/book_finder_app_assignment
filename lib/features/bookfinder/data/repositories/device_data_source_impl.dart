import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/entity_info_sensor.dart';
import '../../domain/entities/entity_info_system.dart';
import '../../domain/repositories/device_data_repository.dart';

@LazySingleton(as: DeviceRepository)
class DeviceDataSourceImpl implements DeviceRepository {
  static const MethodChannel _channel = MethodChannel('device_features');
  static const EventChannel _gyroscopeChannel = EventChannel('gyroscope_stream');

  @override
  Future<SystemInfoEntity> getSystemInfo() async {
    try {
      final result = await _channel.invokeMethod('getSystemInfo');
      return SystemInfoEntity.fromMap(Map<String, dynamic>.from(result));
    } catch (e) {
      throw Exception('Failed to get system info: $e');
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
  Stream<SensorDataEntity> getGyroscopeStream() {
    return _gyroscopeChannel
        .receiveBroadcastStream()
        .map((data) {
      print("Gyroscope data received: $data"); // Add debug log
      return SensorDataEntity.fromMap(Map<String, dynamic>.from(data));
    });
  }
}