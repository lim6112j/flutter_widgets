/// API client library using retrofit and dio
library api_client;

export 'models/user.dart';
export 'models/post.dart';
export 'services/json_placeholder_api.dart';
export 'package:dio/dio.dart';

import 'package:dio/dio.dart';
import 'services/json_placeholder_api.dart';

// Helper function to create a configured API client
JsonPlaceholderApi createApiClient({String? baseUrl}) {
  final dio = Dio();
  
  // Add interceptors for logging, authentication, etc.
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));
  
  return JsonPlaceholderApi(dio, baseUrl: baseUrl ?? 'https://jsonplaceholder.typicode.com');
}
