import 'dart:convert';

import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/resource/data/model/video_model.dart';
import 'package:http/http.dart' as http;

abstract class VideoRemoteDatasource {
  Future<List<VideoModel>> getVideos();
  Future<String> addVideo(VideoModel video);
  Future<String> updateVideo(VideoModel video, String id);
  Future<String> deleteVideo(String id);
  Future<List<VideoModel>> searchVideos(String title);
  Future<VideoModel> getSingleVideo(String id);
  Future<List<VideoModel>> searchVideoByCategory(String category);
}

class VideoRemoteDataSourceImpl implements VideoRemoteDatasource {
  final http.Client client;
  VideoRemoteDataSourceImpl(this.client);

  final baseUrl = '${ConfigKey.baseUrl}/resources';

  @override
  Future<String> addVideo(VideoModel video) async {
    try {
      final url = Uri.parse(baseUrl);
      final newVideo = await client.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(video.toJson()));
      print(newVideo.body);
      print(newVideo.statusCode);
      if (newVideo.statusCode == 201) {
        return 'Video added successfully';
      } else {
        throw ServerException(
            message: 'Failed to add video:${newVideo.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> deleteVideo(String id) async {
    try {
      final url = Uri.parse('$baseUrl/$id');
      final deletedVideo = await client.delete(url);
      if (deletedVideo.statusCode == 200) {
        final decodedResponse = jsonDecode(deletedVideo.body);
        return decodedResponse['message'];
      } else {
        throw ServerException(
            message: 'Failed to delete video:${deletedVideo.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<VideoModel>> getVideos() async {
    try {
      var url = Uri.parse('$baseUrl/type/Video');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
     
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        final List<VideoModel> videos = [];
        for (var video in decodedResponse) {
          videos.add(VideoModel.fromJson(video));
        }
        return videos;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw ServerException(
            message: 'Failed to get books:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<VideoModel>> searchVideos(String title) async {
    try {
      var url = Uri.parse('$baseUrl/search?query=$title');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> videoJson = json.decode(response.body);
        if (videoJson.isEmpty) {
          return [];
        } else {
          return videoJson.map((jsonItem) {
            return VideoModel.fromJson(jsonItem as Map<String, dynamic>);
          }).toList();
        }
      } else if (response.statusCode == 404) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final errorMessage =
            errorResponse['message'] ?? 'No matching resources found.';
        print('Error: $errorMessage');
        return [];
      } else {
        throw ServerException(
            message: 'Failed to get videos:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> updateVideo(VideoModel video, String id) async {
    try {
      final url = Uri.parse('$baseUrl/$id');
      final updatedVideo = await client.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(video.toJson()));

      if (updatedVideo.statusCode == 200) {
        return 'video Updated successfuly';
      } else {
        throw ServerException(
            message: 'Failed to update video:${updatedVideo.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<VideoModel> getSingleVideo(String id) async {
    try {
      final url = Uri.parse('$baseUrl/getSingleVideo/$id');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final video = VideoModel.fromJson(decodedResponse['video']);
        return video;
      } else {
        throw ServerException(
            message: 'Failed to get video:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<VideoModel>> searchVideoByCategory(String category) async {
    try {
      var url = Uri.parse('$baseUrl/category/$category');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> videoJson = json.decode(response.body);
        if (videoJson.isEmpty) {
          return [];
        } else {
          return videoJson.map((jsonItem) {
            return VideoModel.fromJson(jsonItem as Map<String, dynamic>);
          }).toList();
        }
      } else {
        throw ServerException(
            message: 'Failed to get videos:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
