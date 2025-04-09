
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/theme/theme_cubit.dart'; // Import ThemeCubit
import 'package:myapp/features/tasks/data/models/task_collection.dart';
import 'package:myapp/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:myapp/features/tasks/presentation/bloc/task_event.dart';
import 'package:myapp/features/tasks/presentation/bloc/task_state.dart';
import 'package:myapp/features/tasks/presentation/widgets/add_task_dialog.dart';
import 'package:intl/intl.dart'; // For date formatting

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Load tasks when the screen is built (if not already loaded)
    context.read<TaskBloc>().add(LoadTasks());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          // Theme Toggle Button
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(state == ThemeMode.light ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
                tooltip: 'Toggle Theme',
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          // TODO: Add other actions like filter, search, logout etc.
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStatus.loading && state.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TaskStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          if (state.tasks.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                "  No tasks yet. ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          // Display list of tasks
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80), // Add padding for FAB
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return _TaskListItem(task: task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddTaskDialog(
              taskBloc: BlocProvider.of<TaskBloc>(context),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}

class _TaskListItem extends StatelessWidget {
  final TaskCollection task;

  const _TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    final taskBloc = context.read<TaskBloc>();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      // Use Card properties defined in AppTheme
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) {
            taskBloc.add(ToggleTaskCompletion(task.id));
          },
          // CheckboxTheme applied globally
        ),
        title: Text(
          task.title ?? 'No Title',
          style: task.isCompleted
              ? textTheme.titleMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey, // Explicitly set grey for completed
                )
              : textTheme.titleMedium,
        ),
        subtitle: task.dueDate != null
            ? Text(
                'Due: ${DateFormat.yMd().add_jm().format(task.dueDate!)}',
                style: task.isCompleted
                    ? textTheme.bodySmall?.copyWith(color: Colors.grey)
                    : textTheme.bodySmall,
               )
            : (task.description?.isNotEmpty ?? false) // Show description if no due date
                ? Text(
                    task.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: task.isCompleted
                        ? textTheme.bodySmall?.copyWith(color: Colors.grey)
                        : textTheme.bodySmall,
                   )
                : null,
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: colorScheme.error),
          tooltip: 'Delete Task',
          onPressed: () {
            // Confirmation Dialog
            showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Text('Delete Task?'),
                  content: Text('Are you sure you want to delete "${task.title ?? 'this task'}"?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(ctx).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      child: Text('Delete', style: TextStyle(color: colorScheme.error)),
                      onPressed: () {
                        taskBloc.add(DeleteTask(task.id));
                        Navigator.of(ctx).pop(); // Close the dialog
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        onTap: () {
          // TODO: Navigate to Task Detail Screen or Edit Dialog
          print('Tapped on task: ${task.title}');
        },
      ),
    );
  }
}
