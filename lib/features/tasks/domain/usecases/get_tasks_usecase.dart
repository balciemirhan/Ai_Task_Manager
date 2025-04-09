
import 'package:myapp/features/tasks/data/models/task_collection.dart';
import 'package:myapp/features/tasks/domain/repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<TaskCollection>> call() async {
    return await repository.getTasks();
  }
}
