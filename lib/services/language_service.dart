import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";

/// Tri-language service: English, Hindi, Marathi
/// Singleton with ChangeNotifier for reactive UI updates.
class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  // 'en' | 'hi' | 'mr'
  String _langCode = 'en';
  String get langCode => _langCode;
  bool get isEnglish => _langCode == 'en';
  bool get isHindi => _langCode == 'hi';
  bool get isMarathi => _langCode == 'mr';

  static const List<String> supportedCodes = ['en', 'hi', 'mr'];
  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिन्दी',
    'mr': 'मराठी',
  };

  void load() {
    final box = Hive.box("history");
    _langCode = box.get("lang_code", defaultValue: "en");
    if (!supportedCodes.contains(_langCode)) _langCode = 'en';
  }

  void setLanguage(String code) {
    if (!supportedCodes.contains(code)) return;
    _langCode = code;
    Hive.box("history").put("lang_code", code);
    notifyListeners();
  }

  /// Cycle: en → hi → mr → en
  void toggle() {
    final idx = supportedCodes.indexOf(_langCode);
    setLanguage(supportedCodes[(idx + 1) % supportedCodes.length]);
  }

  /// Translate with 3 languages
  String t3(String en, String hi, String mr) {
    switch (_langCode) {
      case 'hi':
        return hi;
      case 'mr':
        return mr;
      default:
        return en;
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  S — Static string accessor (convenience wrapper)
// ─────────────────────────────────────────────────────────────
class S {
  static final _l = LanguageService();

  // ── App chrome ──
  static String get appName =>
      _l.t3("SugarScan", "शुगरस्कैन", "शुगरस्कॅन");
  static String get tagline => _l.t3(
      "AI Sugarcane Disease Detection",
      "AI ऊसाच्या रोग ओळख",
      "AI ऊस रोग ओळख");
  static String get versionLabel =>
      _l.t3("Version 2.0", "संस्करण 2.0", "आवृत्ती 2.0");

  // ── Navigation ──
  static String get home => _l.t3("Home", "होम", "होम");
  static String get history => _l.t3("History", "इतिहास", "इतिहास");
  static String get journal => _l.t3("My Farm", "मेरा खेत", "माझं शेत");
  static String get guide => _l.t3("Learn", "जानकारी", "माहिती");

  // ── Home tab ──
  static String get selectImage =>
      _l.t3("Scan Your Crop", "अपनी फसल स्कैन करें", "तुमचं पीक स्कॅन करा");
  static String get takePhoto =>
      _l.t3("Take Photo", "फोटो खींचें", "फोटो काढा");
  static String get takePhotoSub => _l.t3(
      "Point camera at the sugarcane leaf",
      "कैमरा ऊस की पत्ती पर लगाएं",
      "कॅमेरा ऊसाच्या पानावर लावा");
  static String get chooseGallery =>
      _l.t3("Choose from Gallery", "गैलरी से चुनें", "गॅलरीतून निवडा");
  static String get chooseGallerySub => _l.t3(
      "Pick an existing leaf photo",
      "पहले से खींचा हुआ फोटो चुनें",
      "आधीचा फोटो निवडा");
  static String get totalScans =>
      _l.t3("Total Scans", "कुल स्कैन", "एकूण स्कॅन");
  static String get diseases =>
      _l.t3("Diseased", "रोगी", "रोगग्रस्त");
  static String get healthy =>
      _l.t3("Healthy", "स्वस्थ", "निरोगी");
  static String get quickTips =>
      _l.t3("Quick Tips", "जल्दी टिप्स", "झटपट टिप्स");
  static String get currentRisk =>
      _l.t3("Current Risk", "अभी का खतरा", "सध्याचा धोका");

  // ── Result screen ──
  static String get detectionResult =>
      _l.t3("Detection Result", "पहचान परिणाम", "ओळख निकाल");
  static String get analyzing =>
      _l.t3("Analyzing your leaf...", "पत्ती की जाँच हो रही है...", "पानाची तपासणी होत आहे...");
  static String get running8passes => _l.t3(
      "Running 8 augmentation passes for accuracy",
      "सटीकता के लिए 8 ऑगमेंटेशन पास चल रहे हैं",
      "अचूकतेसाठी 8 ऑगमेंटेशन पास चालू आहेत");
  static String get confidence =>
      _l.t3("Confidence", "विश्वसनीयता", "विश्वासार्हता");
  static String get allProbs =>
      _l.t3("All Probabilities", "सभी संभावनाएं", "सर्व शक्यता");
  static String get diseaseInfoTitle =>
      _l.t3("Disease Information", "रोग की जानकारी", "रोगाची माहिती");
  static String get saveHistory =>
      _l.t3("Save to History", "इतिहास में सहेजें", "इतिहासात जतन करा");
  static String get saved => _l.t3("Saved!", "सहेजा गया!", "जतन केले!");
  static String get severity =>
      _l.t3("Severity", "गंभीरता", "तीव्रता");
  static String get description =>
      _l.t3("What it looks like", "कैसा दिखता है", "कसे दिसते");
  static String get cause =>
      _l.t3("What causes it", "इसका कारण", "याचे कारण");
  static String get treatment =>
      _l.t3("What to do", "क्या करें", "काय करावे");
  static String get symptoms =>
      _l.t3("Symptoms", "लक्षण", "लक्षणे");
  static String get prevention =>
      _l.t3("Prevention", "रोकथाम", "प्रतिबंध");
  static String get fieldTips =>
      _l.t3("Farmer Tips", "किसान टिप्स", "शेतकरी टिप्स");
  static String get detectionFailed =>
      _l.t3("Detection Failed", "पहचान असफल", "ओळख अयशस्वी");
  static String get goBack => _l.t3("Go Back", "वापस जाएं", "मागे जा");
  static String get shareResult =>
      _l.t3("Share Result", "परिणाम शेयर करें", "निकाल शेअर करा");

  // ── History tab ──
  static String get scanHistory =>
      _l.t3("Scan History", "स्कैन इतिहास", "स्कॅन इतिहास");
  static String get noScans =>
      _l.t3("No scans yet — try scanning a leaf!", "अभी तक कोई स्कैन नहीं — एक पत्ती स्कैन करें!", "अजून स्कॅन नाही — एक पान स्कॅन करा!");
  static String get clearAll =>
      _l.t3("Clear All", "सब हटाएं", "सर्व काढा");
  static String get confirmClear => _l.t3(
      "This will delete all scan history. Continue?",
      "सारा इतिहास मिटेगा। जारी रखें?",
      "सर्व इतिहास निघून जाईल. पुढे चालू?");

  // ── Disease info / guide ──
  static String get diseaseInfo =>
      _l.t3("Disease Guide", "रोग गाइड", "रोग मार्गदर्शक");
  static String get seasonalRisk =>
      _l.t3("Seasonal Calendar", "मौसमी कैलेंडर", "हंगामी दिनदर्शिका");
  static String get language =>
      _l.t3("Language", "भाषा", "भाषा");

  // ── Risk alerts ──
  static String get riskAlerts =>
      _l.t3("Risk Alerts", "खतरे की चेतावनी", "धोक्याचे इशारे");
  static String get lowRisk => _l.t3("Low", "कम", "कमी");
  static String get mediumRisk => _l.t3("Medium", "मध्यम", "मध्यम");
  static String get highRisk => _l.t3("High", "अधिक", "जास्त");
  static String get criticalRisk => _l.t3("Critical", "गंभीर", "गंभीर");
  static String get monthlyTips =>
      _l.t3("This Month's Tips", "इस महीने की टिप्स", "या महिन्याच्या टिप्स");
  static String get preventiveActions =>
      _l.t3("Preventive Actions", "रोकथाम कदम", "प्रतिबंधात्मक कृती");

  // ── Farm journal ──
  static String get farmJournal =>
      _l.t3("Farm Journal", "खेत डायरी", "शेत डायरी");
  static String get addEntry =>
      _l.t3("Add Entry", "नोट जोड़ें", "नोंद जोडा");
  static String get fieldName =>
      _l.t3("Field Name", "खेत का नाम", "शेताचे नाव");
  static String get cropStage =>
      _l.t3("Crop Stage", "फसल चरण", "पिकाचा टप्पा");
  static String get observations =>
      _l.t3("Observations", "नोट्स", "निरीक्षण");
  static String get scanTrends =>
      _l.t3("Scan Trends", "स्कैन ट्रेंड", "स्कॅन ट्रेंड");
  static String get healthOverview =>
      _l.t3("Health Overview", "स्वास्थ्य सारांश", "आरोग्य सारांश");
  static String get exportSummary =>
      _l.t3("Share via WhatsApp", "WhatsApp से शेयर", "WhatsApp वर शेअर");
  static String get noFieldsYet => _l.t3(
      "No fields added yet. Tap '+' to start tracking!",
      "अभी कोई खेत नहीं जोड़ा। '+' दबाकर शुरू करें!",
      "अजून शेत जोडलेले नाही. '+' वर टॅप करा!");

  // ── Crop stages ──
  static String get stagePlanting =>
      _l.t3("Planting", "बुवाई", "लागवड");
  static String get stageTillering =>
      _l.t3("Tillering", "कल्ले फूटना", "फुटवे");
  static String get stageGrandGrowth =>
      _l.t3("Grand Growth", "तीव्र बढ़ोतरी", "मोठी वाढ");
  static String get stageMaturity =>
      _l.t3("Maturity", "पकना", "परिपक्वता");

  // ── Drawer ──
  static String get aboutApp => _l.t3(
      "About SugarScan",
      "SugarScan के बारे में",
      "SugarScan बद्दल");
  static String get aboutDescription => _l.t3(
      "SugarScan uses AI to detect diseases in sugarcane leaves. Simply take a photo of the leaf and get instant diagnosis with treatment recommendations.",
      "SugarScan AI का उपयोग करके ऊस की पत्तियों में रोग का पता लगाता है। बस पत्ती की फोटो खींचें और उपचार सिफारिशों के साथ तुरंत निदान पाएं।",
      "SugarScan AI वापरून ऊसाच्या पानांमधील रोग शोधतो. फक्त पानाचा फोटो काढा आणि उपचार शिफारसींसह त्वरित निदान मिळवा.");
  static String get madeWithLove => _l.t3(
      "Made with ❤️ for Indian Farmers",
      "भारतीय किसानों के लिए ❤️ से बनाया",
      "भारतीय शेतकऱ्यांसाठी ❤️ ने बनवले");

  // ── General ──
  static String get cancel => _l.t3("Cancel", "रद्द", "रद्द");
  static String get save => _l.t3("Save", "सहेजें", "जतन");
  static String get delete => _l.t3("Delete", "हटाएं", "काढा");
  static String get yes => _l.t3("Yes", "हाँ", "होय");
  static String get no => _l.t3("No", "नहीं", "नाही");
  static String get ok => _l.t3("OK", "ठीक", "ठीक");
  static String get about => _l.t3("About", "जानकारी", "माहिती");
  static String get settings => _l.t3("Settings", "सेटिंग्स", "सेटिंग्ज");
}
