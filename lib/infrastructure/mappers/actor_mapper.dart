import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
    id: cast.id,
    name: cast.name,
    profilePath: cast.profilePath != null
        ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
        : 'https://img.magnific.com/premium-vector/default-profile-picture-icon-high-resolution_852381-3658.jpg?semt=ais_hybrid&w=740&q=80',
    character: cast.character,
  );
}
