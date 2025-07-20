import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/platform/service_platform.dart';

class SensorCard extends StatefulWidget {
  final bool isSensorMonitoring;
  final GyroscopeData? gyroscopeData;
  final AccelerometerData? accelerometerData;
  final VoidCallback onStartMonitoring;
  final VoidCallback onStopMonitoring;

  const SensorCard({
    super.key,
    required this.isSensorMonitoring,
    this.gyroscopeData,
    this.accelerometerData,
    required this.onStartMonitoring,
    required this.onStopMonitoring,
  });

  @override
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    if (widget.isSensorMonitoring) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(SensorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSensorMonitoring != oldWidget.isSensorMonitoring) {
      if (widget.isSensorMonitoring) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: widget.isSensorMonitoring
                ? [Colors.green.shade50, Colors.green.shade100]
                : [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: widget.isSensorMonitoring
                          ? _rotationController.value * 2 * math.pi
                          : 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.isSensorMonitoring
                              ? Colors.green.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.sensors,
                          color: widget.isSensorMonitoring
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sensor Monitoring',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        widget.isSensorMonitoring ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.isSensorMonitoring
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: widget.isSensorMonitoring,
                  onChanged: (value) {
                    if (value) {
                      widget.onStartMonitoring();
                    } else {
                      widget.onStopMonitoring();
                    }
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),

            if (widget.isSensorMonitoring) ...[
              const SizedBox(height: 20),

              // Gyroscope Data
              if (widget.gyroscopeData != null) ...[
                _buildSensorSection(
                  title: 'Gyroscope',
                  icon: Icons.rotate_right,
                  data: widget.gyroscopeData!,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
              ],

              // Accelerometer Data
              if (widget.accelerometerData != null) ...[
                _buildSensorSection(
                  title: 'Accelerometer',
                  icon: Icons.speed,
                  data: widget.accelerometerData!,
                  color: Colors.purple,
                ),
              ],
            ] else ...[
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.sensors_off,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enable monitoring to see sensor data',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSensorSection({
    required String title,
    required IconData icon,
    required dynamic data,
    required Color color,
  }) {
    double x, y, z, magnitude;

    if (data is GyroscopeData) {
      x = data.x;
      y = data.y;
      z = data.z;
      magnitude = math.sqrt(data.magnitude);
    } else if (data is AccelerometerData) {
      x = data.x;
      y = data.y;
      z = data.z;
      magnitude = math.sqrt(data.magnitude);
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildAxisValue('X', x, color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAxisValue('Y', y, color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAxisValue('Z', z, color),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.trending_up, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                'Magnitude: ${magnitude.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAxisValue(String axis, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            axis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}