

class GetStatModel {
  GetStatModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory GetStatModel.fromJson(Map<String, dynamic> json){
    return GetStatModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };

}

class Data {
  Data({
    required this.rank,
    required this.chartsPlayed,
    required this.accountBalance,
    required this.totalProfitLoss,
    required this.winPercentage,
    required this.averageHoldTimeDays,
  });

  final num rank;
  final num chartsPlayed;
  final num accountBalance;
  final num totalProfitLoss;
  final num winPercentage;
  final int averageHoldTimeDays;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      rank: json["rank"] ?? 0,
      chartsPlayed: json["charts_played"] ?? 0,
      accountBalance: json["account_balance"] ?? 0,
      totalProfitLoss: json["total_profit_loss"] ?? 0,
      winPercentage: json["win_percentage"] ?? 0,
      averageHoldTimeDays: json["average_hold_time_days"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "rank": rank,
    "charts_played": chartsPlayed,
    "account_balance": accountBalance,
    "total_profit_loss": totalProfitLoss,
    "win_percentage": winPercentage,
    "average_hold_time_days": averageHoldTimeDays,
  };

}
