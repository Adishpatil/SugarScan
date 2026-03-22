import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  bool _isHindi = false;
  bool get isHindi => _isHindi;

  void load() {
    final box = Hive.box("history");
    _isHindi = box.get("lang_hindi", defaultValue: false);
  }

  void toggle() {
    _isHindi = !_isHindi;
    Hive.box("history").put("lang_hindi", _isHindi);
    notifyListeners();
  }

  String t(String en, String hi) => _isHindi ? hi : en;
}

class S {
  static final _lang = LanguageService();
  static String get appName         => _lang.t("SugarScan", "?????????");
  static String get tagline         => _lang.t("AI Sugarcane Disease Detection", "AI ????? ??? ?????");
  static String get takePhoto       => _lang.t("Take Photo", "???? ???");
  static String get takePhotoSub    => _lang.t("Use camera to capture leaf", "????? ?? ????? ?? ???? ???");
  static String get chooseGallery   => _lang.t("Choose from Gallery", "????? ?? ?????");
  static String get chooseGallerySub => _lang.t("Select existing leaf image", "?????? ????? ?? ??? ?????");
  static String get totalScans      => _lang.t("Total Scans", "??? ?????");
  static String get diseases        => _lang.t("Diseases", "???");
  static String get healthy         => _lang.t("Healthy", "??????");
  static String get history         => _lang.t("History", "??????");
  static String get diseaseInfo     => _lang.t("Disease Info", "??? ???????");
  static String get home            => _lang.t("Home", "???");
  static String get detectionResult => _lang.t("Detection Result", "????? ??????");
  static String get analyzing       => _lang.t("Analyzing leaf...", "????? ?? ????????...");
  static String get running8passes  => _lang.t("Running 8 TTA passes", "8 TTA ??? ?? ??? ???");
  static String get confidence      => _lang.t("Confidence", "???????");
  static String get allProbs        => _lang.t("All Probabilities", "??? ?????????");
  static String get diseaseInfoTitle => _lang.t("Disease Information", "??? ???????");
  static String get saveHistory     => _lang.t("Save to History", "?????? ??? ??????");
  static String get saved           => _lang.t("Saved!", "?????!");
  static String get noScans         => _lang.t("No scans yet", "??? ??? ????? ????");
  static String get severity        => _lang.t("Severity", "???????");
  static String get description     => _lang.t("Description", "?????");
  static String get cause           => _lang.t("Cause", "????");
  static String get treatment       => _lang.t("Treatment", "?????");
  static String get scanHistory     => _lang.t("Scan History", "????? ??????");
  static String get detectionFailed => _lang.t("Detection failed", "????? ????");
  static String get goBack          => _lang.t("Go Back", "???? ????");
  static String get selectImage     => _lang.t("Select Image Source", "??? ????? ?????");
}
