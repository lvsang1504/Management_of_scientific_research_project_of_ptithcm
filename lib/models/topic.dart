class Topic {
  final int id;
  final String topicCode;
  final String name;
  final String field;
  final String content;
  final String image;
  final String type;
  final int budget;
  final String dateCreated;
  final String acceptanceTime;
  final String note;

  Topic(
    this.id,
    this.topicCode,
    this.name,
    this.field,
    this.content,
    this.image,
    this.type,
    this.budget,
    this.dateCreated,
    this.acceptanceTime,
    this.note,
  );

  Topic.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        topicCode = json["topicCode"],
        name = json["name"],
        field = json["field"],
        content = json["content"],
        image = json["image"],
        type = json["type"],
        budget = json["budget"],
        dateCreated = json["dateCreated"],
        acceptanceTime = json["acceptanceTime"],
        note = json["note"];

    
}
