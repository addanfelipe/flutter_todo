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

  Future<TasksPagedHttpResponse> getTasks(
      {int? page, int? limit, required bool isCompleted}) async {
    final response = await _dio.get(
      "/tasks",
      queryParameters: {
        '_page': page,
        '_per_page': limit,
        'isCompleted': isCompleted
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

      return receivedData;
    } else {
      throw Exception('Unknown error');
    }
  }

  Future<Task> createTask({required Task task}) async {
    final data = task.toJson();
    data.remove("id");

    final response = await _dio.post("/tasks", data: data);

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw NetworkException(
        statusCode: response.statusCode!,
        message: response.statusMessage,
      );
    } else if (response.statusCode != null) {
      return Task.fromJson(response.data);
    } else {
      throw Exception('Unknown error');
    }
  }
}
