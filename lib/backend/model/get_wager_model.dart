class GetWagerModel {
  GetWagerModel({
    this.success,
    this.options,
  });

  final bool? success;
  final List<Option>? options;

  factory GetWagerModel.fromJson(Map<String, dynamic> json){
    return GetWagerModel(
      success: json["success"] ?? false,
      options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "options": options!.map((x) => x.toJson()).toList(),
  };

}

class Option {
  Option({
    required this.key,
    required this.text,
    required this.value,
  });

  final String key;
  final String text;
  final num value;

  factory Option.fromJson(Map<String, dynamic> json){
    return Option(
      key: json["key"] ?? "",
      text: json["text"] ?? "",
      value: json["value"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "text": text,
    "value": value,
  };

}
