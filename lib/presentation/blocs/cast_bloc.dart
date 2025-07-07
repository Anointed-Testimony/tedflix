import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/domain/entities/cast_entity.dart';
import 'package:tedflix_app/domain/usecases/get_tv_show_cast.dart';

// Events
abstract class CastEvent {}

class LoadCast extends CastEvent {
  final int tvShowId;

  LoadCast(this.tvShowId);
}

// States
abstract class CastState {}

class CastInitial extends CastState {}

class CastLoading extends CastState {}

class CastLoaded extends CastState {
  final List<CastEntity> cast;

  CastLoaded(this.cast);
}

class CastError extends CastState {
  final String errorType;

  CastError(this.errorType);
}

// Bloc
class CastBloc extends Bloc<CastEvent, CastState> {
  final GetTVShowCast getTVShowCast;

  CastBloc({required this.getTVShowCast}) : super(CastInitial()) {
    on<LoadCast>((event, emit) async {
      emit(CastLoading());
      final result = await getTVShowCast(event.tvShowId);
      result.fold(
        (failure) => emit(CastError(failure.toString())),
        (cast) => emit(CastLoaded(cast)),
      );
    });
  }
}
