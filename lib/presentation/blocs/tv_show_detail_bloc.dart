import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tedflix_app/domain/entities/tv_show_detail_entity.dart';
import 'package:tedflix_app/domain/entities/movie_params.dart';
import 'package:tedflix_app/domain/usecases/get_tv_show_details.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';

// Events
abstract class TVShowDetailEvent extends Equatable {
  const TVShowDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadTVShowDetail extends TVShowDetailEvent {
  final int id;

  const LoadTVShowDetail(this.id);

  @override
  List<Object> get props => [id];
}

// States
abstract class TVShowDetailState extends Equatable {
  const TVShowDetailState();

  @override
  List<Object> get props => [];
}

class TVShowDetailInitial extends TVShowDetailState {}

class TVShowDetailLoading extends TVShowDetailState {}

class TVShowDetailLoaded extends TVShowDetailState {
  final TVShowDetailEntity tvShowDetail;

  const TVShowDetailLoaded(this.tvShowDetail);

  @override
  List<Object> get props => [tvShowDetail];
}

class TVShowDetailError extends TVShowDetailState {
  final AppErrorType errorType;

  const TVShowDetailError(this.errorType);

  @override
  List<Object> get props => [errorType];
}

// Bloc
class TVShowDetailBloc extends Bloc<TVShowDetailEvent, TVShowDetailState> {
  final GetTVShowDetails getTVShowDetails;

  TVShowDetailBloc({
    required this.getTVShowDetails,
  }) : super(TVShowDetailInitial()) {
    on<LoadTVShowDetail>(_onLoadTVShowDetail);
  }

  Future<void> _onLoadTVShowDetail(
    LoadTVShowDetail event,
    Emitter<TVShowDetailState> emit,
  ) async {
    emit(TVShowDetailLoading());
    final result = await getTVShowDetails(event.id);
    result.fold(
      (failure) => emit(TVShowDetailError(failure.appErrorType)),
      (tvShowDetail) => emit(TVShowDetailLoaded(tvShowDetail)),
    );
  }
}
