class Movies {
  final int id;
  final String poster;
  final String title;

  Movies(this.id, this.poster, this.title);

  Movies.fromJson(Map<String, dynamic> json) 
    : id = json['id'],
      poster = json['poster_path'],
      title = json['title'];
}
