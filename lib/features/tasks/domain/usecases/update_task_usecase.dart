
import 'package:myapp/features/tasks/data/models/task_collection.dart';
import 'package:myapp/features/tasks/domain/repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> call(TaskCollection task) async {
    await repository.updateTask(task);
  }
}
