class Employee {
  int id;
  String? code;
  String firstName;
  String lastName;
  String name;
  String? title;
  String? dateOfBirth;
  String gender;
  String? position;
  String? department;
  String? email;
  String? phone;
  int? isActive;
  String? profilePhoto;

  Employee({
    required this.id,
    this.code,
    required this.firstName,
    required this.lastName,
    required this.name,
    this.title,
    this.dateOfBirth,
    required this.gender,
    this.position,
    this.department,
    this.email,
    this.phone,
    this.profilePhoto,
    this.isActive
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        id: json['id'],
        code: json['code'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        name: json['name'],
        title: json['title'],
        dateOfBirth: json['dateOfBirth'],
        gender: json['gender'],
        department: json['department']?['name'],
        position: json['position']?['position'],
        email: json['email'],
        phone: json['phone'],
        profilePhoto: json['profilePhoto'],
        isActive: json['isActive']
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'code': code,
      'firstName': firstName,
      'lastName': lastName,
      'name': name,
      'title': title,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'position': position,
      'department': department,
      'email': email,
      'phone': phone,
      'isActive': isActive
    };
    return map;
  }

}