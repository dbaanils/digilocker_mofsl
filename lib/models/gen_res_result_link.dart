class GenResResultLink{
  String? link;

  GenResResultLink(this.link);

  GenResResultLink.fromJson(dynamic json)
      : link =  json['link'];

  Map<String, dynamic>  toJson() => {
    'link': link,
  };

}