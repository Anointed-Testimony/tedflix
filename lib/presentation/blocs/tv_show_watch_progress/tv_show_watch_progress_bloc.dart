import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/no_params.dart';
import 'package:tedflix_app/domain/entities/tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/usecases/delete_tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/usecases/get_all_tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/usecases/get_tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/usecases/save_tv_show_watch_progress.dart';

// Events
abstract class TVShowWatchProgressEvent {}

class SaveWatchProgress extends TVShowWatchProgressEvent {
  final TVShowWatchProgress progress;

  SaveWatchProgress(this.progress);
}

class GetWatchProgress extends TVShowWatchProgressEvent {
  final int tvShowId;

  GetWatchProgress({
    required this.tvShowId,
  });
}

class GetAllWatchProgress extends TVShowWatchProgressEvent {}

class DeleteWatchProgress extends TVShowWatchProgressEvent {
  final int tvShowId;

  DeleteWatchProgress({
    required this.tvShowId,
  });
}

// States
abstract class TVShowWatchProgressState {}

class TVShowWatchProgressInitial extends TVShowWatchProgressState {}

class TVShowWatchProgressLoading extends TVShowWatchProgressState {}

class TVShowWatchProgressLoaded extends TVShowWatchProgressState {
  final TVShowWatchProgress progress;

  TVShowWatchProgressLoaded(this.progress);
}

class TVShowWatchProgressListLoaded extends TVShowWatchProgressState {
  final List<TVShowWatchProgress> progressList;

  TVShowWatchProgressListLoaded(this.progressList);
}

class TVShowWatchProgressError extends TVShowWatchProgressState {
  final AppErrorType errorType;

  TVShowWatchProgressError(this.errorType);
}

// Bloc
class TVShowWatchProgressBloc
    extends Bloc<TVShowWatchProgressEvent, TVShowWatchProgressState> {
  final SaveTVShowWatchProgress saveWatchProgress;
  final GetTVShowWatchProgress getWatchProgress;
  final GetAllTVShowWatchProgress getAllWatchProgress;
  final DeleteTVShowWatchProgress deleteWatchProgress;

  TVShowWatchProgressBloc({
    required this.saveWatchProgress,
    required this.getWatchProgress,
    required this.getAllWatchProgress,
    required this.deleteWatchProgress,
  }) : super(TVShowWatchProgressInitial()) {
    on<SaveWatchProgress>(_onSaveWatchProgress);
    on<GetWatchProgress>(_onGetWatchProgress);
    on<GetAllWatchProgress>(_onGetAllWatchProgress);
    on<DeleteWatchProgress>(_onDeleteWatchProgress);
  }

  Future<void> _onSaveWatchProgress(
    SaveWatchProgress event,
    Emitter<TVShowWatchProgressState> emit,
  ) async {
    emit(TVShowWatchProgressLoading());
    final result = await saveWatchProgress(event.progress);
    result.fold(
      (l) => emit(TVShowWatchProgressError(l.appErrorType)),
      (r) => emit(TVShowWatchProgressInitial()),
    );
  }

  Future<void> _onGetWatchProgress(
    GetWatchProgress event,
    Emitter<TVShowWatchProgressState> emit,
  ) async {
    emit(TVShowWatchProgressLoading());
    final result = await getWatchProgress(event.tvShowId);
    result.fold(
      (l) => emit(TVShowWatchProgressError(l.appErrorType)),
      (r) => emit(TVShowWatchProgressLoaded(r)),
    );
  }

  Future<void> _onGetAllWatchProgress(
    GetAllWatchProgress event,
    Emitter<TVShowWatchProgressState> emit,
  ) async {
    emit(TVShowWatchProgressLoading());
    final result = await getAllWatchProgress(NoParams());
    result.fold(
      (l) => emit(TVShowWatchProgressError(l.appErrorType)),
      (r) => emit(TVShowWatchProgressListLoaded(r)),
    );
  }

  Future<void> _onDeleteWatchProgress(
    DeleteWatchProgress event,
    Emitter<TVShowWatchProgressState> emit,
  ) async {
    emit(TVShowWatchProgressLoading());
    final result = await deleteWatchProgress(event.tvShowId);
    result.fold(
      (l) => emit(TVShowWatchProgressError(l.appErrorType)),
      (r) => emit(TVShowWatchProgressInitial()),
    );
  }
}
