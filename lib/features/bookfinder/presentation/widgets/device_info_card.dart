import 'package:book_finder_app_assignment/features/bookfinder/domain/entities/info_system.dart';
import 'package:flutter/material.dart';

class DeviceInfoCard extends StatelessWidget {
  final SystemInfo systemInfo;

  const DeviceInfoCard({super.key, required this.systemInfo});

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
               // _buildBatteryIndicator(),
              ],
            ),
            const SizedBox(height: 20),

            // Device Details
            _buildInfoRow(
              icon: Icons.smartphone,
              label: 'Device',
              value: systemInfo.deviceModel,
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              icon: Icons.battery_0_bar,
              label: 'Battery',
              value: "${systemInfo.batteryLevel}%",
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              icon: Icons.system_security_update,
              label: 'OS Version',
              value: systemInfo.osVersion,
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              icon: Icons.computer,
              label: 'Platform',
              value: systemInfo.platform,
            ),
          ],
        ),
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