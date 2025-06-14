


// import 'package:flutter/material.dart';
// import 'package:front_end/features/calendar/presentation/screen/call_screen.dart';
// import 'package:stream_video_flutter/stream_video_flutter.dart';


// class CallPage extends StatefulWidget {
//   final String userId;
//   final String name;
//   final String callId;

//   const CallPage({super.key, required this.title, required this.userId, required this.name, required this.callId});

//   final String title;

//   @override
//   State<CallPage> createState() => _CallPageState();
// }

// class _CallPageState extends State<CallPage> {
//   @override
//   Widget build(BuildContext context) {

//     final client = StreamVideo(
//     widget.callId,
//     user: User.regular(
//       userId: widget.userId,
//       role: 'admin',
//       name: widget.name,
//     ),
//     userToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidXNlcklkMiJ9.8mknXXa-TfY0Winhd-KuC8V6pM9yhZH15h35wRtgIgM',
//   );


//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: const Text('Create Call'),
//           onPressed: () async {
//             try {
//               var call = StreamVideo.instance.makeCall(
//                 callType: StreamCallType(),
//                 id: widget.callId,
//               );

//               await call.getOrCreate();

//               // Created ahead
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CallScreen(call: call),
//                 ),
//               );
//             } catch (e) {
//               debugPrint('Error joining or creating call: $e');
//               debugPrint(e.toString());
//             }
//           },
//         ),
//       ),
//     );
//   }
// }