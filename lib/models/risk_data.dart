import '../services/language_service.dart';

/// Seasonal risk levels for each disease per month.
/// Based on Indian sugarcane growing patterns (Maharashtra / UP / Karnataka).
///
/// Risk levels: 0 = Low, 1 = Medium, 2 = High, 3 = Critical

class MonthlyRisk {
  final int month; // 1-12
  final Map<String, int> diseaseRisk; // diseaseName -> 0,1,2,3
  final Map<String, String> tips; // en/hi/mr

  const MonthlyRisk({
    required this.month,
    required this.diseaseRisk,
    required this.tips,
  });

  String get localTip => tips[LanguageService().langCode] ?? tips['en']!;
}

class PreventiveAction {
  final Map<String, String> action;
  final Map<String, String> timing;
  final String icon;

  const PreventiveAction({
    required this.action,
    required this.timing,
    required this.icon,
  });

  String get localAction => action[LanguageService().langCode] ?? action['en']!;
  String get localTiming => timing[LanguageService().langCode] ?? timing['en']!;
}

// ─────────────────────────────────────────────────────────────────
//  Monthly Risk Matrix
// ─────────────────────────────────────────────────────────────────

String riskLabel(int level) {
  final l = LanguageService();
  switch (level) {
    case 0:  return l.t3('Low', 'कम', 'कमी');
    case 1:  return l.t3('Medium', 'मध्यम', 'मध्यम');
    case 2:  return l.t3('High', 'अधिक', 'जास्त');
    case 3:  return l.t3('Critical', 'गंभीर', 'गंभीर');
    default: return l.t3('Unknown', 'अज्ञात', 'अज्ञात');
  }
}

