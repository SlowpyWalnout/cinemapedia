import 'package:cinemapedia/presentation/screens/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final isFavoriteMovieProvider = FutureProvider.family.autoDispose<bool, int>((
final isFavoriteMovieProvider = FutureProvider.family<bool, int>((
  ref,
  movieId,
) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isFavoriteMovie(movieId);
});
