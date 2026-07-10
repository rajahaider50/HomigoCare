import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleDriveService {
  static const String _uploadUrl = 'https://www.googleapis.com/upload/drive/v3/files';
  final String? accessToken;

  GoogleDriveService({this.accessToken});

  Future<String?> uploadFile({
    required File file,
    required String fileName,
    required String folderId,
  }) async {
    try {
      if (accessToken == null) throw Exception('No access token');
      final bytes = await file.readAsBytes();
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.fields['name'] = fileName;
      request.fields['parents'] = folderId;
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));
      final response = await request.send();
      final body = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final json = jsonDecode(body);
        return json['id'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getFileUrl(String fileId) async {
    if (accessToken == null) return null;
    final url = 'https://www.googleapis.com/drive/v3/files/$fileId?alt=media';
    return url;
  }

  Future<bool> deleteFile(String fileId) async {
    try {
      if (accessToken == null) return false;
      final url = Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId');
      final response = await http.delete(url, headers: {
        'Authorization': 'Bearer $accessToken',
      });
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
