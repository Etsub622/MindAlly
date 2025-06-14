import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

class ParticipantTile extends StatefulWidget {
  final Participant participant;
  const ParticipantTile({super.key, required this.participant});

  @override
  State<ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<ParticipantTile> {
  Stream? videoStream;
  bool isMicOn = false;
  bool isCameraOn = false;

  @override
  void initState() {
    super.initState();
    _initializeStreams();
    _initStreamListeners();
  }

  void _initializeStreams() {
    for (var stream in widget.participant.streams.values) {
      if (stream.kind == 'video') {
        videoStream = stream;
        isCameraOn = true;
      } else if (stream.kind == 'audio') {
        isMicOn = true;
      }
    }
  }

  void _initStreamListeners() {
    widget.participant.on(Events.streamEnabled, (Stream stream) {
      if (mounted) {
        setState(() {
          if (stream.kind == 'video') {
            videoStream = stream;
            isCameraOn = true;
          } else if (stream.kind == 'audio') {
            isMicOn = true;
          }
        });
      }
    });

    widget.participant.on(Events.streamDisabled, (Stream stream) {
      if (mounted) {
        setState(() {
          if (stream.kind == 'video') {
            videoStream = null;
            isCameraOn = false;
          } else if (stream.kind == 'audio') {
            isMicOn = false;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video or Placeholder
          videoStream != null
              ? RTCVideoView(
                  videoStream?.renderer as RTCVideoRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )
              : Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        widget.participant.displayName[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 40,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
          // Name Badge
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.participant.displayName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Status Icons
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isMicOn ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isMicOn ? Icons.mic : Icons.mic_off,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isCameraOn ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCameraOn ? Icons.videocam : Icons.videocam_off,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}