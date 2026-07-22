import 'dart:convert';

LoginDataModel loginDataModelFromJson(Map<String, dynamic> json) {
  return LoginDataModel.fromJson(json);
}

String loginDataModelToJson(LoginDataModel data) => json.encode(data.toJson());

class LoginDataModel {
  LoginDataModel({
    required this.user,
    required this.token,
    required this.message,
  });

  final User? user;
  final String? token;
  final String? message;

  factory LoginDataModel.fromJson(Map<String, dynamic> json){
    return LoginDataModel(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      token: json["token"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
    "message": message,
  };

}

class User {
  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.avatar,
    required this.type,
    required this.profileUrl,
    required this.location,
    required this.bio,
    required this.timezone,
    required this.personalityType,
    required this.lastVisited,
    required this.iban,
    required this.socialLinks,
    required this.notificationsSettings,
    required this.joinedAt,
    required this.memberSince,
    required this.groups,
    required this.notifications,
    required this.activitiesSvg,
    required this.participations,
    required this.membershipCommmon,
    required this.referralCode,
    required this.referredBy,
    required this.subscription,
    required this.memberType,
    required this.totalCommission,
    required this.verifiedStatus,
  });

  final int? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? avatar;
  final String? type;
  final String? profileUrl;
  final dynamic location;
  final dynamic bio;
  final String? timezone;
  final dynamic personalityType;
  final DateTime? lastVisited;
  final dynamic iban;
  final List<dynamic> socialLinks;
  final List<dynamic> notificationsSettings;
  final DateTime? joinedAt;
  final String? memberSince;
  final List<Group> groups;
  final int? notifications;
  final String? activitiesSvg;
  final List<Participation> participations;
  final dynamic membershipCommmon;
  final String? referralCode;
  final dynamic referredBy;
  final bool? subscription;
  final String? memberType;
  final int? totalCommission;
  final String? verifiedStatus;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      email: json["email"],
      avatar: json["avatar"],
      type: json["type"],
      profileUrl: json["profileUrl"],
      location: json["location"],
      bio: json["bio"],
      timezone: json["timezone"],
      personalityType: json["personalityType"],
      lastVisited: DateTime.tryParse(json["last_visited"] ?? ""),
      iban: json["iban"],
      socialLinks: json["socialLinks"] == null ? [] : List<dynamic>.from(json["socialLinks"]!.map((x) => x)),
      notificationsSettings: json["notificationsSettings"] == null ? [] : List<dynamic>.from(json["notificationsSettings"]!.map((x) => x)),
      joinedAt: DateTime.tryParse(json["joinedAt"] ?? ""),
      memberSince: json["memberSince"],
      groups: json["groups"] == null ? [] : List<Group>.from(json["groups"]!.map((x) => Group.fromJson(x))),
      notifications: json["notifications"],
      activitiesSvg: json["activitiesSVG"],
      participations: json["participations"] == null ? [] : List<Participation>.from(json["participations"]!.map((x) => Participation.fromJson(x))),
      membershipCommmon: json["membership_commmon"],
      referralCode: json["referral_code"],
      referredBy: json["referred_by"],
      subscription: json["subscription"],
      memberType: json["member_type"],
      totalCommission: json["totalCommission"],
      verifiedStatus: json["verified_status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "avatar": avatar,
    "type": type,
    "profileUrl": profileUrl,
    "location": location,
    "bio": bio,
    "timezone": timezone,
    "personalityType": personalityType,
    "last_visited": lastVisited?.toIso8601String(),
    "iban": iban,
    "socialLinks": socialLinks.map((x) => x).toList(),
    "notificationsSettings": notificationsSettings.map((x) => x).toList(),
    "joinedAt": joinedAt?.toIso8601String(),
    "memberSince": memberSince,
    "groups": groups.map((x) => x.toJson()).toList(),
    "notifications": notifications,
    "activitiesSVG": activitiesSvg,
    "participations": participations.map((x) => x.toJson()).toList(),
    "membership_commmon": membershipCommmon,
    "referral_code": referralCode,
    "referred_by": referredBy,
    "subscription": subscription,
    "member_type": memberType,
    "totalCommission": totalCommission,
    "verified_status": verifiedStatus,
  };

}

