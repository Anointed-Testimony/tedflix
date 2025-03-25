import 'dart:convert';

import 'package:http/http.dart';
import 'package:tedflix_app/data/core/api_constants.dart';

class ApiClient {
  final Client _client;

  ApiClient(this._client);

  Future<dynamic> get(String path, {Map<String, String>? params}) async {
    final uri = Uri.parse(getPath(path, params ?? {}));
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    await Future.delayed(Duration(milliseconds: 10000));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  String getPath(String path, Map<String, String> params) {
    final queryParameters = {
      'api_key': ApiConstants.API_KEY,
      ...params,
    };

    final uri = Uri.parse('${ApiConstants.BASE_URL}$path');
    final queryString = Uri(queryParameters: queryParameters).query;
    
    return uri.replace(query: queryString).toString();
  }
}
