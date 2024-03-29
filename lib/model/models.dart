// Modelo para usuario
class UserOrProfessionalModel {
  String id;
  String name;
  String email;
  String phone;
  String cedula;
  String ciudad;
  String profession;
  String therapy;
  String location;
  String social;
  List<String> perfil;
  List<String> area;
  List<String> educacion;
  List<String> experiencia;

  UserOrProfessionalModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.cedula,
    required this.ciudad,
    required this.profession,
    required this.therapy,
    required this.location,
    required this.social,
    required this.perfil,
    required this.area,
    required this.educacion,
    required this.experiencia,
  });

  static UserOrProfessionalModel empty() {
    return UserOrProfessionalModel(
      id: '',
      name: '',
      email: '',
      phone: '',
      cedula: '',
      ciudad: '',
      profession: '',
      therapy: '',
      location: '',
      social: '',
      perfil: [],
      area: [],
      educacion: [],
      experiencia: [],
    );
  }

  factory UserOrProfessionalModel.fromJson(Map<String, dynamic> json) {
    return UserOrProfessionalModel(
      id: json['id'] ?? '',
      name: json['nombres'] ?? '',
      email: json['correo'] ?? '',
      phone: json['celular'] ?? '',
      cedula: json['cedula'] ?? '',
      ciudad: json['ciudad'] ?? '',
      profession: json['profession'] ?? '',
      therapy: json['therapy'] ?? '',
      location: json['location'] ?? '',
      social: json['social'] ?? '',
      perfil: List<String>.from(json['perfil'] ?? []),
      area: List<String>.from(json['area'] ?? []),
      educacion: List<String>.from(json['educacion'] ?? []),
      experiencia: List<String>.from(json['experiencia'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombres": name,
        "correo": email,
        "celular": phone,
        "cedula": cedula,
        'ciudad': ciudad,
        'profession': profession,
        'therapy': therapy,
        'location': location,
        'social': social,
        'perfil': perfil,
        'area': area,
        'educacion': educacion,
        'experiencia': experiencia,
      };
}
