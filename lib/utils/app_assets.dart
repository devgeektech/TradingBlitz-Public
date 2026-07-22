class AssetPath {
  static const String _iconBasePath = "assets/icons/";
  static const String _imagesBasePath = "assets/images/";

  static String _iconPath(String fileName) => _iconBasePath + fileName;
  static String _imagesPath(String fileName) => _imagesBasePath + fileName;

  ///Icons
  static final googleLogo = _iconPath("google_logo.svg");
  static final fbLogo = _iconPath("fb_logo.svg");
  static final linkedInLogo = _iconPath("linkedIn_logo.svg");
  static final appleLogo = _iconPath("apple_logo.svg");
  static final logoWithName = _iconPath("logo_name.svg");
  static final iconEdit = _iconPath("IconEdit.svg");
  static final accountSettingDark = _iconPath("accountSetting.svg");
  static final accountSettingLight = _iconPath("manageAccountsLight.svg");
  static final exploreMoreDark = _iconPath("exploreMore.svg");
  static final exploreMoreLight = _iconPath("exploreMoreLight.svg");
  static final notificationsDark = _iconPath("notificationsDark.svg");
  static final notificationsLight = _iconPath("notifications.svg");
  static final solo = _iconPath("solo.svg");
  static final challenges = _iconPath("challenges.svg");
  static final stats = _iconPath("stats.svg");
  static final leaders = _iconPath("leaders.svg");
  static final settings = _iconPath("settings.svg");
  static final arrowBack = _iconPath("arrow_back.svg");
  static final logout = _iconPath("logout.svg");

  ///Images
  static final logo = _imagesPath("logo.png");
  static final loginBg = _imagesPath("login_bg.png");
  static final leadersBg = _imagesPath("leadersBg.png");


}
