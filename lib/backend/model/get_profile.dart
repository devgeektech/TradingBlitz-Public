

class GetProfileModel {
  GetProfileModel._privateConstructor();

  static final GetProfileModel _instance = GetProfileModel._privateConstructor();

  factory GetProfileModel() => _instance;

  bool success = false;
  String message = '';
  User? user;

  void fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    message = json["message"] ?? "";
    user = json["user"] == null ? null : User.fromJson(json["user"]);
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "user": user?.toJson(),
  };
}

class User {
  User({
    required this.id,
    required this.uuid,
    required this.username,
    required this.email,
    required this.fullName,
    required this.dob,
    required this.gender,
    required this.address,
    required this.phone,
    required this.picture,
    required this.deviceType,
    required this.fcmToken,
    required this.countryName,
    required this.countryFlag,
  });

  final int id;
  final String uuid;
  final String username;
  final String email;
  final String fullName;
  final DateTime? dob;
  final String gender;
  final String address;
  final String phone;
  final String picture;
  final String deviceType;
  final String fcmToken;
  final String countryName;
  final String countryFlag;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"] ?? 0,
      uuid: json["uuid"] ?? "",
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      fullName: json["full_name"] ?? "",
      dob: DateTime.tryParse(json["dob"] ?? ""),
      gender: json["gender"] ?? "",
      address: json["address"] ?? "",
      phone: json["phone"] ?? "",
      picture: json["picture"] ?? "",
      deviceType: json["device_type"] ?? "",
      fcmToken: json["fcm_token"] ?? "",
      countryName: json["country_name"] ?? "",
      countryFlag: json["country_flag"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "username": username,
    "email": email,
    "full_name": fullName,
    "dob": dob?.toIso8601String(),
    "gender": gender,
    "address": address,
    "phone": phone,
    "picture": picture,
    "device_type": deviceType,
    "fcm_token": fcmToken,
    "country_name": countryName,
    "country_flag": countryFlag,
  };

}

