import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/info_sensor.dart';
import '../../../domain/usecase/get_battery_use_case.dart';
import '../../../domain/usecase/get_info_use_case.dart';
import '../../../domain/usecase/get_sensor_use_case.dart';
import '../../../domain/usecase/get_torch_use_case.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetSystemInfoUseCase getSystemInfoUseCase;
  final GetBatteryInfoUseCase getBatteryInfoUseCase;
  final ToggleTorchUseCase toggleTorchUseCase;
  final GetTorchStateUseCase getTorchStateUseCase;
  final GetSensorDataUseCase getSensorDataUseCase;

  StreamSubscription<SensorData>? _accelerometerSubscription;
  StreamSubscription<SensorData>? _gyroscopeSubscription;

  DashboardBloc({
    required this.getSystemInfoUseCase,
    required this.getBatteryInfoUseCase,
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
      final batteryInfo = await getBatteryInfoUseCase();
      final torchState = await getTorchStateUseCase();

      final deviceInfo = DeviceInfo(
        deviceName: systemInfo.deviceModel,
        manufacturer: 'Unknown', // You may need to add this to your system info
        brand: systemInfo.platform,
        osVersion: systemInfo.osVersion,
        platform: systemInfo.platform,
        batteryLevel: batteryInfo.batteryLevel,
      );

      emit(DashboardLoaded(
        deviceInfo: deviceInfo,
        isFlashlightOn: torchState,
        isFlashlightAvailable: true, // You may want to check availability
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

    final gyroscopeData = GyroscopeData(
      x: event.x,
      y: event.y,
      z: event.z,
    );

    emit(currentState.copyWith(gyroscopeData: gyroscopeData));
  }

  void _startSensorMonitoring() {
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription?.cancel();

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

    // Monitor accelerometer
    _accelerometerSubscription = getSensorDataUseCase.getAccelerometerData().listen(
          (data) {
        final currentState = state;
        if (currentState is DashboardLoaded) {
          emit(currentState.copyWith(accelerometerData: AccelerometerData(
            x: data.x,
            y: data.y,
            z: data.z,
          ),));
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
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    return super.close();
  }
}