import 'package:flutter/material.dart';

class MeetingControls extends StatelessWidget {
  final void Function() onToggleMicButtonPressed;
  final void Function() onToggleCameraButtonPressed;
  final void Function() onLeaveButtonPressed;

  const MeetingControls({
    super.key,
    required this.onToggleMicButtonPressed,
    required this.onToggleCameraButtonPressed,
    required this.onLeaveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            context,
            icon: Icons.call_end,
            color: Colors.red[600]!,
            onPressed: onLeaveButtonPressed,
            tooltip: 'Leave Meeting',
          ),
          _buildControlButton(
            context,
            icon: Icons.mic,
            color: Theme.of(context).colorScheme.primary,
            onPressed: onToggleMicButtonPressed,
            tooltip: 'Toggle Microphone',
          ),
          _buildControlButton(
            context,
            icon: Icons.videocam,
            color: Theme.of(context).colorScheme.primary,
            onPressed: onToggleCameraButtonPressed,
            tooltip: 'Toggle Camera',
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}