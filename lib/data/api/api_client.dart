import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_todo/domain/task.dart';

import '../../domain/exception/network_exception.dart';
import 'tasks_http_responses.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({required String baseUrl}) {
    _dio = Dio()
      ..options.baseUrl = baseUrl
      //..options.headers
      ..interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
  }

  Future<List<Task>> getTasks({int? page, int? limit}) async {
    final response = await _dio.get(
      "/tasks",
      queryParameters: {
        '_page': page,
        '_per_page': limit,
      },
    );
    if (response.statusCode != null && response.statusCode! >= 400) {
      throw NetworkException(
        statusCode: response.statusCode!,
        message: response.statusMessage,
      );
    } else if (response.statusCode != null) {
      final TasksPagedHttpResponse receivedData =
          TasksPagedHttpResponse.fromJson(
              response.data as Map<String, dynamic>);

      return receivedData.data;
    } else {
      throw Exception('Unknown error');
    }
  }
}
