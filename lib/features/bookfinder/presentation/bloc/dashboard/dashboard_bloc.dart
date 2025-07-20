import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/platform/service_platform.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final PlatformService _platformService;

  StreamSubscription? _batterySubscription;
  StreamSubscription? _gyroscopeSubscription;
  StreamSubscription? _accelerometerSubscription;

  DashboardBloc(this._platformService) : super(const DashboardInitial()) {
    on<LoadDashboardDataEvent>(_onLoadDashboardData);
    on<ToggleFlashlightEvent>(_onToggleFlashlight);
    on<StartSensorMonitoringEvent>(_onStartSensorMonitoring);
    on<StopSensorMonitoringEvent>(_onStopSensorMonitoring);
    on<UpdateBatteryLevelEvent>(_onUpdateBatteryLevel);
    on<UpdateGyroscopeDataEvent>(_onUpdateGyroscopeData);
  }

  Future<void> _onLoadDashboardData(
      LoadDashboardDataEvent event,
      Emitter<DashboardState> emit,
      ) async {
    emit(const DashboardLoading());

    try {
      // Get device information
      final deviceInfo = await _platformService.getDeviceInfo();

      // Check flashlight availability and status
      final isFlashlightAvailable = await _platformService.isFlashlightAvailable();
      final isFlashlightOn = await _platformService.isFlashlightOn();

      emit(DashboardLoaded(
        deviceInfo: deviceInfo,
        isFlashlightOn: isFlashlightOn,
        isFlashlightAvailable: isFlashlightAvailable,
        isSensorMonitoring: false,
      ));

      // Start battery monitoring
      _startBatteryMonitoring();

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
      await _platformService.toggleFlashlight();
      final isFlashlightOn = await _platformService.isFlashlightOn();

      emit(currentState.copyWith(isFlashlightOn: isFlashlightOn));
    } catch (e) {
      emit(DashboardError(message: 'Failed to toggle flashlight: ${e.toString()}'));
      // Restore previous state after error
      Future.delayed(const Duration(seconds: 2), () {
        if (!isClosed) emit(currentState);
      });
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

  void _onUpdateBatteryLevel(
      UpdateBatteryLevelEvent event,
      Emitter<DashboardState> emit,
      ) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    final updatedDeviceInfo = DeviceInfo(
      deviceName: currentState.deviceInfo.deviceName,
      osVersion: currentState.deviceInfo.osVersion,
      batteryLevel: event.batteryLevel,
      platform: currentState.deviceInfo.platform,
      manufacturer: currentState.deviceInfo.manufacturer,
      brand: currentState.deviceInfo.brand,
    );

    emit(currentState.copyWith(deviceInfo: updatedDeviceInfo));
  }

  void _onUpdateGyroscopeData(
      UpdateGyroscopeDataEvent event,
      Emitter<DashboardState> emit,
      ) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    final gyroscopeData = GyroscopeData(
      x: event.x,
      y: event.y,
      z: event.z,
      timestamp: DateTime.now(),
    );

    emit(currentState.copyWith(gyroscopeData: gyroscopeData));
  }

  void _startBatteryMonitoring() {
    _batterySubscription?.cancel();
    _batterySubscription = _platformService.batteryLevelStream.listen(
          (batteryLevel) {
        add(UpdateBatteryLevelEvent(batteryLevel: batteryLevel));
      },
      onError: (error) {
        // Handle battery monitoring errors silently
      },
    );
  }

  void _startSensorMonitoring() {
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription?.cancel();

    // Monitor gyroscope
    _gyroscopeSubscription = _platformService.gyroscopeStream.listen(
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

    // Monitor accelerometer
    _accelerometerSubscription = _platformService.accelerometerStream.listen(
          (accelerometerData) {
        final currentState = state;
        if (currentState is DashboardLoaded) {
          emit(currentState.copyWith(accelerometerData: accelerometerData));
        }
      },
      onError: (error) {
        // Handle sensor errors
      },
    );
  }

  void _stopSensorMonitoring() {
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription = null;
    _accelerometerSubscription = null;
  }

  @override
  Future<void> close() {
    _batterySubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    return super.close();
  }
}