const List<MonthlyRisk> monthlyRiskData = [
  // January — Winter, harvest season
  MonthlyRisk(month: 1, diseaseRisk: {
    'Mosaic': 0, 'Rust': 0, 'RedRot': 1, 'Yellow': 1,
  }, tips: {
    'en': 'Harvest season. Inspect stalks for Red Rot before sending to mill. '
        'Select healthy seed cane for next planting.',
    'hi': 'कटाई का मौसम। मिल भेजने से पहले डंठलों में लाल सड़न जाँचें। '
        'अगली बुवाई के लिए स्वस्थ बीज ऊस चुनें।',
    'mr': 'कापणीचा हंगाम. कारखान्यात पाठवण्यापूर्वी लाल कूज तपासा. '
        'पुढच्या लागवडीसाठी निरोगी बेणे निवडा.',
  }),

  // February — Late winter, planting begins
  MonthlyRisk(month: 2, diseaseRisk: {
    'Mosaic': 0, 'Rust': 0, 'RedRot': 1, 'Yellow': 0,
  }, tips: {
    'en': 'Planting season starting. Hot water treat all seed cane at 50°C for 2 hours. '
        'Ensure disease-free planting material.',
    'hi': 'बुवाई शुरू हो रही है। सभी बीज ऊस को 50°C पर 2 घंटे गर्म पानी उपचार करें। '
        'रोगमुक्त बीज सामग्री सुनिश्चित करें।',
    'mr': 'लागवडीचा हंगाम सुरू होतोय. सर्व बेणे 50°C वर 2 तास गरम पाण्यात उपचार करा. '
        'रोगमुक्त लागवड सामग्री सुनिश्चित करा.',
  }),

  // March — Spring planting
  MonthlyRisk(month: 3, diseaseRisk: {
    'Mosaic': 1, 'Rust': 0, 'RedRot': 0, 'Yellow': 0,
  }, tips: {
    'en': 'Peak planting time. Monitor new shoots for any yellowing or mosaic patterns. '
        'Apply balanced NPK fertilizer.',
    'hi': 'बुवाई का चरम समय। नई कोंपलों में पीलापन या मोज़ेक पैटर्न पर नज़र रखें। '
        'संतुलित NPK खाद दें।',
    'mr': 'लागवडीचा उत्तम काळ. नवीन फुटव्यांमध्ये पिवळेपणा किंवा मोझॅक नमुने तपासा. '
        'संतुलित NPK खत द्या.',
  }),

  // April — Early summer, tillering
  MonthlyRisk(month: 4, diseaseRisk: {
    'Mosaic': 1, 'Rust': 0, 'RedRot': 0, 'Yellow': 1,
  }, tips: {
    'en': 'Tillering phase. Good time to rogue out any plants showing Mosaic symptoms. '
        'Ensure proper irrigation schedule.',
    'hi': 'कल्ले फूटने का चरण। मोज़ेक दिखने वाले पौधे निकालने का अच्छा समय। '
        'उचित सिंचाई शेड्यूल सुनिश्चित करें।',
    'mr': 'फुटवे फुटण्याचा टप्पा. मोझॅक लक्षणे दिसणारी पिके काढण्याची योग्य वेळ. '
        'योग्य सिंचन वेळापत्रक ठेवा.',
  }),

  // May — Hot summer
  MonthlyRisk(month: 5, diseaseRisk: {
    'Mosaic': 1, 'Rust': 0, 'RedRot': 0, 'Yellow': 1,
  }, tips: {
    'en': 'High heat. Ensure adequate irrigation. Aphid activity may increase — '
        'scout for aphids on leaf undersides.',
    'hi': 'तेज गर्मी। पर्याप्त सिंचाई दें। माहू गतिविधि बढ़ सकती है — '
        'पत्तियों के नीचे माहू की जाँच करें।',
    'mr': 'कडक उन्हाळा. पुरेसे सिंचन द्या. मावा वाढू शकतो — '
        'पानांच्या खालच्या बाजूला मावा तपासा.',
  }),

  // June — Monsoon onset
  MonthlyRisk(month: 6, diseaseRisk: {
    'Mosaic': 1, 'Rust': 1, 'RedRot': 1, 'Yellow': 1,
  }, tips: {
    'en': 'Monsoon starting. Watch for waterlogging — clear drainage channels. '
        'Humidity rising means Rust risk is increasing.',
    'hi': 'बारिश शुरू हो रही है। जलभराव पर ध्यान दें — नालियाँ साफ करें। '
        'नमी बढ़ रही है मतलब रतुआ का खतरा बढ़ रहा है।',
    'mr': 'पावसाळा सुरू होतोय. पाणी साचणार नाही याची काळजी घ्या — चर स्वच्छ करा. '
        'आर्द्रता वाढत आहे म्हणजे गंज धोका वाढतोय.',
  }),

  // July — Peak monsoon
  MonthlyRisk(month: 7, diseaseRisk: {
    'Mosaic': 1, 'Rust': 2, 'RedRot': 2, 'Yellow': 1,
  }, tips: {
    'en': 'Peak moisture. Spray Mancozeb preventively for Rust. '
        'Check drains daily. Grand growth phase — crop needs care.',
    'hi': 'अधिकतम नमी। रतुआ के लिए मैंकोज़ेब का बचाव छिड़काव करें। '
        'नालियाँ रोज़ जाँचें। तीव्र बढ़ोतरी चरण — फसल को देखभाल चाहिए।',
    'mr': 'सर्वाधिक ओलावा. गंजासाठी मॅन्कोझेब प्रतिबंधक फवारणी करा. '
        'चर रोज तपासा. मोठ्या वाढीचा टप्पा — पिकाला काळजी हवी.',
  }),

  // August — Heavy rains
  MonthlyRisk(month: 8, diseaseRisk: {
    'Mosaic': 1, 'Rust': 3, 'RedRot': 3, 'Yellow': 1,
  }, tips: {
    'en': 'CRITICAL month for fungal diseases. Do NOT skip Rust spraying. '
        'Watch for Red Rot symptoms — sour smell from stalks is a danger sign.',
    'hi': 'कवक रोगों के लिए गंभीर महीना। रतुआ छिड़काव न छोड़ें। '
        'लाल सड़न के लक्षण देखें — डंठल से खट्टी गंध खतरे का संकेत है।',
    'mr': 'बुरशी रोगांसाठी गंभीर महिना. गंज फवारणी सोडू नका. '
        'लाल कूज लक्षणे तपासा — कांड्यातून आंबट वास धोक्याचे चिन्ह.',
  }),

  // September — Late monsoon
  MonthlyRisk(month: 9, diseaseRisk: {
    'Mosaic': 1, 'Rust': 2, 'RedRot': 2, 'Yellow': 2,
  }, tips: {
    'en': 'Yellow Leaf Disease risk increasing with aphid migration. '
        'Spray Imidacloprid for aphid control. Continue Rust monitoring.',
    'hi': 'माहू प्रवास के साथ पीली पत्ती रोग का खतरा बढ़ रहा है। '
        'माहू नियंत्रण के लिए इमिडाक्लोप्रिड छिड़कें। रतुआ निगरानी जारी रखें।',
    'mr': 'मावा स्थलांतरासह पिवळ्या पानाचा रोग धोका वाढतोय. '
        'मावा नियंत्रणासाठी इमिडाक्लोप्रिड फवारा. गंज निरीक्षण चालू ठेवा.',
  }),

  // October — Post monsoon
  MonthlyRisk(month: 10, diseaseRisk: {
    'Mosaic': 0, 'Rust': 1, 'RedRot': 1, 'Yellow': 2,
  }, tips: {
    'en': 'Aphid peak season. Monitor closely for Yellow Leaf. '
        'Crop approaching maturity — reduce nitrogen.',
    'hi': 'माहू का चरम मौसम। पीली पत्ती पर बारीकी से नज़र रखें। '
        'फसल पकने के करीब — नाइट्रोजन कम करें।',
    'mr': 'मावा उत्कर्ष हंगाम. पिवळ्या पानावर बारकाईने लक्ष ठेवा. '
        'पीक परिपक्वतेजवळ — नायट्रोजन कमी करा.',
  }),

  // November — Early winter
  MonthlyRisk(month: 11, diseaseRisk: {
    'Mosaic': 0, 'Rust': 0, 'RedRot': 1, 'Yellow': 1,
  }, tips: {
    'en': 'Pre-harvest inspection. Check random stalks for internal Red Rot. '
        'Plan next season\'s seed selection from healthy plots.',
    'hi': 'कटाई पूर्व निरीक्षण। कुछ डंठलों को चीरकर लाल सड़न जाँचें। '
        'अगले सीज़न के लिए स्वस्थ खेत से बीज चयन की योजना बनाएं।',
    'mr': 'कापणीपूर्व तपासणी. काही कांडे फोडून लाल कूज तपासा. '
        'पुढच्या हंगामासाठी निरोगी शेतातून बेणे निवडीची योजना करा.',
  }),

  // December — Winter, harvest
  MonthlyRisk(month: 12, diseaseRisk: {
    'Mosaic': 0, 'Rust': 0, 'RedRot': 1, 'Yellow': 0,
  }, tips: {
    'en': 'Harvest and planning time. Remove all crop debris from fields. '
        'Schedule hot water treatment for seed cane. Book certified seed early.',
    'hi': 'कटाई और योजना का समय। खेत से सभी फसल अवशेष हटाएं। '
        'बीज ऊस के गर्म पानी उपचार की योजना बनाएं। प्रमाणित बीज जल्दी बुक करें।',
    'mr': 'कापणी आणि नियोजनाची वेळ. शेतातून सर्व पिकाचे अवशेष काढा. '
        'बेण्याच्या गरम पाणी उपचाराचे नियोजन करा. प्रमाणित बेणे लवकर बुक करा.',
  }),
];

