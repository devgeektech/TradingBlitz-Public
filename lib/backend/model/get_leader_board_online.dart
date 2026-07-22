

class GetLeaderBoardOnlineModel {
  GetLeaderBoardOnlineModel({
    this.success,
    this.message,
    this.count,
    this.next,
    this.previous,
    this.data,
  });

  final bool? success;
  final String? message;
  final num? count;
  final dynamic next;
  final dynamic previous;
  final List<LeaderOnlineBody>? data;

  factory GetLeaderBoardOnlineModel.fromJson(Map<String, dynamic> json){
    return GetLeaderBoardOnlineModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      count: json["count"] ?? 0,
      next: json["next"],
      previous: json["previous"],
      data: json["data"] == null ? [] : List<LeaderOnlineBody>.from(json["data"]!.map((x) => LeaderOnlineBody.fromJson(x))),
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

class LeaderOnlineBody {
  LeaderOnlineBody({
    required this.id,
    required this.rank,
    required this.uuid,
    required this.username,
    required this.email,
    required this.fullName,
    required this.image,
    required this.country,
    required this.userFlag,
    required this.accountBalance,
    required this.challengesPlayed,
    required this.challengesWon,
    required this.winPercentage,
    required this.userTotalGamePlayed,
    required this.disableButtonConditionally,
  });

  final int id;
  final num rank;
  final String uuid;
  final String username;
  final String email;
  final String fullName;
  final dynamic image;
  final String country;
  final String userFlag;
  final num accountBalance;
  final num challengesPlayed;
  final num challengesWon;
  final num winPercentage;
  final num userTotalGamePlayed;
  final bool disableButtonConditionally;

  factory LeaderOnlineBody.fromJson(Map<String, dynamic> json){
    return LeaderOnlineBody(
      id: json["id"] ?? 0,
      rank: json["rank"] ?? 0,
      uuid: json["uuid"] ?? "",
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      fullName: json["full_name"] ?? "",
      image: json["image"],
      country: json["country"] ?? "",
      userFlag: json["user_flag"] ?? "",
      accountBalance: json["account_balance"] ?? 0,
      challengesPlayed: json["challenges_played"] ?? 0,
      challengesWon: json["challenges_won"] ?? 0,
      winPercentage: json["win_percentage"] ?? 0,
      userTotalGamePlayed: json["user_total_game_played"] ?? 0,
      disableButtonConditionally: json["disable_button_conditionally"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "rank": rank,
    "uuid": uuid,
    "username": username,
    "email": email,
    "full_name": fullName,
    "image": image,
    "country": country,
    "user_flag": userFlag,
    "account_balance": accountBalance,
    "challenges_played": challengesPlayed,
    "challenges_won": challengesWon,
    "win_percentage": winPercentage,
    "user_total_game_played": userTotalGamePlayed,
    "disable_button_conditionally": disableButtonConditionally,
  };

}
