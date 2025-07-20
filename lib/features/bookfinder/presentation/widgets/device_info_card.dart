import 'package:flutter/material.dart';

import '../../../../core/platform/service_platform.dart';

class DeviceInfoCard extends StatelessWidget {
  final DeviceInfo deviceInfo;

  const DeviceInfoCard({super.key, required this.deviceInfo});

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
            colors: [Colors.white, Colors.grey.shade50],
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Device Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                _buildBatteryIndicator(),
              ],
            ),
            const SizedBox(height: 20),

            // Device Details
            _buildInfoRow(
              icon: Icons.smartphone,
              label: 'Device',
              value: deviceInfo.deviceName,
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              icon: Icons.business,
              label: 'Manufacturer',
              value: deviceInfo.manufacturer,
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              icon: Icons.memory,
              label: 'Model',
              value: deviceInfo.brand,
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              icon: Icons.system_security_update,
              label: 'OS Version',
              value: deviceInfo.osVersion,
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              icon: Icons.computer,
              label: 'Platform',
              value: deviceInfo.platform,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryIndicator() {
    final batteryLevel = deviceInfo.batteryLevel;
    Color batteryColor;
    IconData batteryIcon;

    if (batteryLevel > 75) {
      batteryColor = Colors.green;
      batteryIcon = Icons.battery_full;
    } else if (batteryLevel > 50) {
      batteryColor = Colors.orange;
      batteryIcon = Icons.battery_5_bar;
    } else if (batteryLevel > 25) {
      batteryColor = Colors.orange.shade700;
      batteryIcon = Icons.battery_3_bar;
    } else {
      batteryColor = Colors.red;
      batteryIcon = Icons.battery_1_bar;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: batteryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: batteryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            batteryIcon,
            color: batteryColor,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '${batteryLevel}%',
            style: TextStyle(
              color: batteryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.grey.shade600,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}