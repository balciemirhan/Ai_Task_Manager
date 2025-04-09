
import 'package:equatable/equatable.dart';
import 'package:myapp/features/tasks/data/models/task_collection.dart';

// Enum for different loading/error states
enum TaskStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  final List<TaskCollection> tasks;
  final TaskStatus status;
  final String? errorMessage;

  const TaskState({
    this.tasks = const [],
    this.status = TaskStatus.initial,
    this.errorMessage,
  });

  TaskState copyWith({
    List<TaskCollection>? tasks,
    TaskStatus? status,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [tasks, status, errorMessage];
}
