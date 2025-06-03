// import 'package:flutter/material.dart';
// import 'api_call.dart';
// import 'meeting_screen.dart';

// class JoinScreen extends StatelessWidget {
//   final _meetingIdController = TextEditingController();

//   JoinScreen({super.key});

//   void onCreateButtonPressed(BuildContext context) async {
//     // call api to create meeting and then navigate to MeetingScreen with meetingId,token
//     await createMeeting().then((meetingId) {
//       if (!context.mounted) return;
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => MeetingScreen(
//             meetingId: meetingId,
//             token: token,
//           ),
//         ),
//       );
//     });
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('VideoSDK QuickStart'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => onCreateButtonPressed(context),
//               child: const Text('Create Meeting'),
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
//               child: TextField(
//                 decoration: const InputDecoration(
//                   hintText: 'Meeting Id',
//                   border: OutlineInputBorder(),
//                 ),
//                 controller: _meetingIdController,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => onJoinButtonPressed(context),
//               child: const Text('Join Meeting'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }