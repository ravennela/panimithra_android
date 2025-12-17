import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadFileRemoteDatasource {
  final Dio client;
  UploadFileRemoteDatasource({required this.client});
  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery or camera
  Future<File?> pickImage({bool fromCamera = false}) async {
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85, // Compress image
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<String?> uploadPhoto(File photo) async {
    try {
      String url = "${ApiConstants.gcpApi}";
      print("url datea" + url);

      // final formData = FormData.fromMap({
      //   "file": await MultipartFile.fromFile(photo.path,
      //       filename: photo.path.split('/').last),
      //   "upload_preset": ApiConstants.presetName,
      // });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(photo.path,
            filename: photo.path.split("/").last),
      });

      final response = await client.post(
        url,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token"
          },
        ),
        onSendProgress: (sent, total) {
          print("sent" + sent.toString());
        },
      );
      print("res value" + response.toString());
      String file = response.data["imageUrl"] ?? "";
      print(file);
      return file;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to upload photo');
    }
  }
}
