class UserApi {
  final int id;
  final String name;
  final String keyFirebase;
  final String idStudent;
  final String classRoom;
  final String phone;
  final String email;

  UserApi({
    this.id = 0,
    this.name,
    this.keyFirebase,
    this.idStudent,
    this.classRoom,
    this.phone,
    this.email,
  });

  UserApi.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        keyFirebase = json["keyFirebase"],
        idStudent = json["idStudent"],
        classRoom = json["class"],
        phone = json["phone"],
        email = json["email"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "idStudent": idStudent,
        "keyFirebase": keyFirebase,
        "name": name,
        "email": email,
        "class": classRoom,
        "phone": phone,
      };
  //   {
  //     "id": 6,
  //     "idStudent": "D14DCCN043",
  //     "keyFirebase": "3HMA2VkTEFWGMP2vy7iLLQaPcsj1",
  //     "name": "Trần Văn Hạnh",
  //     "email": "tanhanh@ptithcm.edu.vn",
  //     "class": "D14CQCN033",
  //     "phone": "0900897878"
  // }
}
