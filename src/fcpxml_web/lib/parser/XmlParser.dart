import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class Parser {
  final String host;
  const Parser({required this.host});
  Future<String> parse(List<int> bytes) async {
    final protocol = (this.host == 'localhost') ? 'http' : 'https';
    final uri = Uri.parse("${protocol}://${host}/api/upload");
    var request = http.MultipartRequest('POST', uri);
    final httpImage = http.MultipartFile.fromBytes(
      'fcpxml',
      bytes,
      contentType: MediaType.parse("multipart/form-data"),
      filename: 'fcpxml',
    );
    request.files.add(httpImage);
    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    return responseString;
  }
}
