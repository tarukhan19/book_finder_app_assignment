import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/info_sensor.dart';
import '../../../domain/entities/info_system.dart';
import '../../../domain/usecase/get_info_use_case.dart';
import '../../../domain/usecase/get_sensor_use_case.dart';
import '../../../domain/usecase/get_torch_use_case.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetSystemInfoUseCase getSystemInfoUseCase;
  final ToggleTorchUseCase toggleTorchUseCase;
  final GetTorchStateUseCase getTorchStateUseCase;
  final GetSensorDataUseCase getSensorDataUseCase;

  StreamSubscription<SensorData>? _gyroscopeSubscription;

  DashboardBloc({
    required this.getSystemInfoUseCase,
    required this.toggleTorchUseCase,
    required this.getTorchStateUseCase,
    required this.getSensorDataUseCase,
  })  : super(const DashboardInitial()) {
    on<LoadDashboardDataEvent>(_onLoadDashboardData);
    on<ToggleFlashlightEvent>(_onToggleFlashlight);
    on<StartSensorMonitoringEvent>(_onStartSensorMonitoring);
    on<StopSensorMonitoringEvent>(_onStopSensorMonitoring);
    on<UpdateGyroscopeDataEvent>(_onUpdateGyroscopeData);
  }

  Future<void> _onLoadDashboardData(
      LoadDashboardDataEvent event,
      Emitter<DashboardState> emit,
      ) async {
    emit(const DashboardInitial());

    try {

      final systemInfo = await getSystemInfoUseCase();
      final torchState = await getTorchStateUseCase();

      final deviceInfo = SystemInfo(
        osVersion: systemInfo.osVersion,
        platform: systemInfo.platform,
        batteryLevel: systemInfo.batteryLevel,
        deviceModel: systemInfo.deviceModel,
      );

      emit(DashboardLoaded(
        systemInfo: deviceInfo,
        isFlashlightOn: torchState,
        isFlashlightAvailable: true,
        isSensorMonitoring: false,
      ));

    } catch (e) {
      emit(DashboardError(message: 'Failed to load dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onToggleFlashlight(
      ToggleFlashlightEvent event,
      Emitter<DashboardState> emit,
      ) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    try {
      await toggleTorchUseCase(!currentState.isFlashlightOn);
      emit(currentState.copyWith(isFlashlightOn: !currentState.isFlashlightOn));
    } catch (e) {
      emit(DashboardError(message: 'Failed to toggle flashlight: ${e.toString()}'));
    }
  }

  Future<void> _onStartSensorMonitoring(
      StartSensorMonitoringEvent event,
      Emitter<DashboardState> emit,
      ) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    try {
      emit(currentState.copyWith(isSensorMonitoring: true));
      _startSensorMonitoring();
    } catch (e) {
      emit(DashboardError(message: 'Failed to start sensor monitoring: ${e.toString()}'));
    }
  }

  Future<void> _onStopSensorMonitoring(
      StopSensorMonitoringEvent event,
      Emitter<DashboardState> emit,
      ) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    _stopSensorMonitoring();
    emit(currentState.copyWith(isSensorMonitoring: false));
  }

  void _onUpdateGyroscopeData(
      UpdateGyroscopeDataEvent event,
      Emitter<DashboardState> emit,
      ) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    final sensorData = SensorData(
      x: event.x,
      y: event.y,
      z: event.z,
    );

    emit(currentState.copyWith(sensorData: sensorData));
  }

  void _startSensorMonitoring() {
    _gyroscopeSubscription?.cancel();

    // Monitor gyroscope
    _gyroscopeSubscription = getSensorDataUseCase.getGyroscopeData().listen(
          (gyroscopeData) {
        add(UpdateGyroscopeDataEvent(
          x: gyroscopeData.x,
          y: gyroscopeData.y,
          z: gyroscopeData.z,
        ));
      },
      onError: (error) {
        // Handle sensor errors
      },
    );
  }

  void _stopSensorMonitoring() {
    _gyroscopeSubscription?.cancel();
    _gyroscopeSubscription = null;
  }

  @override
  Future<void> close() {
    _gyroscopeSubscription?.cancel();
    return super.close();
  }
}