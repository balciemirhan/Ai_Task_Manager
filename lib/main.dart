
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

// Import Firebase options generated by FlutterFire CLI
import 'firebase_options.dart';

// Import Core components
import 'core/router/app_router.dart';
import 'core/services/storage_service.dart';
import 'core/theme/theme_cubit.dart'; // Import ThemeCubit
import 'core/theme/app_theme.dart'; // Import AppTheme (To be created)

// --- Import Auth feature components ---
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

// --- Import Task feature components ---
import 'features/tasks/data/models/task_collection.dart';
import 'features/tasks/data/datasources/task_local_data_source.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/domain/repositories/task_repository.dart';
import 'features/tasks/domain/usecases/add_task_usecase.dart';
import 'features/tasks/domain/usecases/delete_task_usecase.dart';
import 'features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'features/tasks/domain/usecases/toggle_task_completion_usecase.dart';
import 'features/tasks/domain/usecases/update_task_usecase.dart';
import 'features/tasks/domain/usecases/watch_tasks_usecase.dart';
import 'features/tasks/presentation/bloc/task_bloc.dart';
import 'features/tasks/presentation/bloc/task_event.dart';


// Global instance for Isar (consider using a proper DI solution like get_it)
late Isar isarInstance;
// Global StorageService instance (consider DI)
late StorageService storageService;

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // --- Initialization tasks ---
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  isarInstance = await _openIsar();
  storageService = StorageService(); // Initialize storage service

  // --- Dependency Setup ---
  // Auth Dependencies
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSourceImpl();
  final AuthRepository authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
  final LoginUseCase loginUseCase = LoginUseCase(authRepository: authRepository);
  final RegisterUseCase registerUseCase = RegisterUseCase(authRepository: authRepository);
  final LogoutUseCase logoutUseCase = LogoutUseCase(authRepository: authRepository);

  // Task Dependencies
  final TaskLocalDataSource taskLocalDataSource = TaskLocalDataSourceImpl(isar: isarInstance);
  final TaskRepository taskRepository = TaskRepositoryImpl(localDataSource: taskLocalDataSource);
  final AddTaskUseCase addTaskUseCase = AddTaskUseCase(taskRepository);
  final DeleteTaskUseCase deleteTaskUseCase = DeleteTaskUseCase(taskRepository);
  final GetTasksUseCase getTasksUseCase = GetTasksUseCase(taskRepository);
  final ToggleTaskCompletionUseCase toggleTaskUseCase = ToggleTaskCompletionUseCase(taskRepository);
  final UpdateTaskUseCase updateTaskUseCase = UpdateTaskUseCase(taskRepository);
  final WatchTasksUseCase watchTasksUseCase = WatchTasksUseCase(taskRepository);

  // --- BLoC/Cubit Creation ---
  final authBloc = AuthBloc(
    loginUseCase: loginUseCase,
    registerUseCase: registerUseCase,
    logoutUseCase: logoutUseCase,
  )..add(AuthCheckRequested());

  final taskBloc = TaskBloc(
      addTaskUseCase: addTaskUseCase,
      deleteTaskUseCase: deleteTaskUseCase,
      getTasksUseCase: getTasksUseCase,
      toggleTaskCompletionUseCase: toggleTaskUseCase,
      updateTaskUseCase: updateTaskUseCase,
      watchTasksUseCase: watchTasksUseCase,
  )..add(LoadTasks());

  final themeCubit = ThemeCubit(storageService); // Create ThemeCubit

  // Run the app
  runApp(MyApp(
    authBloc: authBloc,
    taskBloc: taskBloc,
    themeCubit: themeCubit,
  ));
}

Future<Isar> _openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  if (Isar.instanceNames.isEmpty) {
    return await Isar.open(
      [TaskCollectionSchema],
      directory: dir.path,
      name: 'taskManagerDB',
    );
  } else {
    return Future.value(Isar.getInstance('taskManagerDB')!); // Return existing instance
  }
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final TaskBloc taskBloc;
  final ThemeCubit themeCubit; // Add ThemeCubit

  const MyApp({
    super.key,
    required this.authBloc,
    required this.taskBloc,
    required this.themeCubit,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: authBloc),
            BlocProvider.value(value: taskBloc),
            BlocProvider.value(value: themeCubit), // Provide ThemeCubit
          ],
          // Use BlocBuilder to react to ThemeCubit state changes
          child: BlocBuilder<ThemeCubit, ThemeMode>(
             builder: (context, themeMode) {
                return MaterialApp.router(
                  title: 'Task Manager',
                  debugShowCheckedModeBanner: false,
                  routerConfig: AppRouter.router,

                  // --- Theming --- //
                  themeMode: themeMode, // Set themeMode from Cubit
                  theme: AppTheme.lightTheme, // Use light theme data (from app_theme.dart)
                  darkTheme: AppTheme.darkTheme, // Use dark theme data (from app_theme.dart)

                  // Previous basic theme setup commented out
                  // theme: ThemeData(
                  //   useMaterial3: true,
                  //   brightness: Brightness.light,
                  //   primarySwatch: Colors.blue,
                  //   visualDensity: VisualDensity.adaptivePlatformDensity,
                  //   textTheme: GoogleFonts.latoTextTheme(
                  //     Theme.of(context).textTheme.apply(bodyColor: Colors.black87),
                  //   ),
                  // ),
                  // darkTheme: ThemeData(
                  //   useMaterial3: true,
                  //   brightness: Brightness.dark,
                  //   primarySwatch: Colors.blue,
                  //   visualDensity: VisualDensity.adaptivePlatformDensity,
                  //   textTheme: GoogleFonts.latoTextTheme(
                  //     Theme.of(context).textTheme.apply(bodyColor: Colors.white70),
                  //   ),
                  // ),
                );
             },
          ),
        );
      },
    );
  }
}
