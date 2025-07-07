import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tedflix_app/domain/entities/season_entity.dart';
import 'package:tedflix_app/domain/usecases/get_tv_show_seasons.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';

// Events
abstract class SeasonEvent extends Equatable {
  const SeasonEvent();

  @override
  List<Object> get props => [];
}

class LoadSeason extends SeasonEvent {
  final int tvShowId;
  final int seasonNumber;

  const LoadSeason({
    required this.tvShowId,
    required this.seasonNumber,
  });

  @override
  List<Object> get props => [tvShowId, seasonNumber];
}

// States
abstract class SeasonState extends Equatable {
  const SeasonState();

  @override
  List<Object> get props => [];
}

class SeasonInitial extends SeasonState {}

class SeasonLoading extends SeasonState {}

class SeasonLoaded extends SeasonState {
  final SeasonEntity season;

  const SeasonLoaded(this.season);

  @override
  List<Object> get props => [season];
}

class SeasonError extends SeasonState {
  final AppErrorType errorType;

  const SeasonError(this.errorType);

  @override
  List<Object> get props => [errorType];
}

// Bloc
class SeasonBloc extends Bloc<SeasonEvent, SeasonState> {
  final GetTVShowSeasons getTVShowSeasons;

  SeasonBloc({
    required this.getTVShowSeasons,
  }) : super(SeasonInitial()) {
    on<LoadSeason>(_onLoadSeason);
  }

  Future<void> _onLoadSeason(
    LoadSeason event,
    Emitter<SeasonState> emit,
  ) async {
    emit(SeasonLoading());
    final result = await getTVShowSeasons({
      'tvShowId': event.tvShowId,
      'seasonNumber': event.seasonNumber,
    });
    result.fold(
      (failure) => emit(SeasonError(failure.appErrorType)),
      (season) => emit(SeasonLoaded(season)),
    );
  }
}
