
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/tasks/data/models/task_collection.dart';
import 'package:myapp/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:myapp/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:myapp/features/tasks/domain/usecases/get_tasks_usecase.dart'; // Not directly used if watching
import 'package:myapp/features/tasks/domain/usecases/toggle_task_completion_usecase.dart';
import 'package:myapp/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:myapp/features/tasks/domain/usecases/watch_tasks_usecase.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AddTaskUseCase _addTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final GetTasksUseCase _getTasksUseCase; // Keep for potential initial load
  final ToggleTaskCompletionUseCase _toggleTaskCompletionUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final WatchTasksUseCase _watchTasksUseCase;

  StreamSubscription<List<TaskCollection>>? _taskSubscription;

  TaskBloc({
    required AddTaskUseCase addTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required GetTasksUseCase getTasksUseCase,
    required ToggleTaskCompletionUseCase toggleTaskCompletionUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required WatchTasksUseCase watchTasksUseCase,
  })  : _addTaskUseCase = addTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        _getTasksUseCase = getTasksUseCase,
        _toggleTaskCompletionUseCase = toggleTaskCompletionUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        _watchTasksUseCase = watchTasksUseCase,
        super(const TaskState()) {

    on<LoadTasks>(_onLoadTasks);
    on<TasksUpdated>(_onTasksUpdated);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) {
     // Cancel previous subscription if exists
    _taskSubscription?.cancel();
    // Start listening to the stream
    _taskSubscription = _watchTasksUseCase().listen(
      (tasks) {
        // Add an event to update the state when new data arrives
        add(TasksUpdated(tasks));
      },
      onError: (error) {
        // Handle stream errors
        emit(state.copyWith(status: TaskStatus.failure, errorMessage: error.toString()));
      },
    );
     emit(state.copyWith(status: TaskStatus.loading));
    // Initial load is handled by the stream's fireImmediately or the first event
  }

  void _onTasksUpdated(TasksUpdated event, Emitter<TaskState> emit) {
    emit(state.copyWith(status: TaskStatus.success, tasks: event.tasks));
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    // Optionally emit loading state
    // emit(state.copyWith(status: TaskStatus.loading)); // Be careful with quick operations
    try {
      await _addTaskUseCase(event.task);
      // No need to manually update state here, the watcher will trigger TasksUpdated
      // emit(state.copyWith(status: TaskStatus.success)); // Remove if relying on watcher
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await _updateTaskUseCase(event.task);
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await _deleteTaskUseCase(event.taskId);
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onToggleTaskCompletion(ToggleTaskCompletion event, Emitter<TaskState> emit) async {
    try {
      await _toggleTaskCompletionUseCase(event.taskId);
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}
