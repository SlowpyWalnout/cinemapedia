import 'package:cinemapedia/presentation/screens/storage/favorite_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {
  @override
  void initState() {
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider);
    final myMovieList = favoriteMovies.values.toList();

    return Scaffold(
      body: ListView.builder(
        itemCount: favoriteMovies.keys.length,
        itemBuilder: (BuildContext context, int index) {
          final movie = myMovieList[index];
          return ListTile(title: Text(movie.title));
        },
      ),
    );
  }
}
