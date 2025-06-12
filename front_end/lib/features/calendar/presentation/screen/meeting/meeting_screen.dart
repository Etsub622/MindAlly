import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front_end/core/service/socket_service.dart';
import 'package:front_end/features/calendar/presentation/screen/meeting/meeting_controls.dart';
import './participant_tile.dart';
import 'package:videosdk/videosdk.dart';

class MeetingScreen extends StatefulWidget {
  final String meetingId;
  final String token;
  final String sessionId;
  final String userId;
  final bool isTherapist;

  const MeetingScreen({
    super.key,
    required this.meetingId,
    required this.token,
    required this.sessionId,
    required this.userId,
    required this.isTherapist,
  });

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  Room? _room;
  bool micEnabled = true;
  bool camEnabled = true;
  Map<String, Participant> participants = {};
  final SocketService socketService = SocketService();
  bool _isSocketInitialized = false;
  int _checkInIndex = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await socketService.ensureInitialized();
      setState(() {
        _isSocketInitialized = true;
      });

      _setupSocketListeners();

      _room = VideoSDK.createRoom(
        roomId: widget.meetingId,
        token: widget.token,
        displayName: widget.isTherapist ? "Therapist" : "Patient",
        micEnabled: micEnabled,
        camEnabled: camEnabled,
        defaultCameraIndex: kIsWeb ? 0 : 1,
      );

      setMeetingEventListener();

      _room!.join();
      _checkInIndex++;
      socketService.socket.emit("checkIn", {
        "sessionId": widget.sessionId,
        "userId": widget.userId,
        "isTherapist": widget.isTherapist,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Initialization error: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to initialize meeting: $e")),
      );
    }
  }

  void _setupSocketListeners() {
    socketService.socket.on("checkInSuccess", (data) {
      if (data["userId"] == widget.userId &&
          data["sessionId"] == widget.sessionId) {
        setState(() {
          _checkInIndex = data["index"];
        });
        if (kDebugMode) {
          print("Check-in successful for index: $_checkInIndex");
        }
      }
    });

    socketService.socket.on("checkInError", (data) {
      if (kDebugMode) {
        print("Check-in error: ${data["error"]}");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Check-in failed: ${data["error"]}")),
      );
    });

    socketService.socket.on("checkOutSuccess", (data) {
      if (kDebugMode) {
        print("Check-out successful for index: ${data["index"]}");
      }
    });

    socketService.socket.on("checkOutError", (data) {
      if (kDebugMode) {
        print("Check-out error: ${data["error"]}");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Check-out failed: ${data["error"]}")),
      );

      socketService.socket.on("disconnect", (_) {
        if (kDebugMode) {
          print("Socket disconnected");
        }
      });
    });
  }

  @override
  void dispose() {
    socketService.dispose();
    _room?.leave();
    _room = null;
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void setMeetingEventListener() {
    _room!.on(Events.roomJoined, () {
      setState(() {
        participants.putIfAbsent(
            _room!.localParticipant.id, () => _room!.localParticipant);
      });
    });

    _room!.on(Events.participantJoined, (Participant participant) {
      setState(() {
        participants.putIfAbsent(participant.id, () => participant);
      });
      if (_isSocketInitialized) {
        socketService.socket.emit("checkIn", {
          "sessionId": widget.sessionId,
          "userId": participant.id,
          "isTherapist": participant.displayName == "Therapist",
        });
      }
    });

    _room!.on(Events.participantLeft, (String participantId) {
      if (participants.containsKey(participantId)) {
        setState(() {
          participants.remove(participantId);
        });
        if (_isSocketInitialized) {
          socketService.socket.emit("checkOut", {
            "sessionId": widget.sessionId,
            "userId": participantId,
            "isTherapist":
                participants[participantId]?.displayName == "Therapist",
          });
        }
      }
    });

    _room!.on(Events.roomLeft, () {
      setState(() {
        participants.clear();
      });
      if (_isSocketInitialized) {
        socketService.socket.emit("checkOut", {
          "sessionId": widget.sessionId,
          "userId": widget.userId,
          "isTherapist": widget.isTherapist,
        });
      }
      Navigator.pop(context);
    });

    _room!.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'audio') {
        setState(() {
          micEnabled = true;
        });
      } else if (stream.kind == 'video') {
        setState(() {
          camEnabled = true;
        });
      }
    });

    _room!.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'audio') {
        setState(() {
          micEnabled = false;
        });
      } else if (stream.kind == 'video') {
        setState(() {
          camEnabled = false;
        });
      }
    });
  }

  Future<bool> _onWillPop() async {
    _room?.leave();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSocketInitialized || _room == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('VideoSDK QuickStart'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(widget.meetingId),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 300,
                    ),
                    itemBuilder: (context, index) {
                      return ParticipantTile(
                        key: Key(participants.values.elementAt(index).id),
                        participant: participants.values.elementAt(index),
                      );
                    },
                    itemCount: participants.length,
                  ),
                ),
              ),
              MeetingControls(
                onToggleMicButtonPressed: () {
                  if (micEnabled) {
                    _room!.muteMic();
                  } else {
                    _room!.unmuteMic();
                  }
                },
                onToggleCameraButtonPressed: () {
                  if (camEnabled) {
                    _room!.disableCam();
                  } else {
                    _room!.enableCam();
                  }
                },
                onLeaveButtonPressed: () {
                  _room!.leave();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}