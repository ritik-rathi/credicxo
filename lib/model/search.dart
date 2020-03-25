class Search {
  final int id;
  final String poster;
  final String title;

  Search(this.id, this.poster, this.title);

  Search.fromJson(Map<String, dynamic> json) 
    : id = json['id'],
      poster = json['poster_path'],
      title = json['title'];
}