class Group {
  Group({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.icon,
    required this.cover,
    required this.groupUrl,
    required this.showOwner,
    required this.memberCanInvite,
    required this.description,
    required this.iconSlug,
    required this.backroundColor,
    required this.type,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.free,
    required this.amount,
    required this.banner,
    required this.showBanner,
    required this.image,
    required this.video,
    required this.fullDescription,
    required this.displayVideo,
    required this.categoryId,
    required this.affiliationStatus,
    required this.affiliationPercent,
    required this.verificationStatus,
    required this.backgroundColor,
    required this.language,
  });

  final int? id;
  final int? ownerId;
  final String? name;
  final String? icon;
  final String? cover;
  final String? groupUrl;
  final int? showOwner;
  final int? memberCanInvite;
  final String? description;
  final String? iconSlug;
  final String? backroundColor;
  final String? type;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? free;
  final String? amount;
  final String? banner;
  final int? showBanner;
  final String? image;
  final String? video;
  final String? fullDescription;
  final int? displayVideo;
  final String? categoryId;
  final String? affiliationStatus;
  final String? affiliationPercent;
  final String? verificationStatus;
  final dynamic backgroundColor;
  final String? language;

  factory Group.fromJson(Map<String, dynamic> json){
    return Group(
      id: json["id"],
      ownerId: json["owner_id"],
      name: json["name"],
      icon: json["icon"],
      cover: json["cover"],
      groupUrl: json["group_url"],
      showOwner: json["show_owner"],
      memberCanInvite: json["member_can_invite"],
      description: json["description"],
      iconSlug: json["icon_slug"],
      backroundColor: json["backround_color"],
      type: json["type"],
      deletedAt: json["deleted_at"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      free: json["free"],
      amount: json["amount"],
      banner: json["banner"],
      showBanner: json["show_banner"],
      image: json["image"],
      video: json["video"],
      fullDescription: json["full_description"],
      displayVideo: json["display_video"],
      categoryId: json["category_id"],
      affiliationStatus: json["affiliation_status"],
      affiliationPercent: json["affiliation_percent"],
      verificationStatus: json["verification_status"],
      backgroundColor: json["background_color"],
      language: json["language"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_id": ownerId,
    "name": name,
    "icon": icon,
    "cover": cover,
    "group_url": groupUrl,
    "show_owner": showOwner,
    "member_can_invite": memberCanInvite,
    "description": description,
    "icon_slug": iconSlug,
    "backround_color": backroundColor,
    "type": type,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "free": free,
    "amount": amount,
    "banner": banner,
    "show_banner": showBanner,
    "image": image,
    "video": video,
    "full_description": fullDescription,
    "display_video": displayVideo,
    "category_id": categoryId,
    "affiliation_status": affiliationStatus,
    "affiliation_percent": affiliationPercent,
    "verification_status": verificationStatus,
    "background_color": backgroundColor,
    "language": language,
  };

}

class Participation {
  Participation({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.points,
    required this.level,
    required this.type,
    required this.amount,
    required this.status,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.paidType,
    required this.readStatus,
    required this.dmStatus,
  });

  final int? id;
  final int? userId;
  final int? groupId;
  final int? points;
  final int? level;
  final String? type;
  final dynamic amount;
  final String? status;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? paidType;
  final String? readStatus;
  final int? dmStatus;

  factory Participation.fromJson(Map<String, dynamic> json){
    return Participation(
      id: json["id"],
      userId: json["user_id"],
      groupId: json["group_id"],
      points: json["points"],
      level: json["level"],
      type: json["type"],
      amount: json["amount"],
      status: json["status"],
      deletedAt: json["deleted_at"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      paidType: json["paid_type"],
      readStatus: json["read_status"],
      dmStatus: json["dm_status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "group_id": groupId,
    "points": points,
    "level": level,
    "type": type,
    "amount": amount,
    "status": status,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "paid_type": paidType,
    "read_status": readStatus,
    "dm_status": dmStatus,
  };

}
