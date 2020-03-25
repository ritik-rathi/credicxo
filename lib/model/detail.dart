class Details {
  final String did;
  final String name;
  final String site;

  Details(this.did, this.name, this.site);

  Details.fromHJson(Map<String, dynamic> json)
      : did = json["id"],
        name = json["name"],
        site = json["site"];
}

class Cast {
  final String name;
  final String image;

  Cast(this.image, this.name);

  Cast.fromJson(Map<String, dynamic> json)
    : name = json["name"],
      image = json["profile_path"];
}

class Genre {
  final String genre;

  Genre(this.genre);

  Genre.fromJson(Map<String, dynamic> json)
    : genre = json["name"];
}