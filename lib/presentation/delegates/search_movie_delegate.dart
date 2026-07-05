import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> currentMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  //Mientras estoy escribiendo, tiene que girar.
  //Si recibo peliculas, tiene que aparecer de nuevo el boton de close.

  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.currentMovies,
  });
  void clearStreams() {
    _debounceTimer?.cancel();
    if (!debouncedMovies.isClosed) {
      debouncedMovies.close();
    }
    if (!isLoadingStream.isClosed) {
      isLoadingStream.close();
    }
  }

  void _onQueryChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    isLoadingStream.add(true);

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final movies = await searchMovies(query);
        currentMovies = movies;
        debouncedMovies.add(movies);
      } finally {
        isLoadingStream.add(false);
      }
    });
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: currentMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder<bool>(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          final isLoading = snapshot.data ?? false;
          if (isLoading) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () {
                  query = '';
                  isLoadingStream.add(false);
                },
                icon: Icon(Icons.refresh),
              ),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: () {
                query = '';
                currentMovies = [];
                debouncedMovies.add([]);
                isLoadingStream.add(false);
              },
              icon: Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final buildResults = buildResultsAndSuggestions();
    return buildResults;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Busca una pelicula'));
    }

    _onQueryChanged(query);
    final buildSuggestions = buildResultsAndSuggestions();
    return buildSuggestions;
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final void Function(BuildContext, Movie) onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            //image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) =>
                      FadeIn(child: child),
                ),
              ),
            ),
            const SizedBox(width: 10),

            SizedBox(
              width: size.width * .7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium),
                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),

                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.amber),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!.copyWith(
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //description
          ],
        ),
      ),
    );
  }
}
