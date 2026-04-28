import 'package:flutter/material.dart';
import '../services/language_service.dart';

/// Human-friendly, farmer-oriented disease information.
/// All content written in plain, practical language — not clinical AI text.
/// Supports EN / HI / MR.
class DiseaseInfo {
  final Map<String, String> name;
  final String emoji;
  final Color color;
  final Color colorLight;
  final Map<String, String> severity;
  final Map<String, String> description;
  final Map<String, String> cause;
  final Map<String, String> symptoms;
  final Map<String, String> treatment;
  final Map<String, String> prevention;
  final Map<String, String> fieldTips;

  const DiseaseInfo({
    required this.name,
    required this.emoji,
    required this.color,
    required this.colorLight,
    required this.severity,
    required this.description,
    required this.cause,
    required this.symptoms,
    required this.treatment,
    required this.prevention,
    required this.fieldTips,
  });

  String get localName => name[LanguageService().langCode] ?? name['en']!;
  String get localSeverity => severity[LanguageService().langCode] ?? severity['en']!;
  String get localDescription => description[LanguageService().langCode] ?? description['en']!;
  String get localCause => cause[LanguageService().langCode] ?? cause['en']!;
  String get localSymptoms => symptoms[LanguageService().langCode] ?? symptoms['en']!;
  String get localTreatment => treatment[LanguageService().langCode] ?? treatment['en']!;
  String get localPrevention => prevention[LanguageService().langCode] ?? prevention['en']!;
  String get localFieldTips => fieldTips[LanguageService().langCode] ?? fieldTips['en']!;
}

