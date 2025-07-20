import 'package:flutter/material.dart';

class FlashlightCard extends StatefulWidget {
  final bool isFlashlightOn;
  final bool isFlashlightAvailable;
  final VoidCallback onToggle;

  const FlashlightCard({
    super.key,
    required this.isFlashlightOn,
    required this.isFlashlightAvailable,
    required this.onToggle,
  });

  @override
  State<FlashlightCard> createState() => _FlashlightCardState();
}

class _FlashlightCardState extends State<FlashlightCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isFlashlightOn) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(FlashlightCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlashlightOn != oldWidget.isFlashlightOn) {
      if (widget.isFlashlightOn) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
            colors: widget.isFlashlightOn
                ? [Colors.amber.shade100, Colors.amber.shade50]
                : [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.isFlashlightOn
                        ? Colors.amber.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.flashlight_on,
                    color: widget.isFlashlightOn
                        ? Colors.amber.shade700
                        : Colors.grey.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Flashlight Control',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        widget.isFlashlightAvailable
                            ? (widget.isFlashlightOn ? 'ON' : 'OFF')
                            : 'Not Available',
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.isFlashlightOn
                              ? Colors.amber.shade700
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Flashlight Button
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: widget.isFlashlightOn ? _pulseAnimation.value : 1.0,
                    child: GestureDetector(
                      onTap: widget.isFlashlightAvailable ? widget.onToggle : null,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: widget.isFlashlightOn
                              ? RadialGradient(
                            colors: [
                              Colors.amber.shade300,
                              Colors.amber.shade600,
                            ],
                          )
                              : RadialGradient(
                            colors: [
                              Colors.grey.shade300,
                              Colors.grey.shade500,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.isFlashlightOn
                                  ? Colors.amber.withOpacity(0.4)
                                  : Colors.grey.withOpacity(0.3),
                              blurRadius: widget.isFlashlightOn ? 20 : 10,
                              spreadRadius: widget.isFlashlightOn ? 5 : 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.isFlashlightOn
                              ? Icons.flashlight_on
                              : Icons.flashlight_off,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Instructions
            Text(
              widget.isFlashlightAvailable
                  ? 'Tap the button to toggle flashlight'
                  : 'Flashlight not available on this device',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}