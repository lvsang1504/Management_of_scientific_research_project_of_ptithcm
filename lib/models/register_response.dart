import 'package:management_of_scientific_research_project_of_ptithcm/models/register.dart';

class RegisterResponse {
  final List<Register> registers;
  final String error;

  RegisterResponse(
    this.registers,
    this.error,
  );

  RegisterResponse.fromJson(List<dynamic> json)
      : registers = json.map((e) => Register.fromJson(e)).toList(),
        error = "";
  RegisterResponse.withError(String error)
      : registers = [],
        error = error;
}
