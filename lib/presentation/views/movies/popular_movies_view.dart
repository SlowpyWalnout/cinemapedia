import 'package:cinemapedia/presentation/screens/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularsView extends ConsumerStatefulWidget {
  const PopularsView({super.key});

  @override
  ConsumerState<PopularsView> createState() => _PopularsViewState();
}

class _PopularsViewState extends ConsumerState<PopularsView>
    with AutomaticKeepAliveClientMixin<PopularsView> {
  @override
  void initState() {
    super.initState();
    final popularMovies = ref.read(popularMoviesProvider);
    if (popularMovies.isEmpty) {
      ref.read(popularMoviesProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final popularMovies = ref.watch(popularMoviesProvider);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return ref.read(popularMoviesProvider.notifier).loadNextPage();
        },
        child: MovieMasonry(
          movies: popularMovies,
          loadNextPage: () {
            return ref.read(popularMoviesProvider.notifier).loadNextPage();
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
