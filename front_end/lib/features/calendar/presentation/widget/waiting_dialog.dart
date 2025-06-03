import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/presentation/screen/meeting/meeting_screen.dart';
import 'package:intl/intl.dart';

class WaitingDialog extends StatefulWidget {
  final EventEntity event;

  const WaitingDialog({super.key, required this.event});

  @override
  State<WaitingDialog> createState() => _WaitingDialogState();
}

class _WaitingDialogState extends State<WaitingDialog> with TickerProviderStateMixin {
  String _countdown = '';
  bool _isPast = false;
  bool _isJoinable = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTimeStatus();
    if (!_isPast && !_isJoinable) {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateTimeStatus();
        });
      }
    });
  }

  void _updateTimeStatus() {
    final now = DateTime.now();
    final startDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
      '${widget.event.date} ${widget.event.startTime}',
    );
    final endDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
      '${widget.event.date} ${widget.event.endTime}',
    );

    if (now.isAfter(endDateTime)) {
      _isPast = true;
      _isJoinable = false;
      _timer?.cancel();
    } else if (now.isAfter(startDateTime) || now.isAtSameMomentAs(startDateTime)) {
      _isPast = false;
      _isJoinable = true;
      _timer?.cancel();
    } else {
      _isPast = false;
      _isJoinable = false;
      final difference = startDateTime.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      final seconds = difference.inSeconds % 60;
      _countdown = 'Starts in ${hours}h ${minutes}m ${seconds}s';
    }
  }

  void _joinCall(userId, name, meetingId, meetingToken) async {
    var re = RegExp("\\w{4}\\-\\w{4}\\-\\w{4}");
    // check meeting id is not null or invaild
    // if meeting id is vaild then navigate to MeetingScreen with meetingId,token
    if (meetingId.isNotEmpty && re.hasMatch(meetingId)) {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => MeetingScreen(
      //       meetingId: meetingId,
      //       token: meetingToken,
      //     ),
      //   ),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter valid meeting id"),
      ));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
      '${widget.event.date} ${widget.event.startTime}',
    );
    final formattedTime = DateFormat('hh:mm a').format(eventDateTime);
    final formattedDate = DateFormat('MMMM dd, yyyy').format(eventDateTime);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isPast
                  ? Icons.check_circle
                  : _isJoinable
                      ? Icons.video_call
                      : Icons.hourglass_empty,
              color: _isPast ? Colors.green[700] : Colors.purple[700],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _isPast
                  ? 'Session Completed'
                  : _isJoinable
                      ? 'Join Session'
                      : 'Session Not Yet Available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[900],
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your session with Therapist is scheduled for:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '$formattedTime on $formattedDate',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
            ),
            const SizedBox(height: 16),
            if (!_isPast && !_isJoinable)
              Text(
                _countdown,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.purple[700],
                    ),
              ),
            if (_isJoinable)
              Text(
                'The session is ready to join!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                textAlign: TextAlign.center,
              ),
            if (_isPast)
              Text(
                'This session has already ended.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[500],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                _isJoinable
                    ? ElevatedButton(
                        onPressed: () => _joinCall(
                            widget.event.userId, 'Therapist/Dr', widget.event.meetingId, widget.event.meetingToken),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text(
                          'Join',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}