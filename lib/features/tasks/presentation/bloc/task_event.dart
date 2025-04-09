
import 'package:equatable/equatable.dart';
import 'package:myapp/features/tasks/data/models/task_collection.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

// Event to load tasks initially
class LoadTasks extends TaskEvent {}

// Event triggered when the underlying task data changes (from the stream)
class TasksUpdated extends TaskEvent {
  final List<TaskCollection> tasks;
  const TasksUpdated(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

// Event to add a new task
class AddTask extends TaskEvent {
  final TaskCollection task;
  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

// Event to update an existing task
class UpdateTask extends TaskEvent {
  final TaskCollection task;
  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

// Event to delete a task
class DeleteTask extends TaskEvent {
  final int taskId;
  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

// Event to toggle task completion status
class ToggleTaskCompletion extends TaskEvent {
  final int taskId;
  const ToggleTaskCompletion(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
