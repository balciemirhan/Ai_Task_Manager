
import 'package:myapp/features/tasks/domain/repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call(int taskId) async {
    await repository.deleteTask(taskId);
  }
}
