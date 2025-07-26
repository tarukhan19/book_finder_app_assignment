import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:book_finder_app_assignment/features/bookfinder/data/models/sys_sensor_info.dart';
import 'package:book_finder_app_assignment/features/bookfinder/data/models/sys_system_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:torch_light/torch_light.dart';
import '../../domain/repositories/device_data_repository.dart';

@LazySingleton(as: DeviceRepository)
class DeviceDataSourceImpl implements DeviceRepository {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Battery _battery = Battery();
  bool _isFlashlightOn = false;

  @override
  Stream<SensorDataModel> getAccelerometerStream() {
    throw UnimplementedError();
  }

  @override
  Future<SystemInfoModel> getSystemInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        final batteryLevel = await _battery.batteryLevel;

        return SystemInfoModel(
          deviceModel: androidInfo.model,
          osVersion: 'Android ${androidInfo.version.release}',
          batteryLevel: batteryLevel,
          platform: 'Android',
        );
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        final batteryLevel = await _battery.batteryLevel;

        return SystemInfoModel(
          deviceModel: iosInfo.model,
          osVersion: 'iOS ${iosInfo.systemVersion}',
          batteryLevel: batteryLevel,
          platform: 'iOS',
        );
      } else {
        throw UnsupportedError('Platform not supported');
      }
    } catch (e) {
      throw "Failed to get device info: $e";
    }
  }

  @override
  Future<bool> getTorchState() async {
    try {
      print('Getting current torch state...');

      return _isFlashlightOn;
    } catch (e) {
      print('Error getting torch state: $e');
      return false;
    }
  }

  @override
  Future<void> toggleTorch(bool enabled) async {
    try {

      print('Current flashlight state: ${_isFlashlightOn ? "ON" : "OFF"}');

      if (_isFlashlightOn) {
        await TorchLight.disableTorch();
        _isFlashlightOn = false;
        print('🔦 Flashlight turned OFF');
      } else {
        await TorchLight.enableTorch();
        _isFlashlightOn = true;
        print('🔦 Flashlight turned ON');
      }
    } on EnableTorchException catch (e) {
      print('TorchLight error: $e');
      throw 'Flashlight error: ${e.toString()}. This might be due to: 1) Testing on emulator, 2) Missing camera permission, 3) Hardware not supported.';
    }
  }

  @override
  Stream<SensorDataModel> getGyroscopeStream() {
    return gyroscopeEventStream().map(
          (event) => SensorDataModel(x: event.x, y: event.y, z: event.z),
    );
  }
}