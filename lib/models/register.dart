class Register {
  final int id;
  final int idTopic;
  final String idStudent;
  final int role;
  final int browseTopic;

  Register({
    this.id = 0,
    this.idTopic,
    this.idStudent,
    this.role,
    this.browseTopic,
  });
  Register.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        idTopic = json["idTopic"],
        idStudent = json["idStudent"],
        role = json["role"],
        browseTopic = json["browseTopic"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "idTopic": idTopic,
        "idStudent": idStudent,
        "role": role,
        "browseTopic": browseTopic
      };
}
