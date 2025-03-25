import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/cast_entity.dart';
import 'package:tedflix_app/domain/entities/movie_params.dart';
import 'package:tedflix_app/domain/usecases/get_cast.dart';

part 'cast_event.dart';
part 'cast_state.dart';

class CastBloc extends Bloc<CastEvent, CastState> {
  final GetCast getCast;

  CastBloc({required this.getCast}) : super(CastInitial()) {
    // Register the event handler for LoadCastEvent
    on<LoadCastEvent>((event, emit) async {
      emit(CastLoading());

      Either<AppError, List<CastEntity>> eitherResponse = await getCast(MovieParams(event.movieId));

      emit(eitherResponse.fold(
        (error) => CastError(),
        (casts) => CastLoaded(casts: casts),
      ));
    });
  }
}
