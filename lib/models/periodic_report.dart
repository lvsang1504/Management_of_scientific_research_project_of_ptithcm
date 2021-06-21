class PeriodicReport {
  final int id;
  final String topicCode;
  final String idStudent;
  final String field;
  final String content;
  final String image;
  final String dateStarted;
  final String dateEnd;

  PeriodicReport({
    this.id,
    this.topicCode,
    this.idStudent,
    this.field,
    this.content,
    this.image,
    this.dateStarted,
    this.dateEnd,
  });

   PeriodicReport.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        topicCode = json["topicCode"],
        idStudent = json["name"],
        field = json["field"],
        content = json["content"],
        image = json["image"],
        dateStarted = json["dateStarted"],
        dateEnd = json["dateEnd"];
}
