
import 'package:myapp/features/tasks/data/models/task_collection.dart';

abstract class TaskRepository {
  Future<List<TaskCollection>> getTasks();
  Stream<List<TaskCollection>> watchTasks(); // Stream for real-time updates
  Future<void> addTask(TaskCollection task);
  Future<void> updateTask(TaskCollection task);
  Future<void> deleteTask(int taskId);
  Future<void> toggleTaskCompletion(int taskId);
}
