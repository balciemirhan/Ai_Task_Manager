
import 'package:isar/isar.dart';

// You need to run 'flutter pub run build_runner build' after creating/updating this file
part 'task_collection.g.dart'; // Generated file

@collection
class TaskCollection {
  Id id = Isar.autoIncrement; // Auto increment primary key

  @Index(type: IndexType.value)
  String? title;

  String? description;

  @Index(type: IndexType.value)
  DateTime? createdAt;

  DateTime? dueDate;

  @Index(type: IndexType.value)
  bool isCompleted;

  // TODO: Add other fields like priority, category, subtasks later
  // Example: final category = IsarLink<CategoryCollection>();
  // Example: final subtasks = IsarLinks<SubtaskCollection>();

  // Constructor
  TaskCollection({
    this.title,
    this.description,
    DateTime? createdAt,
    this.dueDate,
    this.isCompleted = false,
  }) : this.createdAt = createdAt ?? DateTime.now();
}
