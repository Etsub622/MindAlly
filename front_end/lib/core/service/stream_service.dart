// import 'package:stream_video/stream_video.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class StreamService {
//   static const String apiKey = 'your-stream-api-key';
//   static const String baseUrl = 'your-backend-url';
//   final _storage = const FlutterSecureStorage();

//   Future<StreamVideoClient> initializeClient() async {
//     final userId = await _getUserId();
//     final token = await _fetchUserToken(userId);
    
//     final client = StreamVideoClient(
//       apiKey,
//       user: User.info(id: userId, name: userId, role: 'user'),
//       userToken: token,
//     );
    
//     return client;
//   }

//   Future<String> _getUserId() async {
//     final userCredential = await _storage.read(key: "user_profile") ?? '';
//     if (userCredential.isNotEmpty) {
//       final body = jsonDecode(userCredential);
//       return body["_id"].toString();
//     }
//     throw Exception('User ID not found');
//   }

//   Future<String> _fetchUserToken(String userId) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/generate-stream-token'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'user_id': userId}),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['token'];
//     }
//     throw Exception('Failed to fetch Stream token');
//   }

//   Future<Call> createCall(String callId, String userId) async {
//     final client = await initializeClient();
//     final call = client.call(type: 'default', id: callId);
//     await call.getOrCreate(
//       participantIds: [userId], // Add therapistId if needed
//     );
//     return call;
//   }
// }