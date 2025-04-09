
import 'package:myapp/features/tasks/domain/repositories/task_repository.dart';

class ToggleTaskCompletionUseCase {
  final TaskRepository repository;

  ToggleTaskCompletionUseCase(this.repository);

  Future<void> call(int taskId) async {
    await repository.toggleTaskCompletion(taskId);
  }
}
