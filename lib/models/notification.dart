class Notifications {
  final int id;
  final String content;
  final String idStudent;
  final String image;
  final String timeCreated;
  final bool isRead;
  final bool isDelete;

  Notifications(
    this.id,
    this.content,
    this.idStudent,
    this.image,
    this.timeCreated,
    this.isRead,
    this.isDelete,
  );

  Notifications.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        content = json["content"],
        idStudent = json["idStudent"],
        image = json["image"],
        timeCreated = json["timeCreated"],
        isRead = json["isRead"],
        isDelete = json["isDelete"];
}
