import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieMasonry extends StatefulWidget {
  final List<Movie> movies;
  // final Future<List<Movie>> Function()? loadNextPage;
  final Future<List<Movie>?> Function()? loadNextPage;

  const MovieMasonry({super.key, required this.movies, this.loadNextPage});

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  bool isLastPage = false;
  bool isLoading = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      // if (widget.loadNextPage == null) return;
      //si el scroll esta al final o cerca de 200 px del fondo.
      //llamar load next page
      if (scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent) {
        loadNextPageMovies();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadNextPageMovies() async {
    if (isLoading || isLastPage) return;
    if (widget.loadNextPage == null) return;

    isLoading = true;

    try {
      final movies = await widget.loadNextPage!();

      if (movies == null) return;

      if (movies.isEmpty) {
        isLastPage = true;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          final movie = widget.movies[index];
          final random = Random(movie.id);

          //delay estable entre 50 y 300 milisegundos
          final delay = Duration(milliseconds: 100 + random.nextInt(400));
          //duracion estable entre 350 y 650 milisegundos.
          final duration = Duration(milliseconds: 350 + random.nextInt(600));

          // Alterna la altura de los pósters
          final double height = (index % 5 == 0) ? 260 : 180;

          return FadeInUp(
            key: ValueKey(movie.id),
            delay: delay,
            duration: duration,

            child: SizedBox(
              height: height,
              child: FadeInUp(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MoviePosterLink(movie: movie),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
