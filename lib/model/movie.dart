class Movie {
  int id;
  String? title;
  String? orginalLanguage;
  String? orginalTitle;
  String? overview;
  int? adult;
  String? backdropPath;
  List<int?> genreIds;
  double? popularity;
  String? posterPath;
  int? releaseDate;
  int? video;
  double? voteAverage;
  double? voteCount;

  //Non-model variable that help us using multi-select
  bool isSelected = false;

  String tableName = 'Movie';

  Movie._internal(this.id, this.title, this.orginalLanguage, this.orginalTitle,
      this.overview, this.adult, this.genreIds,
      [this.backdropPath = "",
      this.popularity,
      this.posterPath,
      this.video = 0,
      this.voteAverage = 1,
      this.voteCount = 1]) {
    releaseDate ??= DateTime.now().millisecondsSinceEpoch;
  }

  factory Movie.empty() {
    return Movie._internal(0, '', '', '', '', 0, []);
  }

  factory Movie.fromMap(Map<String, dynamic> data) {
    return Movie._internal(
        data['id'],
        data['title'],
        data['orginal_language'],
        data['orginal_title'],
        data['overview'],
        data['adult'],
        data['genre_ids'],
        data['backdrop_path'],
        data['popularity'],
        data['poster_path'],
        data['video'],
        data['vote_average'],
        data['vote_count']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'title': title,
      'orginal_language': orginalLanguage,
      'orginal_title': orginalTitle,
      'overview': overview,
      'adult': adult,
      'genre_ids': genreIds,
      'backdrop_path': backdropPath,
      'popularity': popularity,
      'poster_path': posterPath,
      'video': video,
      'vote_average': voteAverage,
      'vote_count': voteCount
    };
  }
}
