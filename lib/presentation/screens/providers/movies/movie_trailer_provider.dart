import 'package:cinemapedia/presentation/screens/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieTrailerProvider = FutureProvider.family<String?, String>((
  ref,
  movieId,
) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getMovieTrailer(movieId);
});
