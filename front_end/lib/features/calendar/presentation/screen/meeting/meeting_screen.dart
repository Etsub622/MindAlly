// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:front_end/features/calendar/presentation/screen/meeting/meeting_controls.dart';
// import './participant_tile.dart';
// import 'package:videosdk/videosdk.dart';

// class MeetingScreen extends StatefulWidget {
//   final String meetingId;
//   final String token;

//   const MeetingScreen(
//       {super.key, required this.meetingId, required this.token});

//   @override
//   State<MeetingScreen> createState() => _MeetingScreenState();
// }

// class _MeetingScreenState extends State<MeetingScreen> {
//   late Room _room;
//   var micEnabled = true;
//   var camEnabled = true;

//   Map<String, Participant> participants = {};

//   @override
//   void initState() {
//     // create room
//     _room = VideoSDK.createRoom(
//       roomId: widget.meetingId,
//       token: widget.token,
//       displayName: "John Doe",
//       micEnabled: micEnabled,
//       camEnabled: camEnabled,
//       defaultCameraIndex: kIsWeb ? 0 : 1,
//     );

//     setMeetingEventListener();

//     // Join room
//     _room.join();

//     super.initState();
//   }

//   @override
//   void setState(fn) {
//     if (mounted) {
//       super.setState(fn);
//     }
//   }

//   // listening to meeting events
//   void setMeetingEventListener() {
//     _room.on(Events.roomJoined, () {
//       setState(() {
//         participants.putIfAbsent(
//             _room.localParticipant.id, () => _room.localParticipant);
//       });
//     });

//     _room.on(
//       Events.participantJoined,
//       (Participant participant) {
//         setState(
//           () => participants.putIfAbsent(participant.id, () => participant),
//         );
//       },
//     );

//     _room.on(Events.participantLeft, (String participantId) {
//       if (participants.containsKey(participantId)) {
//         setState(
//           () => participants.remove(participantId),
//         );
//       }
//     });

//     _room.on(Events.roomLeft, () {
//       participants.clear();
//       Navigator.pop(context); // Pop to previous screen
//     });
//   }

//   // on back button pressed, leave the room
//   Future<bool> _onWillPop() async {
//     _room.leave(); // Trigger leave, roomLeft will handle navigation
//     return false; // Prevent immediate pop
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _onWillPop(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('VideoSDK QuickStart'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Text(widget.meetingId),
//               // render all participants
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GridView.builder(
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                       mainAxisExtent: 300,
//                     ),
//                     itemBuilder: (context, index) {
//                       return ParticipantTile(
//                         key: Key(participants.values.elementAt(index).id),
//                         participant: participants.values.elementAt(index),
//                       );
//                     },
//                     itemCount: participants.length,
//                   ),
//                 ),
//               ),
//               MeetingControls(
//                 onToggleMicButtonPressed: () {
//                   micEnabled ? _room.muteMic() : _room.unmuteMic();
//                   micEnabled = !micEnabled;
//                 },
//                 onToggleCameraButtonPressed: () {
//                   camEnabled ? _room.disableCam() : _room.enableCam();
//                   camEnabled = !camEnabled;
//                 },
//                 onLeaveButtonPressed: () {
//                   _room.leave(); // Trigger leave, roomLeft will handle navigation
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }