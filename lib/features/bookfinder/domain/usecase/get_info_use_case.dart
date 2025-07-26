import 'package:injectable/injectable.dart';

import '../entities/info_system.dart';
import '../repositories/device_data_repository.dart';

@lazySingleton
class GetSystemInfoUseCase {
  final DeviceRepository repository;

  GetSystemInfoUseCase(this.repository);

  Future<SystemInfo> call() async {
    final model = await repository.getSystemInfo();
    return SystemInfo(
      deviceModel: model.deviceModel,
      osVersion: model.osVersion,
      platform: model.platform,
      batteryLevel: model.batteryLevel,
    );
  }
}