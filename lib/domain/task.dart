import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  @JsonSerializable(explicitToJson: true)
  const factory Task({
    String? id,
    required String title,
    required String description,
    required bool isCompleted
  }) = _Task;

  factory Task.fromJson(Map<String, Object?> json)
      => _$TaskFromJson(json);
}