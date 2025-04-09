
import 'package:isar/isar.dart';
import 'package:myapp/features/tasks/data/models/task_collection.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskCollection>> getTasks();
  Stream<List<TaskCollection>> watchTasks();
  Future<void> addTask(TaskCollection task);
  Future<void> updateTask(TaskCollection task);
  Future<void> deleteTask(int taskId);
  Future<void> toggleTaskCompletion(int taskId);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Isar isar;

  TaskLocalDataSourceImpl({required this.isar});

  @override
  Future<List<TaskCollection>> getTasks() async {
    return await isar.taskCollections.where().sortByCreatedAtDesc().findAll();
    // Add filtering/sorting as needed, e.g., .filter().isCompletedEqualTo(false)
  }

  @override
  Stream<List<TaskCollection>> watchTasks() async* {
    // Yield initial data
    yield await getTasks();
    // Watch for changes
    yield* isar.taskCollections.where().sortByCreatedAtDesc().watch(fireImmediately: false);
  }

  @override
  Future<void> addTask(TaskCollection task) async {
    await isar.writeTxn(() async {
      await isar.taskCollections.put(task);
    });
  }

  @override
  Future<void> updateTask(TaskCollection task) async {
    await isar.writeTxn(() async {
      await isar.taskCollections.put(task); // put handles both create and update
    });
  }

  @override
  Future<void> deleteTask(int taskId) async {
    await isar.writeTxn(() async {
      await isar.taskCollections.delete(taskId);
    });
  }

  @override
  Future<void> toggleTaskCompletion(int taskId) async {
     await isar.writeTxn(() async {
        final task = await isar.taskCollections.get(taskId);
        if (task != null) {
          task.isCompleted = !task.isCompleted;
          await isar.taskCollections.put(task);
        }
      });
  }
}
