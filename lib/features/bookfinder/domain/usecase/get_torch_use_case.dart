import 'package:injectable/injectable.dart';

import '../repositories/device_data_repository.dart';

@lazySingleton
class ToggleTorchUseCase {
  final DeviceRepository repository;

  ToggleTorchUseCase(this.repository);

  Future<void> call(bool enabled) => repository.toggleTorch(enabled);
}

@lazySingleton
class GetTorchStateUseCase {
  final DeviceRepository repository;

  GetTorchStateUseCase(this.repository);

  Future<bool> call() => repository.getTorchState();
}