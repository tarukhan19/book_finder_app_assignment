import 'package:injectable/injectable.dart';
import '../entities/entity_info_system.dart';
import '../repositories/device_data_repository.dart';

@lazySingleton
class GetSystemInfoUseCase {
  final DeviceRepository repository;

  GetSystemInfoUseCase(this.repository);

  Future<SystemInfoEntity> call() async {
    final model = await repository.getSystemInfo();
    return SystemInfoEntity(
      deviceModel: model.deviceModel,
      osVersion: model.osVersion,
      platform: model.platform,
      batteryLevel: model.batteryLevel,
    );
  }
}