


class GetLeaderBoardModel {
  GetLeaderBoardModel({
    this.success,
    this.message,
    this.count,
    this.next,
    this.previous,
    this.data,
  });

  final bool? success;
  final String ?message;
  final num? count;
  final dynamic next;
  final dynamic previous;
  final List<LeaderBody>? data;

  factory GetLeaderBoardModel.fromJson(Map<String, dynamic> json){
    return GetLeaderBoardModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      count: json["count"] ?? 0,
      next: json["next"],
      previous: json["previous"],
      data: json["data"] == null ? [] : List<LeaderBody>.from(json["data"]!.map((x) => LeaderBody.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "count": count,
    "next": next,
    "previous": previous,
    "data": data?.map((x) => x.toJson()).toList(),
  };

}

class LeaderBody {
  LeaderBody({
    required this.id,
    required this.uuid,
    required this.username,
    required this.email,
    required this.fullName,
    required this.country,
    required this.image,
    required this.userFlag,
    required this.accountBalance,
    required this.rank,
    required this.userTotalGamePlayed,
    required this.isOnline,
    required this.disableButtonConditionally,
  });

  final int id;
  final String uuid;
  final String username;
  final String email;
  final String fullName;
  final String country;
  final dynamic image;
  final String userFlag;
  final num accountBalance;
  final num rank;
  final num userTotalGamePlayed;
  final bool isOnline;
  final bool disableButtonConditionally;

  factory LeaderBody.fromJson(Map<String, dynamic> json){
    return LeaderBody(
      id: json["id"] ?? 0,
      uuid: json["uuid"] ?? "",
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      fullName: json["full_name"] ?? "",
      country: json["country"] ?? "",
      image: json["image"],
      userFlag: json["user_flag"] ?? "",
      accountBalance: json["account_balance"] ?? 0,
      rank: json["rank"] ?? 0,
      userTotalGamePlayed: json["user_total_game_played"] ?? 0,
      isOnline: json["is_online"] ?? false,
      disableButtonConditionally: json["disable_button_conditionally"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "username": username,
    "email": email,
    "full_name": fullName,
    "country": country,
    "image": image,
    "user_flag": userFlag,
    "account_balance": accountBalance,
    "rank": rank,
    "user_total_game_played": userTotalGamePlayed,
    "is_online": isOnline,
    "disable_button_conditionally": disableButtonConditionally,
  };

}
