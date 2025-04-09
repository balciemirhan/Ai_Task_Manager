
import 'package:myapp/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:myapp/features/tasks/data/models/task_collection.dart';
import 'package:myapp/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  // final TaskRemoteDataSource remoteDataSource; // Optional: for syncing

  TaskRepositoryImpl({
    required this.localDataSource,
    // required this.remoteDataSource,
  });

  @override
  Future<List<TaskCollection>> getTasks() async {
    // TODO: Implement logic to fetch from local, maybe sync with remote
    return await localDataSource.getTasks();
  }

   @override
  Stream<List<TaskCollection>> watchTasks() {
    return localDataSource.watchTasks();
  }

  @override
  Future<void> addTask(TaskCollection task) async {
    // TODO: Implement logic to add locally and potentially sync to remote
    await localDataSource.addTask(task);
  }

  @override
  Future<void> updateTask(TaskCollection task) async {
    // TODO: Implement logic to update locally and potentially sync to remote
    await localDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(int taskId) async {
    // TODO: Implement logic to delete locally and potentially sync to remote
    await localDataSource.deleteTask(taskId);
  }

  @override
  Future<void> toggleTaskCompletion(int taskId) async {
    await localDataSource.toggleTaskCompletion(taskId);
  }

}
