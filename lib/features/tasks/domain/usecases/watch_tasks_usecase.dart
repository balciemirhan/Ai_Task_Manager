
import 'package:myapp/features/tasks/data/models/task_collection.dart';
import 'package:myapp/features/tasks/domain/repositories/task_repository.dart';

class WatchTasksUseCase {
  final TaskRepository repository;

  WatchTasksUseCase(this.repository);

  Stream<List<TaskCollection>> call() {
    return repository.watchTasks();
  }
}