// ─────────────────────────────────────────────────────────────────
//  Year-round preventive actions
// ─────────────────────────────────────────────────────────────────
const List<PreventiveAction> preventiveActions = [
  PreventiveAction(
    icon: '🌡️',
    action: {
      'en': 'Hot water treat seed cane at 50°C for 2 hours',
      'hi': '50°C पर 2 घंटे गर्म पानी से बीज ऊस उपचार',
      'mr': '50°C वर 2 तास गरम पाण्यात बेणे उपचार',
    },
    timing: {
      'en': 'Before planting (Jan-Mar)',
      'hi': 'बुवाई से पहले (जनवरी-मार्च)',
      'mr': 'लागवडीपूर्वी (जानेवारी-मार्च)',
    },
  ),
  PreventiveAction(
    icon: '🐛',
    action: {
      'en': 'Apply Imidacloprid for aphid control',
      'hi': 'माहू नियंत्रण के लिए इमिडाक्लोप्रिड लगाएं',
      'mr': 'मावा नियंत्रणासाठी इमिडाक्लोप्रिड फवारा',
    },
    timing: {
      'en': 'Apr-May and Sep-Oct',
      'hi': 'अप्रैल-मई और सितंबर-अक्टूबर',
      'mr': 'एप्रिल-मे आणि सप्टेंबर-ऑक्टोबर',
    },
  ),
  PreventiveAction(
    icon: '🧪',
    action: {
      'en': 'Spray Mancozeb 75 WP for Rust prevention',
      'hi': 'रतुआ रोकथाम के लिए मैंकोज़ेब 75 WP छिड़काव',
      'mr': 'गंज प्रतिबंधासाठी मॅन्कोझेब 75 WP फवारणी',
    },
    timing: {
      'en': 'Jun-Jul (pre-monsoon preventive)',
      'hi': 'जून-जुलाई (बारिश पूर्व बचाव)',
      'mr': 'जून-जुलै (पावसाळापूर्व प्रतिबंधक)',
    },
  ),
  PreventiveAction(
    icon: '🚰',
    action: {
      'en': 'Clean drainage channels before monsoon',
      'hi': 'बारिश से पहले नालियाँ साफ करें',
      'mr': 'पावसाळ्यापूर्वी चर स्वच्छ करा',
    },
    timing: {
      'en': 'May-Jun',
      'hi': 'मई-जून',
      'mr': 'मे-जून',
    },
  ),
  PreventiveAction(
    icon: '🔍',
    action: {
      'en': 'Rogue out diseased plants in field',
      'hi': 'खेत से रोगी पौधे उखाड़ें',
      'mr': 'शेतातून रोगग्रस्त पिके उपटा',
    },
    timing: {
      'en': 'Within first 3 months of planting',
      'hi': 'बुवाई के पहले 3 महीनों में',
      'mr': 'लागवडीच्या पहिल्या 3 महिन्यांत',
    },
  ),
  PreventiveAction(
    icon: '🧹',
    action: {
      'en': 'Remove all crop debris after harvest',
      'hi': 'कटाई के बाद सभी फसल अवशेष हटाएं',
      'mr': 'कापणीनंतर सर्व पिकाचे अवशेष काढा',
    },
    timing: {
      'en': 'Dec-Feb (post harvest)',
      'hi': 'दिसंबर-फरवरी (कटाई बाद)',
      'mr': 'डिसेंबर-फेब्रुवारी (कापणीनंतर)',
    },
  ),
];
