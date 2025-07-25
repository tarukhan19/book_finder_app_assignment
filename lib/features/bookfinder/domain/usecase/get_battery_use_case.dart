import 'package:injectable/injectable.dart';

import '../entities/info_battery.dart';
import '../repositories/device_data_repository.dart';

@lazySingleton
class GetBatteryInfoUseCase {
  final DeviceRepository repository;

  GetBatteryInfoUseCase(this.repository);

  Future<BatteryInfo> call() async {
    final model = await repository.getBatteryInfo();
    return BatteryInfo(
      batteryLevel: model.batteryLevel,
      batteryState: _mapBatteryState(model.batteryState),
      isCharging: model.isCharging,
    );
  }

  BatteryState _mapBatteryState(String state) {
    switch (state.toLowerCase()) {
      case 'charging': return BatteryState.charging;
      case 'discharging': return BatteryState.discharging;
      case 'not_charging': return BatteryState.notCharging;
      case 'full': return BatteryState.full;
      default: return BatteryState.unknown;
    }
  }
}