// ─────────────────────────────────────────────────────────────────────────────
//  DISEASE DATABASE — Written in farmer-friendly language, not clinical text
// ─────────────────────────────────────────────────────────────────────────────
const Map<String, DiseaseInfo> diseaseDatabase = {

  // ═══════════════════════════ 1) HEALTHY ═══════════════════════════════════
  'Healthy': DiseaseInfo(
    emoji: '🌿',
    color: Color(0xFF2ECC71),
    colorLight: Color(0xFFD5F5E3),
    name: {
      'en': 'Healthy',
      'hi': 'स्वस्थ',
      'mr': 'निरोगी',
    },
    severity: {
      'en': 'None — All Good!',
      'hi': 'कोई नहीं — सब ठीक!',
      'mr': 'काहीच नाही — सगळं छान!',
    },
    description: {
      'en': 'Great news! Your sugarcane leaf looks healthy. The plant is growing well '
          'and shows no signs of disease. Keep up the good work with your current '
          'farming practices.',
      'hi': 'अच्छी खबर! आपके ऊस की पत्ती स्वस्थ दिखती है। पौधा अच्छे से बढ़ रहा '
          'है और रोग का कोई निशान नहीं है। अपनी मौजूदा खेती पद्धति को जारी रखें।',
      'mr': 'चांगली बातमी! तुमच्या ऊसाचे पान निरोगी दिसत आहे। पीक उत्तम वाढत '
          'आहे आणि रोगाचे कोणतेही चिन्ह नाही. तुमच्या सध्याच्या शेती '
          'पद्धती चालू ठेवा.',
    },
    cause: {
      'en': 'Not applicable — your crop is healthy!',
      'hi': 'लागू नहीं — आपकी फसल स्वस्थ है!',
      'mr': 'लागू नाही — तुमचे पीक निरोगी आहे!',
    },
    symptoms: {
      'en': 'Leaves are uniformly green, firm, and upright. No spots, discoloration, '
          'or unusual patterns visible.',
      'hi': 'पत्तियाँ एक समान हरी, मज़बूत और सीधी हैं। कोई धब्बे, रंग बदलना '
          'या असामान्य पैटर्न नहीं दिखाई देते।',
      'mr': 'पाने एकसमान हिरवी, मजबूत आणि सरळ आहेत. कोणतेही डाग, रंग बदल '
          'किंवा असामान्य नमुने दिसत नाहीत.',
    },
    treatment: {
      'en': 'No treatment needed! Just continue regular watering, proper spacing, '
          'and timely fertilizer application.',
      'hi': 'कोई उपचार की ज़रूरत नहीं! बस नियमित पानी, उचित दूरी और समय '
          'पर खाद देते रहें।',
      'mr': 'उपचार गरज नाही! नियमित पाणी, योग्य अंतर आणि वेळेवर '
          'खत दुणे चालू ठेवा.',
    },
    prevention: {
      'en': '• Keep fields clean and weed-free\n'
          '• Use disease-free seed cane from trusted sources\n'
          '• Ensure good drainage — waterlogging invites trouble\n'
          '• Rotate crops every 2-3 years if possible',
      'hi': '• खेत को साफ और खरपतवार मुक्त रखें\n'
          '• भरोसेमंद स्रोत से रोगमुक्त बीज ऊस का उपयोग करें\n'
          '• अच्छी जल निकासी सुनिश्चित करें — जलभराव मुसीबत लाता है\n'
          '• हो सके तो हर 2-3 साल में फसल चक्र अपनाएं',
      'mr': '• शेत स्वच्छ आणि तणमुक्त ठेवा\n'
          '• विश्वसनीय स्रोतातून रोगमुक्त बेणे वापरा\n'
          '• चांगला निचरा ठेवा — पाणी साचल्यास अडचण येते\n'
          '• शक्य असल्यास दर 2-3 वर्षांनी पीक फेरपालट करा',
    },
    fieldTips: {
      'en': 'Tip: Take photos regularly even when your crop looks healthy. '
          'This builds a history that helps you spot problems early next time.',
      'hi': 'सुझाव: फसल स्वस्थ दिखने पर भी नियमित फोटो खींचें। इससे एक '
          'इतिहास बनता है जो अगली बार समस्या जल्दी पहचानने में मदद करता है।',
      'mr': 'टीप: पीक निरोगी दिसत असतानाही नियमित फोटो काढा. यामुळे '
          'एक इतिहास तयार होतो जो पुढच्या वेळी समस्या लवकर ओळखण्यास मदत करतो.',
    },
  ),

  // ═══════════════════════════ 2) MOSAIC ════════════════════════════════════
  'Mosaic': DiseaseInfo(
    emoji: '🟡',
    color: Color(0xFFF1C40F),
    colorLight: Color(0xFFFEF9E7),
    name: {
      'en': 'Mosaic Disease',
      'hi': 'मोज़ेक रोग',
      'mr': 'मोझॅक रोग',
    },
    severity: {
      'en': 'Moderate',
      'hi': 'मध्यम',
      'mr': 'मध्यम',
    },
    description: {
      'en': 'If you notice light and dark green patches on your sugarcane leaves — '
          'almost like someone painted stripes with two shades of green — that\'s '
          'Mosaic disease. It\'s caused by a virus called SCMV (Sugarcane Mosaic Virus). '
          'The good news is it usually doesn\'t kill the plant right away, but it can '
          'reduce your yield by 10-15% if left unchecked.',
      'hi': 'अगर आपके ऊस की पत्तियों पर हल्के और गहरे हरे रंग के धब्बे दिखें — '
          'जैसे किसी ने दो शेड्स से धारियाँ बनाई हों — तो यह मोज़ेक रोग है। '
          'यह SCMV नाम के वायरस से होता है। '
          'अच्छी बात यह है कि यह तुरंत पौधा नहीं मारता, लेकिन ध्यान न दें '
          'तो उत्पादन 10-15% तक कम हो सकता है।',
      'mr': 'तुमच्या ऊसाच्या पानांवर फिक्या आणि गडद हिरव्या रंगाचे डाग दिसत '
          'असतील — जणू कोणी दोन रंगांनी पट्टे रंगवले — तर हा मोझॅक रोग '
          'आहे. हा SCMV नावाच्या विषाणूमुळे होतो. '
          'चांगली गोष्ट म्हणजे हा लगेच पीक मारत नाही, पण दुर्लक्ष केल्यास '
          'उत्पादन 10-15% कमी होऊ शकते.',
    },
    cause: {
      'en': 'Spread mainly by aphids (tiny green insects) that hop from infected '
          'plants to healthy ones. Also spreads through infected seed cane — '
          'if you plant cuttings from a sick plant, the new plants will be sick too.',
      'hi': 'मुख्य रूप से माहू (छोटे हरे कीड़े) द्वारा फैलता है जो संक्रमित '
          'पौधों से स्वस्थ पौधों पर जाते हैं। संक्रमित बीज ऊस से भी फैलता है — '
          'अगर बीमार पौधे की कटिंग लगाएंगे तो नए पौधे भी बीमार होंगे।',
      'mr': 'मुख्यतः मावा (लहान हिरवे कीटक) द्वारे पसरतो जे संक्रमित '
          'पिकांवरून निरोगी पिकांवर उड्या मारतात. संक्रमित बेण्यातूनही पसरतो — '
          'आजारी पिकाचे कांडे लावले तर नवीन पीकही आजारी होईल.',
    },
    symptoms: {
      'en': '• Light and dark green irregular stripes on young leaves\n'
          '• Leaves may look slightly crinkled or wavy\n'
          '• Growth becomes slightly stunted over time\n'
          '• Stalks become thinner than normal',
      'hi': '• नई पत्तियों पर हल्की और गहरी हरी अनियमित धारियाँ\n'
          '• पत्तियाँ थोड़ी सिकुड़ी या लहरदार दिख सकती हैं\n'
          '• समय के साथ बढ़ोतरी थोड़ी रुक जाती है\n'
          '• डंठल सामान्य से पतले हो जाते हैं',
      'mr': '• नवीन पानांवर फिक्या आणि गडद हिरव्या अनियमित पट्टे\n'
          '• पाने किंचित सुरकुतलेली किंवा लहरी दिसू शकतात\n'
          '• कालांतराने वाढ थोडी खुंटते\n'
          '• कांडे सामान्यपेक्षा बारीक होतात',
    },
    treatment: {
      'en': '1. Pull out severely infected plants and burn them (don\'t compost!)\n'
          '2. Spray imidacloprid 17.8 SL @ 3ml per 10 liters water to control aphids\n'
          '3. For next season, always use seed cane from a healthy crop\n'
          '4. If more than 20% of plants are infected, consider replanting next season '
          'with a resistant variety like Co 0238 or CoLk 94184',
      'hi': '1. बुरी तरह संक्रमित पौधों को उखाड़कर जला दें (खाद में न डालें!)\n'
          '2. माहू नियंत्रण के लिए 10 लीटर पानी में 3ml इमिडाक्लोप्रिड 17.8 SL डालकर छिड़काव करें\n'
          '3. अगले सीज़न में हमेशा स्वस्थ फसल से बीज ऊस लें\n'
          '4. अगर 20% से ज़्यादा पौधे संक्रमित हैं, तो अगले सीज़न में Co 0238 '
          'या CoLk 94184 जैसी प्रतिरोधी किस्म लगाने पर विचार करें',
      'mr': '1. जास्त संक्रमित पिके उपटून जाळून टाका (कंपोस्ट करू नका!)\n'
          '2. मावा नियंत्रणासाठी 10 लिटर पाण्यात 3ml इमिडाक्लोप्रिड 17.8 SL मिसळून फवारणी करा\n'
          '3. पुढच्या हंगामात नेहमी निरोगी पिकातून बेणे घ्या\n'
          '4. 20% पेक्षा जास्त पिके संक्रमित असल्यास, पुढच्या हंगामात Co 0238 '
          'किंवा CoLk 94184 सारखा प्रतिरोधी वाण लावण्याचा विचार करा',
    },
    prevention: {
      'en': '• Always buy seed cane from government farms or certified nurseries\n'
          '• Hot water treat seed cane at 50°C for 2 hours before planting\n'
          '• Keep field borders clean — weeds can harbor virus\n'
          '• After harvest, remove all crop residue\n'
          '• Monitor for aphids regularly during monsoon season',
      'hi': '• बीज ऊस हमेशा सरकारी फार्म या प्रमाणित नर्सरी से खरीदें\n'
          '• बुवाई से पहले 50°C पर 2 घंटे गर्म पानी उपचार करें\n'
          '• खेत की मेड़ साफ रखें — खरपतवार वायरस को पनाह दे सकते हैं\n'
          '• कटाई के बाद फसल अवशेष हटाएं\n'
          '• बारिश में नियमित रूप से माहू की निगरानी करें',
      'mr': '• बेणे नेहमी सरकारी फार्म किंवा प्रमाणित नर्सरीतून घ्या\n'
          '• लागवडीपूर्वी 50°C वर 2 तास गरम पाण्यात बेणे प्रक्रिया करा\n'
          '• शेताच्या बांधावरचे तण स्वच्छ करा — तणात विषाणू आसरा घेतो\n'
          '• कापणीनंतर पिकाचे अवशेष काढून टाका\n'
          '• पावसाळ्यात नियमित माव्याचे निरीक्षण करा',
    },
    fieldTips: {
      'en': 'Farmer Tip: Don\'t panic if you see Mosaic. It rarely kills crops completely. '
          'Focus on controlling aphids and using clean seed cane. Many experienced farmers '
          'manage Mosaic successfully by roguing infected plants within the first 3 months.',
      'hi': 'किसान टिप: मोज़ेक देखकर घबराएं नहीं। यह शायद ही कभी पूरी फसल मारता है। '
          'माहू नियंत्रण और साफ बीज ऊस पर ध्यान दें। कई अनुभवी किसान पहले '
          '3 महीने में संक्रमित पौधे उखाड़कर मोज़ेक सफलतापूर्वक प्रबंधित करते हैं।',
      'mr': 'शेतकरी टीप: मोझॅक दिसला म्हणून घाबरू नका. हा क्वचितच पूर्ण पीक मारतो. '
          'मावा नियंत्रण आणि स्वच्छ बेणे वापरण्यावर लक्ष केंद्रित करा. अनेक अनुभवी '
          'शेतकरी पहिल्या 3 महिन्यांत संक्रमित पिके उपटून मोझॅक यशस्वीपणे हाताळतात.',
    },
  ),

  // ═══════════════════════════ 3) RUST ══════════════════════════════════════
  'Rust': DiseaseInfo(
    emoji: '🟠',
    color: Color(0xFFE67E22),
    colorLight: Color(0xFFFDEBD0),
    name: {
      'en': 'Rust Disease',
      'hi': 'रतुआ रोग',
      'mr': 'गंज रोग',
    },
    severity: {
      'en': 'Moderate',
      'hi': 'मध्यम',
      'mr': 'मध्यम',
    },
    description: {
      'en': 'You\'ll see small orange-brown raised spots on the underside of leaves — '
          'they look like rust stains on metal, which is why farmers call it "Rust." '
          'When you rub these spots, a brown powder comes off on your finger. '
          'This is a fungal disease caused by Puccinia melanocephala. It usually '
          'shows up during humid weather after monsoon.',
      'hi': 'पत्तियों के नीचे की तरफ छोटे नारंगी-भूरे उभरे हुए धब्बे दिखेंगे — '
          'ये बिल्कुल लोहे पर लगे जंग जैसे दिखते हैं, इसीलिए इसे "रतुआ" कहते हैं। '
          'इन धब्बों को रगड़ने पर भूरा पाउडर उंगली पर आता है। '
          'यह एक कवक रोग है जो Puccinia melanocephala से होता है। '
          'आमतौर पर बारिश के बाद नम मौसम में दिखता है।',
      'mr': 'पानांच्या खालच्या बाजूला लहान नारिंगी-तपकिरी उठलेले डाग दिसतील — '
          'ते अगदी लोखंडावरच्या गंजासारखे दिसतात, म्हणून याला "गंज" म्हणतात. '
          'हे डाग घासले तर तपकिरी पावडर बोटावर येते. '
          'हा Puccinia melanocephala या बुरशीमुळे होणारा रोग आहे. '
          'साधारणतः पावसाळ्यानंतर दमट हवामानात दिसतो.',
    },
    cause: {
      'en': 'Fungal spores that travel through wind and rain. The disease loves '
          'humid weather (70-80% humidity) and temperatures between 20-30°C. '
          'Crowded fields with poor air circulation are at highest risk.',
      'hi': 'कवक बीजाणु जो हवा और बारिश के ज़रिए फैलते हैं। '
          'यह रोग नम मौसम (70-80% नमी) और 20-30°C तापमान में पनपता है। '
          'कम हवा आने वाले भीड़-भाड़ वाले खेतों में सबसे ज़्यादा खतरा होता है।',
      'mr': 'हवा आणि पावसाद्वारे पसरणारे बुरशीचे बीजाणू. '
          'हा रोग दमट हवामान (70-80% आर्द्रता) आणि 20-30°C तापमानात वाढतो. '
          'कमी हवा खेळत असलेल्या दाटीवाटीच्या शेतांना सर्वाधिक धोका.',
    },
    symptoms: {
      'en': '• Small orange-brown pustules (raised bumps) on leaf undersides\n'
          '• Brown powder rubs off when you touch the spots\n'
          '• In severe cases, leaves may dry up and fall\n'
          '• Yellow halos may form around each pustule',
      'hi': '• पत्तियों के नीचे छोटे नारंगी-भूरे फफोले (उभरे हुए दाने)\n'
          '• धब्बे छूने पर भूरा पाउडर निकलता है\n'
          '• गंभीर मामलों में पत्तियाँ सूखकर गिर सकती हैं\n'
          '• हर फफोले के चारों ओर पीला घेरा बन सकता है',
      'mr': '• पानांच्या खालच्या बाजूला लहान नारिंगी-तपकिरी पुटकुळ्या\n'
          '• डाग स्पर्श केल्यावर तपकिरी पावडर निघते\n'
          '• गंभीर प्रकरणात पाने सुकून गळतात\n'
          '• प्रत्येक पुटकुळीभोवती पिवळे वलय दिसू शकते',
    },
    treatment: {
      'en': '1. Spray Mancozeb 75 WP @ 2.5 grams per liter of water — cover both '
          'sides of leaves\n'
          '2. Propiconazole 25 EC @ 1ml per liter also works well\n'
          '3. Repeat spray after 15 days if symptoms persist\n'
          '4. Remove and destroy severely infected lower leaves\n'
          '5. Improve field ventilation by maintaining proper row spacing',
      'hi': '1. मैंकोज़ेब 75 WP @ 2.5 ग्राम प्रति लीटर पानी में छिड़काव — पत्तियों '
          'के दोनों तरफ करें\n'
          '2. प्रोपिकोनाज़ोल 25 EC @ 1ml प्रति लीटर भी अच्छा काम करता है\n'
          '3. लक्षण बने रहें तो 15 दिन बाद दोबारा छिड़काव करें\n'
          '4. बुरी तरह संक्रमित नीचे की पत्तियाँ तोड़कर नष्ट करें\n'
          '5. उचित कतार दूरी रखकर खेत में हवा का आवागमन सुधारें',
      'mr': '1. मॅन्कोझेब 75 WP @ 2.5 ग्रॅम प्रति लिटर पाण्यात फवारणी — '
          'पानांच्या दोन्ही बाजूंना करा\n'
          '2. प्रॉपिकोनॅझोल 25 EC @ 1ml प्रति लिटर पण चांगले काम करते\n'
          '3. लक्षणे कायम राहिल्यास 15 दिवसांनी पुन्हा फवारणी करा\n'
          '4. जास्त संक्रमित खालची पाने तोडून नष्ट करा\n'
          '5. योग्य ओळ अंतर ठेवून शेतात हवा खेळवा',
    },
    prevention: {
      'en': '• Plant resistant varieties — check with your local agriculture office\n'
          '• Don\'t overcrowd — maintain at least 90cm row spacing\n'
          '• Balanced fertilizer use — too much nitrogen increases susceptibility\n'
          '• Remove crop residue after harvest\n'
          '• Pre-monsoon preventive spray of Mancozeb helps.',
      'hi': '• प्रतिरोधी किस्में लगाएं — अपने स्थानीय कृषि कार्यालय से जानकारी लें\n'
          '• ज़्यादा भीड़ न करें — कम से कम 90cm कतार दूरी रखें\n'
          '• संतुलित खाद — बहुत ज़्यादा नाइट्रोजन से खतरा बढ़ता है\n'
          '• कटाई के बाद फसल अवशेष हटाएं\n'
          '• बारिश से पहले मैंकोज़ेब का बचाव छिड़काव मददगार है',
      'mr': '• प्रतिरोधी वाण लावा — तुमच्या स्थानिक कृषी कार्यालयाचा सल्ला घ्या\n'
          '• जास्त गर्दी करू नका — किमान 90cm ओळ अंतर ठेवा\n'
          '• संतुलित खत — खूप जास्त नायट्रोजनने धोका वाढतो\n'
          '• कापणीनंतर पिकाचे अवशेष काढा\n'
          '• पावसाळ्यापूर्वी मॅन्कोझेब प्रतिबंधक फवारणी उपयुक्त',
    },
    fieldTips: {
      'en': 'Farmer Tip: Rust looks scary but rarely kills your whole crop. The key '
          'is timing — spray fungicide as soon as you spot the first orange spots. '
          'Don\'t wait for it to spread. Early morning spraying (before 9 AM) covers '
          'leaves better when dew makes them slightly wet.',
      'hi': 'किसान टिप: रतुआ डरावना दिखता है लेकिन शायद ही पूरी फसल मारता है। '
          'कुंजी है समय — पहले नारंगी धब्बे दिखते ही कवकनाशी स्प्रे करें। '
          'फैलने का इंतज़ार न करें। सुबह (9 बजे से पहले) छिड़काव बेहतर रहता है '
          'क्योंकि ओस से पत्तियाँ थोड़ी गीली होती हैं।',
      'mr': 'शेतकरी टीप: गंज भयावह दिसतो पण क्वचितच पूर्ण पीक मारतो. '
          'मुद्दा वेळेचा आहे — पहिले नारिंगी डाग दिसताच बुरशीनाशक फवारा. '
          'पसरायला वेळ देऊ नका. सकाळी (9 पूर्वी) फवारणी चांगली कव्हर करते '
          'कारण दवामुळे पाने थोडी ओली असतात.',
    },
  ),

  // ═══════════════════════════ 4) RED ROT ═══════════════════════════════════
  'RedRot': DiseaseInfo(
    emoji: '🔴',
    color: Color(0xFFE74C3C),
    colorLight: Color(0xFFFDEDEC),
    name: {
      'en': 'Red Rot Disease',
      'hi': 'लाल सड़न रोग',
      'mr': 'लाल कूज रोग',
    },
    severity: {
      'en': 'Severe — Act Fast!',
      'hi': 'गंभीर — जल्दी करें!',
      'mr': 'गंभीर — त्वरित कृती करा!',
    },
    description: {
      'en': 'Red Rot is the most dangerous disease for sugarcane — farmers call it '
          '"the cancer of sugarcane." When you split open an infected stalk, you\'ll '
          'see red patches inside with white bands crossing through them. The stalk '
          'starts to smell sour, almost like vinegar. If you catch it late, it can '
          'destroy your entire field within weeks.',
      'hi': 'लाल सड़न ऊस का सबसे खतरनाक रोग है — किसान इसे "ऊस का कैंसर" '
          'कहते हैं। संक्रमित डंठल को चीरकर देखें तो अंदर लाल धब्बे दिखेंगे '
          'जिनमें सफेद पट्टियाँ होंगी। डंठल से खट्टी गंध आने लगती है, '
          'लगभग सिरके जैसी। देर से पता चले तो हफ्तों में पूरा खेत बर्बाद '
          'हो सकता है।',
      'mr': 'लाल कूज हा ऊसाचा सर्वात धोकादायक रोग आहे — शेतकरी याला '
          '"ऊसाचा कॅन्सर" म्हणतात. संक्रमित कांडे फोडून पाहिले तर आत '
          'लाल डाग दिसतात ज्यातून पांढऱ्या पट्ट्या जातात. कांड्याला  '
          'आंबट वास येतो, जवळजवळ व्हिनेगारसारखा. उशीरा कळले तर '
          'आठवड्यांत संपूर्ण शेत नष्ट होऊ शकते.',
    },
    cause: {
      'en': 'Caused by the fungus Colletotrichum falcatum. It enters the stalk '
          'through cuts, wounds, or borer holes. Waterlogged fields are the biggest '
          'risk factor. The fungus survives in infected crop debris left in the field.',
      'hi': 'Colletotrichum falcatum कवक से होता है। यह कटे, घाव या बोरर छेदों '
          'से डंठल में घुसता है। जलभराव वाले खेत सबसे ज़्यादा खतरे में होते हैं। '
          'कवक खेत में बचे संक्रमित फसल अवशेषों में जीवित रहता है।',
      'mr': 'Colletotrichum falcatum या बुरशीमुळे होतो. कापलेल्या जखमा किंवा '
          'भुंगा छिद्रांतून कांड्यात शिरतो. पाणी साचलेल्या शेतांना सर्वात '
          'जास्त धोका. बुरशी शेतात राहिलेल्या संक्रमित अवशेषांत जगतो.',
    },
    symptoms: {
      'en': '• Leaves start drying from the top (crown drying)\n'
          '• Stalk becomes soft and spongy when pressed\n'
          '• Sour/alcoholic smell from cut stalks\n'
          '• Red patches with white bands inside split stalks\n'
          '• Third and fourth leaves from top turn yellow first',
      'hi': '• ऊपर से पत्तियाँ सूखने लगती हैं (शिखर सूखना)\n'
          '• दबाने पर डंठल नरम और स्पंजी हो जाता है\n'
          '• कटे डंठल से खट्टी/शराब जैसी गंध\n'
          '• चीरे हुए डंठल के अंदर सफेद पट्टियों वाले लाल धब्बे\n'
          '• ऊपर से तीसरी-चौथी पत्ती पहले पीली होती है',
      'mr': '• वरून पाने सुकायला लागतात (शेंडा सुकणे)\n'
          '• दाबल्यावर कांडे मऊ आणि स्पंजी होते\n'
          '• कापलेल्या कांड्यातून आंबट/दारूसारखा वास\n'
          '• फोडलेल्या कांड्यात पांढऱ्या पट्ट्यांसह लाल डाग\n'
          '• वरून तिसरे-चौथे पान प्रथम पिवळे होते',
    },
    treatment: {
      'en': '1. IMMEDIATELY uproot infected plants and burn them — do NOT leave in field\n'
          '2. Treat remaining healthy seed cane with Carbendazim 50 WP @ 2g per liter '
          'for 30 minutes before replanting\n'
          '3. Improve drainage — Red Rot loves waterlogged soil\n'
          '4. Do NOT ratoon from infected fields\n'
          '5. If more than 10% plants are infected, it\'s better to start fresh '
          'next season with clean seed from a disease-free plot',
      'hi': '1. संक्रमित पौधों को तुरंत उखाड़कर जला दें — खेत में न छोड़ें\n'
          '2. बचे स्वस्थ बीज ऊस को कार्बेंडाज़िम 50 WP @ 2g प्रति लीटर में '
          '30 मिनट भिगोएं, फिर लगाएं\n'
          '3. जल निकासी सुधारें — लाल सड़न को जलभराव पसंद है\n'
          '4. संक्रमित खेत से रैटून (पेड़ी) न लें\n'
          '5. 10% से ज़्यादा पौधे संक्रमित हों तो अगले सीज़न में रोगमुक्त '
          'खेत से साफ बीज लेकर नई शुरुआत करें',
      'mr': '1. संक्रमित पिके तात्काळ उपटून जाळा — शेतात सोडू नका\n'
          '2. उर्वरित निरोगी बेणे कार्बेंडाझिम 50 WP @ 2g प्रति लिटर मध्ये '
          '30 मिनिटे भिजवा, मग लावा\n'
          '3. निचरा सुधारा — लाल कूजला पाणी साचलेली जमीन आवडते\n'
          '4. संक्रमित शेतातून खोडवा (रॅटून) घेऊ नका\n'
          '5. 10% पेक्षा जास्त पिके संक्रमित असल्यास पुढच्या हंगामात '
          'रोगमुक्त शेतातून स्वच्छ बेणे घेऊन नव्याने सुरुवात करा',
    },
    prevention: {
      'en': '• NEVER use seed cane from infected fields\n'
          '• Hot water treatment: 50°C for 2 hours kills the fungus\n'
          '• Ensure proper drainage — don\'t let water stand for more than 24 hours\n'
          '• Control borers (shoot borer, top borer) — their holes let fungus enter\n'
          '• Plant during recommended season for your region\n'
          '• Use resistant varieties: Co 0238, CoLk 94184, Co 0118',
      'hi': '• संक्रमित खेत से कभी बीज ऊस न लें\n'
          '• गर्म पानी उपचार: 50°C पर 2 घंटे — कवक मर जाता है\n'
          '• उचित जल निकासी — 24 घंटे से ज़्यादा पानी न रुके\n'
          '• बोरर (तना बोरर, शिखर बोरर) नियंत्रित करें — इनके छेदों से कवक घुसता है\n'
          '• अपने क्षेत्र के अनुसार सही समय पर बुवाई करें\n'
          '• प्रतिरोधी किस्में: Co 0238, CoLk 94184, Co 0118',
      'mr': '• संक्रमित शेतातून कधीही बेणे घेऊ नका\n'
          '• गरम पाणी उपचार: 50°C वर 2 तास — बुरशी मरते\n'
          '• योग्य निचरा — 24 तासांपेक्षा जास्त पाणी साचू देऊ नका\n'
          '• भुंगा (खोड भुंगा, शेंडा भुंगा) नियंत्रित करा — त्यांच्या छिद्रांतून बुरशी शिरते\n'
          '• तुमच्या भागानुसार योग्य हंगामात लागवड करा\n'
          '• प्रतिरोधी वाण: Co 0238, CoLk 94184, Co 0118',
    },
    fieldTips: {
      'en': 'Farmer Tip: Red Rot is serious but preventable. The single most important '
          'thing you can do is NEVER plant seed from an infected field. Even one infected '
          'cutting can spread disease to your entire new crop. Invest in certified seed '
          'cane — it\'s cheaper than losing your harvest.',
      'hi': 'किसान टिप: लाल सड़न गंभीर है लेकिन रोकी जा सकती है। सबसे ज़रूरी बात '
          '— संक्रमित खेत से कभी बीज न लें। एक भी संक्रमित कटिंग पूरी नई फसल '
          'में रोग फैला सकती है। प्रमाणित बीज ऊस में खर्च करें — '
          'यह फसल गँवाने से सस्ता है।',
      'mr': 'शेतकरी टीप: लाल कूज गंभीर आहे पण टाळता येतो. सर्वात महत्त्वाची '
          'गोष्ट — संक्रमित शेतातून कधीही बेणे घेऊ नका. एकही संक्रमित कांडे '
          'संपूर्ण नवीन पिकात रोग पसरवू शकते. प्रमाणित बेण्यात गुंतवणूक करा — '
          'पीक गमावण्यापेक्षा ते स्वस्त आहे.',
    },
  ),

  // ═══════════════════════════ 5) YELLOW LEAF ═══════════════════════════════
  'Yellow': DiseaseInfo(
    emoji: '💛',
    color: Color(0xFFF39C12),
    colorLight: Color(0xFFFEF5E7),
    name: {
      'en': 'Yellow Leaf Disease',
      'hi': 'पीली पत्ती रोग',
      'mr': 'पिवळ्या पानाचा रोग',
    },
    severity: {
      'en': 'Moderate to Severe',
      'hi': 'मध्यम से गंभीर',
      'mr': 'मध्यम ते गंभीर',
    },
    description: {
      'en': 'When the midrib (the thick center line) of older leaves starts turning '
          'bright yellow while the rest of the leaf is still green — that\'s Yellow '
          'Leaf Disease. It starts from the lower leaves and works its way up. '
          'The affected leaves eventually dry up completely. This can reduce your '
          'juice quality and tonnage by 15-25% if left untreated.',
      'hi': 'जब पुरानी पत्तियों की मध्य शिरा (बीच की मोटी लाइन) चमकीली पीली '
          'होने लगे जबकि बाकी पत्ती हरी हो — यही पीली पत्ती रोग है। '
          'यह निचली पत्तियों से शुरू होकर ऊपर बढ़ता है। प्रभावित पत्तियाँ '
          'अंत में पूरी सूख जाती हैं। इलाज न करें तो रस की गुणवत्ता '
          'और वज़न 15-25% तक कम हो सकता है।',
      'mr': 'जेव्हा जुन्या पानांच्या मध्यशिरा (मधली जाड रेषा) चमकदार पिवळी '
          'होऊ लागते आणि बाकी पान अजूनही हिरवे असते — तो पिवळ्या पानाचा '
          'रोग आहे. हा खालच्या पानांपासून सुरू होऊन वर जातो. '
          'बाधित पाने शेवटी पूर्ण सुकतात. उपचार न केल्यास रसाची गुणवत्ता '
          'आणि टनेज 15-25% कमी होऊ शकते.',
    },
    cause: {
      'en': 'Caused by Sugarcane Yellow Leaf Virus (SCYLV), spread by a tiny aphid '
          'called Melanaphis sacchari. This aphid is very small and hides on the '
          'underside of leaves. The virus also spreads through infected seed cane.',
      'hi': 'Sugarcane Yellow Leaf Virus (SCYLV) से होता है, जो Melanaphis sacchari '
          'नाम के छोटे माहू से फैलता है। यह माहू बहुत छोटा होता है '
          'और पत्तियों के नीचे छुपा रहता है। वायरस संक्रमित बीज ऊस से भी फैलता है।',
      'mr': 'Sugarcane Yellow Leaf Virus (SCYLV) मुळे होतो, Melanaphis sacchari '
          'या लहान माव्याद्वारे पसरतो. हा मावा खूप लहान असतो आणि '
          'पानांच्या खालच्या बाजूला लपतो. विषाणू संक्रमित बेण्यातूनही पसरतो.',
    },
    symptoms: {
      'en': '• Yellow discoloration of leaf midrib (starts from tip)\n'
          '• Older (lower) leaves affected first\n'
          '• Leaves dry and die from tip downward\n'
          '• Plant growth slows down noticeably\n'
          '• Stalks becomes thinner with shorter internodes',
      'hi': '• पत्ती की मध्य शिरा पीली होना (शिखर से शुरू)\n'
          '• पुरानी (निचली) पत्तियाँ पहले प्रभावित होती हैं\n'
          '• पत्तियाँ ऊपर से नीचे सूखती हैं\n'
          '• पौधे की बढ़ोतरी काफी धीमी हो जाती है\n'
          '• डंठल पतले हो जाते हैं, गाँठों के बीच कम दूरी',
      'mr': '• पानाच्या मध्यशिरा पिवळी होणे (टोकापासून सुरू)\n'
          '• जुनी (खालची) पाने प्रथम बाधित\n'
          '• पाने टोकापासून खाली सुकतात\n'
          '• पिकाची वाढ लक्षणीयरित्या मंदावते\n'
          '• कांडे बारीक होतात, डोळ्यांतील अंतर कमी',
    },
    treatment: {
      'en': '1. Uproot and destroy severely affected plants\n'
          '2. Spray Imidacloprid 17.8 SL @ 3ml per 10 liters to control aphids\n'
          '3. Apply balanced fertilizer — potassium helps plants fight virus\n'
          '4. Do NOT take ratoon crop from affected fields\n'
          '5. For next planting, use tissue culture plants or heat-treated seed',
      'hi': '1. गंभीर रूप से प्रभावित पौधों को उखाड़कर नष्ट करें\n'
          '2. माहू नियंत्रण के लिए 10 लीटर पानी में 3ml इमिडाक्लोप्रिड 17.8 SL छिड़कें\n'
          '3. संतुलित खाद दें — पोटेशियम पौधों को वायरस से लड़ने में मदद करता है\n'
          '4. प्रभावित खेत से रैटून (पेड़ी) न लें\n'
          '5. अगली बुवाई के लिए टिशू कल्चर या गर्म पानी उपचारित बीज लें',
      'mr': '1. अत्यंत बाधित पिके उपटून नष्ट करा\n'
          '2. मावा नियंत्रणासाठी 10 लिटर पाण्यात 3ml इमिडाक्लोप्रिड 17.8 SL फवारा\n'
          '3. संतुलित खत द्या — पालाश पिकाला विषाणूशी लढण्यास मदत करतो\n'
          '4. बाधित शेतातून खोडवा (रॅटून) घेऊ नका\n'
          '5. पुढच्या लागवडीसाठी टिश्यू कल्चर किंवा गरम पाणी उपचारित बेणे वापरा',
    },
    prevention: {
      'en': '• Use certified, virus-free seed cane\n'
          '• Hot water treatment at 50°C for 2 hours\n'
          '• Plant resistant varieties: CoLk 94184, Co 0238\n'
          '• Regular aphid monitoring — especially Sept-Nov\n'
          '• Remove ratoon crops from infected plots\n'
          '• Maintain soil health with balanced NPK + micronutrients',
      'hi': '• प्रमाणित, वायरस-मुक्त बीज ऊस का उपयोग करें\n'
          '• 50°C पर 2 घंटे गर्म पानी उपचार\n'
          '• प्रतिरोधी किस्में लगाएं: CoLk 94184, Co 0238\n'
          '• नियमित माहू निगरानी — विशेषकर सितंबर-नवंबर\n'
          '• संक्रमित खेत से रैटून फसल हटाएं\n'
          '• संतुलित NPK और सूक्ष्म पोषक तत्वों से मिट्टी स्वास्थ्य बनाए रखें',
      'mr': '• प्रमाणित, विषाणूमुक्त बेणे वापरा\n'
          '• 50°C वर 2 तास गरम पाणी उपचार\n'
          '• प्रतिरोधी वाण लावा: CoLk 94184, Co 0238\n'
          '• नियमित मावा निरीक्षण — विशेषतः सप्टेंबर-नोव्हेंबर\n'
          '• संक्रमित शेतांतून खोडवा पीक काढा\n'
          '• संतुलित NPK + सूक्ष्म अन्नद्रव्यांनी जमिनीचे आरोग्य राखा',
    },
    fieldTips: {
      'en': 'Farmer Tip: Yellow Leaf is tricky because by the time you see yellowing, '
          'the virus has been in the plant for weeks. The best defense is prevention — '
          'clean seed cane and aphid control. If you see yellowing in just a few plants, '
          'remove them immediately before aphids carry the virus to neighbors.',
      'hi': 'किसान टिप: पीली पत्ती मुश्किल है क्योंकि जब पीलापन दिखता है, '
          'तब तक वायरस हफ्तों से पौधे में होता है। सबसे अच्छा बचाव है रोकथाम — '
          'साफ बीज ऊस और माहू नियंत्रण। अगर कुछ ही पौधों में पीलापन दिखे, '
          'तो तुरंत उखाड़ें इससे पहले कि माहू वायरस पड़ोसियों में ले जाए।',
      'mr': 'शेतकरी टीप: पिवळ्या पानाचा रोग अवघड आहे कारण पिवळेपणा दिसतो '
          'तोपर्यंत विषाणू आठवड्यांपासून पिकात असतो. सर्वोत्तम बचाव म्हणजे '
          'प्रतिबंध — स्वच्छ बेणे आणि मावा नियंत्रण. काही पिकांतच पिवळेपणा '
          'दिसल्यास लगेच उपटा, माव्याने विषाणू शेजारच्या पिकांत नेण्यापूर्वी.',
    },
  ),
};
