
import 'package:myapp/features/tasks/data/models/task_collection.dart';
import 'package:myapp/features/tasks/domain/repositories/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  Future<void> call(TaskCollection task) async {
    await repository.addTask(task);
  }
}
