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
