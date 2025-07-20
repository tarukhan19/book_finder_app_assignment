import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:torch_light/torch_light.dart';

class PlatformService {
  static const MethodChannel _channel = MethodChannel('com.bookfinder.device');

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Battery _battery = Battery();

  // Track flashlight state manually since torch_light doesn't provide status check
  bool _isFlashlightOn = false;

  // Get device information
  Future<DeviceInfo> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        final batteryLevel = await _battery.batteryLevel;

        return DeviceInfo(
          deviceName: androidInfo.model,
          osVersion: 'Android ${androidInfo.version.release}',
          batteryLevel: batteryLevel,
          platform: 'Android',
          manufacturer: androidInfo.manufacturer,
          brand: androidInfo.brand,
        );
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        final batteryLevel = await _battery.batteryLevel;

        return DeviceInfo(
          deviceName: iosInfo.name,
          osVersion: 'iOS ${iosInfo.systemVersion}',
          batteryLevel: batteryLevel,
          platform: 'iOS',
          manufacturer: 'Apple',
          brand: iosInfo.model,
        );
      } else {
        throw UnsupportedError('Platform not supported');
      }
    } catch (e) {
      throw PlatformException(
        code: 'DEVICE_INFO_ERROR',
        message: 'Failed to get device info: $e',
      );
    }
  }

  // Battery monitoring
  Stream<int> get batteryLevelStream => _battery.onBatteryStateChanged.asyncMap((_) => _battery.batteryLevel);

  // Flashlight controls with proper torch_light usage
  Future<bool> isFlashlightAvailable() async {
    try {
      print('Checking flashlight availability...');

      // Check if we're on a physical device
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        if (androidInfo.isPhysicalDevice == false) {
          print(' Running on Android emulator - flashlight not available');
          return false;
        }
      }

      final isAvailable = await TorchLight.isTorchAvailable();
      print('🔦 Flashlight available: $isAvailable');
      return isAvailable;
    } catch (e) {
      print('Error checking flashlight availability: $e');
      return false;
    }
  }

  Future<void> toggleFlashlight() async {
    try {
      print('🔦 Attempting to toggle flashlight...');

      // Check availability first
      final isAvailable = await isFlashlightAvailable();
      if (!isAvailable) {
        throw PlatformException(
          code: 'FLASHLIGHT_UNAVAILABLE',
          message: 'Flashlight is not available on this device. Make sure you are testing on a physical device with flashlight capability.',
        );
      }

      print('🔦 Current flashlight state: ${_isFlashlightOn ? "ON" : "OFF"}');

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
      throw PlatformException(
        code: 'TORCH_ERROR',
        message: 'Flashlight error: ${e.toString()}. This might be due to: 1) Testing on emulator, 2) Missing camera permission, 3) Hardware not supported.',
      );
    } on PlatformException catch (e) {
      print('Platform error: $e');
      rethrow;
    } catch (e) {
      print(' Unexpected flashlight error: $e');
      throw PlatformException(
        code: 'FLASHLIGHT_ERROR',
        message: 'Failed to toggle flashlight: $e. Make sure you are testing on a physical device and have granted camera permission.',
      );
    }
  }

  // Turn flashlight ON specifically
  Future<void> turnOnFlashlight() async {
    try {
      final isAvailable = await isFlashlightAvailable();
      if (!isAvailable) {
        throw PlatformException(
          code: 'FLASHLIGHT_UNAVAILABLE',
          message: 'Flashlight not available',
        );
      }

      if (!_isFlashlightOn) {
        await TorchLight.enableTorch();
        _isFlashlightOn = true;
        print('🔦 Flashlight turned ON');
      }
    } catch (e) {
      print(' Error turning on flashlight: $e');
      rethrow;
    }
  }

  // Turn flashlight OFF specifically
  Future<void> turnOffFlashlight() async {
    try {
      if (_isFlashlightOn) {
        await TorchLight.disableTorch();
        _isFlashlightOn = false;
        print('🔦 Flashlight turned OFF');
      }
    } catch (e) {
      print(' Error turning off flashlight: $e');
      // Try to reset state even if disable fails
      _isFlashlightOn = false;
      rethrow;
    }
  }

  // Get current flashlight state (from our manual tracking)
  bool isFlashlightOn() {
    return _isFlashlightOn;
  }

  // Enhanced flashlight status with detailed info
  Future<FlashlightStatus> getFlashlightStatus() async {
    try {
      final isAvailable = await isFlashlightAvailable();

      String message = '';
      if (!isAvailable) {
        if (Platform.isAndroid) {
          final androidInfo = await _deviceInfo.androidInfo;
          if (androidInfo.isPhysicalDevice == false) {
            message = 'Flashlight not available on emulator. Please test on a physical device.';
          } else {
            message = 'Flashlight not supported on this device.';
          }
        } else {
          message = 'Flashlight not available. Please test on a physical device.';
        }
      } else {
        message = _isFlashlightOn ? 'Flashlight is ON' : 'Flashlight is OFF';
      }

      return FlashlightStatus(
        isAvailable: isAvailable,
        isOn: _isFlashlightOn,
        message: message,
      );
    } catch (e) {
      return FlashlightStatus(
        isAvailable: false,
        isOn: false,
        message: 'Error checking flashlight: $e',
      );
    }
  }

  // Reset flashlight state (useful for app lifecycle)
  void resetFlashlightState() {
    _isFlashlightOn = false;
  }

  // Gyroscope data
  Stream<GyroscopeData> get gyroscopeStream {
    return gyroscopeEventStream().map((event) => GyroscopeData(
      x: event.x,
      y: event.y,
      z: event.z,
      timestamp: DateTime.now(),
    ));
  }

  // Accelerometer data
  Stream<AccelerometerData> get accelerometerStream {
    return accelerometerEventStream().map((event) => AccelerometerData(
      x: event.x,
      y: event.y,
      z: event.z,
      timestamp: DateTime.now(),
    ));
  }

  // Custom platform channel methods
  Future<String> getCustomDeviceInfo() async {
    try {
      final String result = await _channel.invokeMethod('getDeviceInfo');
      return result;
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: 'Failed to get custom device info: ${e.message}',
      );
    }
  }

  Future<void> vibrate({int duration = 500}) async {
    try {
      await _channel.invokeMethod('vibrate', {'duration': duration});
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: 'Failed to vibrate: ${e.message}',
      );
    }
  }
}

// Enhanced flashlight status class
class FlashlightStatus {
  final bool isAvailable;
  final bool isOn;
  final String message;

  FlashlightStatus({
    required this.isAvailable,
    required this.isOn,
    required this.message,
  });
}

// Data models
class DeviceInfo {
  final String deviceName;
  final String osVersion;
  final int batteryLevel;
  final String platform;
  final String manufacturer;
  final String brand;

  DeviceInfo({
    required this.deviceName,
    required this.osVersion,
    required this.batteryLevel,
    required this.platform,
    required this.manufacturer,
    required this.brand,
  });

  String get batteryLevelFormatted => '$batteryLevel%';

  String get fullDeviceInfo => '$manufacturer $deviceName ($platform $osVersion)';
}

class GyroscopeData {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  GyroscopeData({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  double get magnitude => (x * x + y * y + z * z);
}

class AccelerometerData {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  AccelerometerData({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  double get magnitude => (x * x + y * y + z * z);
}