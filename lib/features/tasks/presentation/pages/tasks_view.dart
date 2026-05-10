import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sync_bridge/features/tasks/data/models/update_task_request.dart';
import 'package:sync_bridge/features/tasks/domain/entities/sync_log_entity.dart';
import 'package:sync_bridge/features/tasks/domain/entities/task_entity.dart';
import 'package:sync_bridge/features/tasks/presentation/blocs/tasks/tasks_bloc.dart';
import 'package:sync_bridge/features/tasks/presentation/widgets/app_bar.dart';
import 'package:sync_bridge/features/tasks/presentation/widgets/conflict_bottom_sheet.dart';
import 'package:sync_bridge/features/tasks/presentation/widgets/empty_state.dart';
import 'package:sync_bridge/features/tasks/presentation/widgets/sync_log_banner.dart';
import 'package:sync_bridge/features/tasks/presentation/widgets/task_tile.dart';
import 'package:sync_bridge/shared/widgets/base_view.dart';
import 'package:sync_bridge/utils/extensions.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView>
    with BaseViewMixin<TasksBloc, TasksState, TasksView> {
  List<TaskEntity>? _tasks;
  StreamSubscription<List<TaskEntity>>? _tasksSub;
  SyncLogEntity? _syncLog;

  @override
  void initState() {
    super.initState();
    bloc.add(const GetTasksStarted());
    bloc.add(const WatchSyncStatusStarted());
  }

  @override
  void dispose() {
    _tasksSub?.cancel();
    super.dispose();
  }

  @override
  void onState(BuildContext context, TasksState state) {
    if (state is GetTasksSuccess) {
      _tasksSub?.cancel();
      _tasksSub = state.stream.listen((tasks) {
        if (mounted) setState(() => _tasks = tasks);
      });
    } else if (state is UpdateTaskConflict) {
      _showConflictSheet(state.task);
    } else if (state is SyncStatusUpdate) {
      setState(() => _syncLog = state.log);
    }
  }

  void _showConflictSheet(TaskEntity task) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => ConflictBottomSheet(
            task: task,
            onResolve: (useServer) {
              Navigator.of(context).pop();
              bloc.add(
                ResolveConflictStartedStarted(
                  UpdateTaskRequest(
                    completed: task.completed == 1,
                    userId: task.userId,
                    title: task.title,
                    id: task.id,
                  ),
                  useServer,
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar(
        colors: colors,
        hasPending: _tasks?.any((t) => t.isDirty == 1) ?? false,
        onSync: () => bloc.add(const SyncPendingQueueStarted()),
        onSignOut: () => logOut(),
      ),
      body: Column(
        children: [
          if (_syncLog != null) SyncLogBanner(log: _syncLog!),
          Expanded(
            child:
                _tasks == null
                    ? const SizedBox.shrink()
                    : _tasks!.isEmpty
                    ? EmptyState(colors: colors)
                    : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
                      itemCount: _tasks!.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder:
                          (context, index) => TaskTile(
                            task: _tasks![index],
                            colors: colors,
                            onToggle:
                                (completed) => bloc.add(
                                  UpdateTaskStarted(
                                    UpdateTaskRequest(
                                      id: _tasks![index].id,
                                      userId: _tasks![index].userId,
                                      title: _tasks![index].title,
                                      completed: completed,
                                    ),
                                  ),
                                ),
                            onConflictTap:
                                () => _showConflictSheet(_tasks![index]),
                          ),
                    ),
          ),
        ],
      ),
    );
  }
}
