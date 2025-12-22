import 'package:flutter/material.dart';

final List<Map<String, dynamic>> allCropsData = [
  {
    'name': {'en': 'Maize', 'hi': 'मक्का', 'te': 'మొక్కజొన్న'},
    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA5MExohcO7M8Ed4KfsIQsxCnebIsAV6H2EsvUQFuieIT2OxYGtbAcObb3j5iNvMtPWP4feQsLgyh-f5oA2HMbHEF-ZNnurnSva5x3tPxpr3KbXHAhaNlZJMOAQy8BbpPHx_sY73zPORloJ0XwKgu8nKS4knl2ZDrZzRVeQO3TEgdWDH3wo1XuMxsTkKU1LrkwzMygdOie-cO0Sde2R4ABYPNVwgGC7OBtbxNgaRct3kVjNQylBRJT0WZ8Y0To_k_GLYJNXMhGlxGk',
    'categories': ['grains', 'cash_crops'],
    'badge': {'en': 'High Value', 'hi': 'उच्च मूल्य', 'te': 'అధిక విలువ'},
    'tags': [
      {'icon': Icons.water_drop, 'label': {'en': 'Moderate', 'hi': 'मध्यम', 'te': 'మితమైన'}},
      {'icon': Icons.calendar_month, 'label': {'en': '90 Days', 'hi': '90 दिन', 'te': '90 రోజులు'}},
    ],
    'description': {
      'en': 'Maize is a staple cereal grain known for its versatility. It thrives in warm climates and provides high energy content. Requires nitrogen-rich soil for best yield.',
      'hi': 'मक्का एक प्रमुख अनाज है जो अपनी बहुमुखी प्रतिभा के लिए जाना जाता है। यह गर्म जलवायु में पनपता है और उच्च ऊर्जा प्रदान करता है। अच्छी उपज के लिए नाइट्रोजन युक्त मिट्टी की आवश्यकता होती है।',
      'te': 'మొక్కజొన్న దీని బహుళ వినియోగానికి ప్రసిద్ధి చెందిన ఒక ప్రధాన ధాన్యం. ఇది వెచ్చని వాతావరణంలో బాగా పెరుగుతుంది మరియు అధిక శక్తిని అందిస్తుంది. మంచి దిగుబడికి నైట్రోజన్ సమృద్ధిగా ఉన్న నేల అవసరం.'
    },
    'growing_conditions': {
      'soil': {'en': 'Well-drained, Loamy', 'hi': 'अच्छी जल निकासी वाली, दोमट', 'te': 'నీరు నిలవని, మెత్తటి నేల'},
      'climate': {'en': 'Warm (20-30°C)', 'hi': 'गर्म (20-30°C)', 'te': 'వెచ్చని (20-30°C)'},
      'water': {'en': 'Moderate', 'hi': 'मध्यम', 'te': 'మితమైన'},
    },
    'diseases': [
      {
        'name': {'en': 'Fall Armyworm', 'hi': 'फॉल आर्मीवर्म', 'te': 'కత్తెర పురుగు'},
        'description': {'en': 'Caterpillars feeding on leaves/stems.', 'hi': 'इल्लियां पत्तियों/तनों को खाती हैं।', 'te': 'గొంగళి పురుగులు ఆకులు/కాండాలను తింటాయి.'}
      },
      {
        'name': {'en': 'Leaf Blight', 'hi': 'पत्ती झुलसा', 'te': 'ఆకు మచ్చ తెగులు'},
        'description': {'en': 'Grayish-brown lesions on leaves.', 'hi': 'पत्तियों पर भूरे रंग के धब्बे।', 'te': 'ఆకులపై బూడిద-గోధుమ రంగు మచ్చలు.'}
      },
    ],
  },
  {
    'name': {'en': 'Rice', 'hi': 'चावल', 'te': 'వరి'},
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Rice_Plants_%28IRRI%29.jpg/800px-Rice_Plants_%28IRRI%29.jpg',
    'categories': ['grains', 'cash_crops'],
    'badge': {'en': 'Staple', 'hi': 'मुख्य आहार', 'te': 'ప్రధాన ఆహారం'},
    'badgeColor': Colors.green,
    'tags': [
       {'icon': Icons.water_drop, 'label': {'en': 'High Water', 'hi': 'अधिक पानी', 'te': 'ఎక్కువ నీరు'}, 'color': Colors.blue},
       {'icon': Icons.calendar_month, 'label': {'en': '120 Days', 'hi': '120 दिन', 'te': '120 రోజులు'}},
    ],
    'description': {
      'en': 'Rice is the primary staple food for more than half the world\'s population. It is a semi-aquatic grass famously grown in flooded paddy fields.',
      'hi': 'चावल दुनिया की आधी से अधिक आबादी का मुख्य भोजन है। यह एक अर्ध-जलीय घास है जिसे पानी से भरे धान के खेतों में उगाया जाता है।',
      'te': 'ప్రపంచ జనాభాలో సగానికి పైగా ప్రజలకు వరి ప్రధాన ఆహారం. ఇది నీటితో నిండిన పొలాల్లో పెరిగే ఒక రకమైన గడ్డి మొక్క.'
    },
    'growing_conditions': {
      'soil': {'en': 'Clayey, Retains Water', 'hi': 'चिकनी, पानी रोकने वाली', 'te': 'బంకమట్టి, నీటిని నిల్వ చేసేది'},
      'climate': {'en': 'Hot & Humid', 'hi': 'गर्म और आर्द्र', 'te': 'వేడి & తేమ'},
      'water': {'en': 'Flooded', 'hi': 'बाढ़ (पानी भरा हुआ)', 'te': 'నీటితో నిండిన'},
    },
    'diseases': [
      {'name': {'en': 'Rice Blast', 'hi': 'धान का ब्लास्ट', 'te': 'వరి అగ్గి తెగులు'}, 'description': {'en': 'Fungal lesions on leaves/nodes.', 'hi': 'पत्तियों/गांठों पर फफूंदी के घाव।', 'te': 'ఆకులు/కణుపులపై శిలీంధ్ర మచ్చలు.'}},
      {'name': {'en': 'Stem Borer', 'hi': 'तना छेदक', 'te': 'కాండం తొలిచే పురుగు'}, 'description': {'en': 'Larvae bore into stems killing shoots.', 'hi': 'लार्वा तनों में छेद करके पौधों को मार देते हैं।', 'te': 'లార్వా కాండంలోకి చొచ్చుకుపోయి మొక్కను చంపుతుంది.'}},
    ],
  },
  {
    'name': {'en': 'Wheat', 'hi': 'गेहूं', 'te': 'గోధుమ'},
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Vehn%C3%A4pelto_6.jpg/1280px-Vehn%C3%A4pelto_6.jpg',
    'categories': ['grains', 'cash_crops'],
    'tags': [
      {'icon': Icons.ac_unit, 'label': {'en': 'Cool Season', 'hi': 'ठडा मौसम', 'te': 'చల్లని సీజన్'}},
      {'icon': Icons.calendar_month, 'label': {'en': '100 Days', 'hi': '100 दिन', 'te': '100 రోజులు'}},
    ],
    'description': {
      'en': 'Wheat is a grass widely cultivated for its seed, a cereal grain which is a worldwide staple food. Best grown in winter seasons.',
      'hi': 'गेहूं एक घास है जिसकी खेती इसके बीज के लिए की जाती है। यह दुनिया भर में मुख्य भोजन है। सर्दियों के मौसम में सबसे अच्छा उगता है।',
      'te': 'గోధుమ అనేది దాని విత్తనం కోసం పండించే గడ్డి మొక్క, ఇది ప్రపంచవ్యాప్తంగా ప్రధాన ఆహారం. శీతాకాలంలో బాగా పండుతుంది.'
    },
    'growing_conditions': {
      'soil': {'en': 'Loamy, Well-drained', 'hi': 'दोमट, अच्छी जल निकासी वाली', 'te': 'మెత్తటి, నీరు నిలవని'},
      'climate': {'en': 'Cool (10-24°C)', 'hi': 'ठंडा (10-24°C)', 'te': 'చల్లని (10-24°C)'},
      'water': {'en': 'Low-Moderate', 'hi': 'कम-मध्यम', 'te': 'తక్కువ-మితమైన'},
    },
    'diseases': [
      {'name': {'en': 'Rust', 'hi': 'रतुआ (रस्ट)', 'te': 'తుప్పు తెగులు'}, 'description': {'en': 'Orange/Red powdery spores on leaves.', 'hi': 'पत्तियों पर नारंगी/लाल पाउडर जैसे बीजाणु।', 'te': 'ఆకులపై నారింజ/ఎరుపు పొడి మచ్చలు.'}},
    ],
  },
  {
    'name': {'en': 'Tomato', 'hi': 'टमाटर', 'te': 'టమాటో'},
    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAFUKzGUzL8PzBfZdoQRKXVCWuMM07U7NO8qkaP3SGN9ZcLjvq7ZQeReIRN97NEgMl3-rLTZiAQ7LSDmcZQQBBKjRi7Mh3iSjdwANSFxptU6ki9s7rUJr4_xO6sRoagBjxs6xwXrv9k4R226LtlMhJyC2ww4UvfOrr8GNKI6j10FagteUPdRVxBEPhBeLSBmeQXVHVOwxA-fqDmKRFHA5kPfYuX3-018_y9_69PvpxFZQhrm21vyVVBe52nOPzLchU6VKrvbfFWwOE',
    'categories': ['vegetables', 'cash_crops'],
    'tags': [
      {'icon': Icons.water_drop, 'label': {'en': 'Regular Water', 'hi': 'नियमित पानी', 'te': 'క్రమం తప్పని నీరు'}, 'color': Colors.blue},
      {'icon': Icons.monetization_on, 'label': {'en': 'Cash Crop', 'hi': 'नकदी फसल', 'te': 'నగదు పంట'}},
    ],
    'description': {
      'en': 'Tomatoes are the edible berry of the plant Solanum lycopersicum. They are rich in lycopene and vitamin C, requiring support (staking) for best results.',
      'hi': 'टमाटर सोलनम लाइकोपर्सिकम पौधे का खाद्य फल है। ये लाइकोपीन और विटामिन सी से भरपूर होते हैं, और अच्छे परिणामों के लिए सहारे की आवश्यकता होती है।',
      'te': 'టొమాటోలు సోలనం లైకోపెర్సికమ్ మొక్క యొక్క తినదగిన పండు. వీటిలో లైకోపీన్ మరియు విటమిన్ సి పుష్కలంగా ఉంటాయి, మంచి ఫలితాల కోసం ఊతం (staking) అవసరం.'
    },
    'growing_conditions': {
      'soil': {'en': 'Slightly Acidic, Fertile', 'hi': 'हल्की अम्लीय, उपजाऊ', 'te': 'కొద్దిగా ఆమ్ల, సారవంతమైన'},
      'climate': {'en': 'Warm (20-25°C)', 'hi': 'गर्म (20-25°C)', 'te': 'వెచ్చని (20-25°C)'},
      'water': {'en': 'Regular', 'hi': 'नियमित', 'te': 'క్రమం తప్పకుండా'},
    },
    'diseases': [
      {'name': {'en': 'Early Blight', 'hi': 'अगेती झुलसा', 'te': 'ఆకు మాడు తెగులు'}, 'description': {'en': 'Target-shaped spots on leaves.', 'hi': 'पत्तियों पर लक्ष्य के आकार के धब्बे।', 'te': 'ఆకులపై వలయాకార మచ్చలు.'}},
      {'name': {'en': 'Blossom End Rot', 'hi': 'ब्लसम एंड रॉट', 'te': 'పండు కుళ్లు తెగులు'}, 'description': {'en': 'Black rot at bottom of fruit due to Calcium.', 'hi': 'कैल्शियम की कमी से फल के नीचे काला सड़न।', 'te': 'కాల్షియం లోపం వల్ల పండు అడుగు భాగంలో నల్లటి కుళ్లు.'}},
    ],
  },
  {
    'name': {'en': 'Potato', 'hi': 'आलू', 'te': 'బంగాళాదుంప'},
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Patates.jpg/1280px-Patates.jpg',
    'categories': ['vegetables', 'cash_crops'],
    'tags': [
      {'icon': Icons.landscape, 'label': {'en': 'Tuber', 'hi': 'कंद', 'te': 'దుంప'}},
       {'icon': Icons.calendar_month, 'label': {'en': '90 Days', 'hi': '90 दिन', 'te': '90 రోజులు'}},
    ],
    'description': {
      'en': 'Potatoes are starchy tubers. They require loose soil for tuber development and cool weather.',
      'hi': 'आलू स्टार्च युक्त कंद हैं। उन्हें कंद के विकास के लिए ढीली मिट्टी और ठंडे मौसम की आवश्यकता होती है।',
      'te': 'బంగాళాదుంపలు పిండిపదార్థం కలిగిన దుంపలు. దుంప అభివృద్ధికి వీటికి గుల్లగా ఉన్న నేల మరియు చల్లని వాతావరణం అవసరం.'
    },
    'growing_conditions': {
      'soil': {'en': 'Loose, Sandy Loam', 'hi': 'ढीली, रेतीली दोमट', 'te': 'గుల్లగా, ఇసుకతో కూడిన మెత్తటి నేల'},
      'climate': {'en': 'Cool (15-20°C)', 'hi': 'ठंडा (15-20°C)', 'te': 'చల్లని (15-20°C)'},
      'water': {'en': 'Moderate', 'hi': 'मध्यम', 'te': 'మితమైన'},
    },
    'diseases': [
       {'name': {'en': 'Late Blight', 'hi': 'पछेती झुलसा', 'te': 'లేట్ బ్లైట్'}, 'description': {'en': 'Water-soaked spots on leaves.', 'hi': 'पत्तियों पर पानी से भीगे धब्बे।', 'te': 'ఆకులపై నీటితో తడిసిన మచ్చలు.'}},
    ],
  },
  {
    'name': {'en': 'Onion', 'hi': 'प्याज', 'te': 'ఉల్లిపాయ'},
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Onion_on_White.JPG/1280px-Onion_on_White.JPG',
    'categories': ['vegetables'],
    'tags': [
      {'icon': Icons.timer, 'label': {'en': 'Long Season', 'hi': 'लंबा मौसम', 'te': 'దీర్ఘకాలిక పంట'}},
    ],
    'description': {
      'en': 'Onions are bulb vegetables. They need a long growing season and plenty of sun.',
      'hi': 'प्याज कंद वाली सब्जियां हैं। उन्हें लंबे समय तक बढ़ने और भरपूर धूप की जरूरत होती है।',
      'te': 'ఉల్లిపాయలు గడ్డ జాతి కూరగాయలు. వీటికి పెరగడానికి ఎక్కువ సమయం మరియు పుష్కలమైన ఎండ అవసరం.'
    },
    'growing_conditions': {
      'soil': {'en': 'Firm, Fertile', 'hi': 'सख्त, उपजाऊ', 'te': 'గట్టి, సారవంతమైన'},
      'climate': {'en': 'Cool then Warm', 'hi': 'पहले ठंडा फिर गर्म', 'te': 'మొదట చల్లని, తరువాత వెచ్చని'},
      'water': {'en': 'Frequent', 'hi': 'बार-बार', 'te': 'తరచుగా'},
    },
    'diseases': [],
  },
  {
    'name': {'en': 'Banana', 'hi': 'केला', 'te': 'అరటి'},
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Bananas_white_background_DS.jpg/1280px-Bananas_white_background_DS.jpg',
    'categories': ['fruits', 'cash_crops'],
    'tags': [
      {'icon': Icons.wb_sunny, 'label': {'en': 'Tropical', 'hi': 'उष्णकटिबंधीय', 'te': 'ఉష్ణమండల'}},
    ],
    'description': {
      'en': 'Bananas are elongated, edible fruit – botanically a berry. They need constant warmth and moisture.',
      'hi': 'केले लम्बे, खाने योग्य फल हैं। उन्हें लगातार गर्मी और नमी की आवश्यकता होती है।',
      'te': 'అరటిపండ్లు పొడవాటి, తినదగిన పండ్లు. వీటికి నిరంతర వేడి మరియు తేమ అవసరం.'
    },
    'growing_conditions': {
      'soil': {'en': 'Rich, Well-drained', 'hi': 'समृद्ध, अच्छी जल निकासी', 'te': 'సారవంతమైన, నీరు నిలవని'},
      'climate': {'en': 'Tropical (27°C)', 'hi': 'उष्णकटिबंधीय (27°C)', 'te': 'ఉష్ణమండల (27°C)'},
      'water': {'en': 'High', 'hi': 'उच्च', 'te': 'ఎక్కువ'},
    },
    'diseases': [
      {'name': {'en': 'Panama Disease', 'hi': 'पनामा रोग', 'te': 'పనామా తెగులు'}, 'description': {'en': 'Wilt caused by soil fungus.', 'hi': 'मिट्टी के फंगस कारण मुरझाना।', 'te': 'నేల శిలీంధ్రం వల్ల వచ్చే వడలిపోవడం.'}},
    ],
  },
  {
    'name': {'en': 'Mango', 'hi': 'आम', 'te': 'మామిడి'},
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Hapus_Mango.jpg/1280px-Hapus_Mango.jpg',
    'categories': ['fruits', 'cash_crops'],
    'badge': {'en': 'King of Fruits', 'hi': 'फलों का राजा', 'te': 'పండ్ల రాజు'},
    'badgeColor': Colors.orangeAccent,
    'tags': [
      {'icon': Icons.wb_sunny, 'label': {'en': 'Summer', 'hi': 'गर्मी', 'te': 'వేసవి'}},
    ],
    'description': {
      'en': 'Mangoes are stone fruits produced from numerous species of tropical trees. Deep rooting system.',
      'hi': 'आम उष्णकटिबंधीय पेड़ों की कई प्रजातियों से उत्पादित गुठली वाले फल हैं। गहरी जड़ प्रणाली।',
      'te': 'మామిడి పండ్లు ఉష్ణమండల చెట్ల నుండి పండే పండ్లు. లోతైన వేరు వ్యవస్థ ఉంటుంది.'
    },
    'growing_conditions': {
      'soil': {'en': 'Alluvial / Lateritic', 'hi': 'जलोढ़ / लेटेराइट', 'te': 'ఒండ్రు / ఎర్ర నేల'},
      'climate': {'en': 'Tropical / Sub-tropical', 'hi': 'उष्णकटिबंधीय / उपोष्णकटिबंधीय', 'te': 'ఉష్ణమండల / ఉప-ఉష్ణమండల'},
      'water': {'en': 'Moderate', 'hi': 'मध्यम', 'te': 'మితమైన'},
    },
    'diseases': [],
  },
  {
    'name': {'en': 'Sorghum', 'hi': 'ज्वार', 'te': 'జొన్న'},
    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuB-_HdpgXH0bTDYI10S15hyhl06hUnyMyz-KH95AdP3riAu1wKDkZdYMDNWPf-zIrm28IlmE9i1QHJmi6DqjsZ4ebKF7M1C72ykZlqlxRyvWS3d-5VOGTR_TBDCLZRUOWE1JIKvlNbu2jU-ruAfkpp0n8XCTBsDLM2zCdNLXWXSmuRrwHOuPZ1CRrmVlMSWieEwUujIxk27g4RLPSffvR1ThOPqnUBZdfDoPghta05USo4ZxMbmz0c5iBduk7g3mI9ynqAXK_uJKBM',
    'categories': ['grains'],
    'badge': {'en': 'Recommended', 'hi': 'सिफारिश की गई', 'te': 'సిఫార్సు చేయబడింది'},
    'badgeColor': const Color(0xFF13EC6A),
    'badgeTextColor': Colors.black,
    'tags': [
      {'icon': Icons.wb_sunny, 'label': {'en': 'Drought Res', 'hi': 'सूखा प्रतिरोधी', 'te': 'కరువు తట్టుకునే'}, 'color': Colors.amber},
    ],
    'description': {
      'en': 'Sorghum is a resilient cereal grain that grows well in arid environments where other crops fail.',
      'hi': 'ज्वार एक लचीला अनाज है जो शुष्क वातावरण में अच्छी तरह से बढ़ता है जहां अन्य फसलें विफल हो जाती हैं।',
      'te': 'జొన్న కరువు ప్రాంతాల్లో, ఇతర పంటలు పండని చోట కూడా బాగా పెరిగే ధాన్యం.'
    },
    'growing_conditions': {
      'soil': {'en': 'Varied, Drought-prone', 'hi': 'विविध, सूखा प्रवण', 'te': 'వివిధ రకాల, కరువు నేలలు'},
      'climate': {'en': 'Hot/Arid', 'hi': 'गर्म/शुष्क', 'te': 'వేడి/శుష్క'},
      'water': {'en': 'Low', 'hi': 'कम', 'te': 'తక్కువ'},
    },
    'diseases': [],
  },
  {
    'name': {'en': 'Cotton', 'hi': 'कपास', 'te': 'పత్తి'},
    'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Cotton_plant.jpg/800px-Cotton_plant.jpg',
    'categories': ['cash_crops'],
    'badge': {'en': 'Fiber', 'hi': 'रेशा', 'te': 'దారం'},
    'badgeColor': Colors.white,
    'badgeTextColor': Colors.black,
    'tags': [
       {'icon': Icons.monetization_on, 'label': {'en': 'Industrial', 'hi': 'औद्योगिक', 'te': 'పారిశ్రామిక'}},
    ],
    'description': {
      'en': 'Cotton is a soft, fluffy staple fiber that grows in a boll. It is the most widely used natural fiber cloth.',
      'hi': 'कपास एक नरम, शराबी रेशा है जो एक बॉल में बढ़ता है। यह सबसे व्यापक रूप से इस्तेमाल किया जाने वाला प्राकृतिक रेशा है।',
      'te': 'పత్తి ఒక మెత్తటి ఫైబర్. ఇది వస్త్ర పరిశ్రమలో ఎక్కువగా ఉపయోగించే సహజ నార.'
    },
    'growing_conditions': {
      'soil': {'en': 'Black Cotton Soil', 'hi': 'काली मिट्टी', 'te': 'నల్లరేగడి నేల'},
      'climate': {'en': 'Hot, Long frost-free', 'hi': 'गर्म, पाला रहित', 'te': 'వేడి, మంచు లేని'},
      'water': {'en': 'Moderate', 'hi': 'मध्यम', 'te': 'మితమైన'},
    },
    'diseases': [
      {'name': {'en': 'Pink Bollworm', 'hi': 'गुलाबी सुंडी', 'te': 'గులాబీ రంగు పురుగు'}, 'description': {'en': 'Larvae feed on seeds/cotton lint.', 'hi': 'लार्वा बीज/कपास के रेशे को खाते हैं।', 'te': 'లార్వా విత్తనాలను/పత్తిని తింటుంది.'}},
    ],
  },
  {
    'name': {'en': 'Cassava', 'hi': 'कसावा', 'te': 'కర్రపెండలం'},
    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA40BP4Wtlb9RjOKbgBDg-b7ghrPbImCJr3SAROwnunVObl1UQigw9u38ZyJjxUHkxrnstKCeKaopNXUEAVXxfLhDjy7pUeLUn7I846I-mt2UmQOhUsfPkA7SH2_ivlshardZcM_vuAAtPYNiSBeCcZaWHTtqyyM7PsjJvGHU8NYZYG29FAD83ffKemoOWOXER7vVLciGPFS48WHKHzLjjt5L3uafHwEj1eQhFtHBuwtFDTp1Z4nmP87JxBhcGo6IuEYUG5CUBpSIY',
    'categories': ['vegetables', 'cash_crops'], 
    'tags': [
      {'icon': Icons.shield, 'label': {'en': 'Resilient', 'hi': 'लचीला', 'te': 'దృఢమైన'}},
      {'icon': Icons.build, 'label': {'en': 'Easy Care', 'hi': 'आसान देखभाल', 'te': 'సులభమైన నిర్వహణ'}},
    ],
    'description': {
      'en': 'Cassava is a woody shrub used for its edible starchy tuberous root. It is a major source of carbs in tropics.',
      'hi': 'कसावा एक झाड़ी है जिसका उपयोग इसकी खाने योग्य जड़ के लिए किया जाता है। यह उष्णकटिबंधीय क्षेत्रों में कार्ब्स का एक प्रमुख स्रोत है।',
      'te': 'కర్రపెండలం దాని పిండిపదార్థం కలిగిన వేరు కోసం పండించే మొక్క. ఇది ఉష్ణమండల ప్రాంతాల్లో కార్బోహైడ్రేట్లకి ప్రధాన వనరు.'
    },
    'growing_conditions': {
      'soil': {'en': 'Poor, Acidic okay', 'hi': 'खराब, अम्लीय भी ठीक', 'te': 'సారం లేని, ఆమ్ల నేల'},
      'climate': {'en': 'Tropical', 'hi': 'उष्णकटिबंधीय', 'te': 'ఉష్ణమండల'},
      'water': {'en': 'Low', 'hi': 'कम', 'te': 'తక్కువ'},
    },
    'diseases': [],
  },
  {
    'name': {'en': 'Coffee', 'hi': 'कॉफी', 'te': 'కాఫీ'},
    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuC7kr6Zq6l0p6Vz7ucLQKIepjrKlnkIl8-d_jVfNxn-98PD_2w4E292FvYLYMSvAjrOWzg8ZSlMm3VhvKpce9_4trXt57M9ZhSvAhKoyBF7ZBipwu_oW8fLOQ_Mn7NAHagtiunsAMypPiaQQTgqy9AQr4_7W_KSfys52wLHkOTehLDIoldO8ich69Ci7S5xkMLVRZsbg2ZT9L4JeL1b8zJdGEWqX9GXxx03EdE_8iEw-Shy7_JDlzdeVZDQz9Ml_8Z4IFkWr6Qs2zE',
    'categories': ['cash_crops'],
    'tags': [
      {'icon': Icons.landscape, 'label': {'en': 'Highland', 'hi': 'पहाड़ी', 'te': 'కొండ ప్రాంతం'}},
      {'icon': Icons.attach_money, 'label': {'en': 'Export', 'hi': 'निर्यात', 'te': 'ఎగుమతి'}},
    ],
     'description': {
      'en': 'Coffee is a brewed drink prepared from roasted coffee beans. It grows best in high altitudes.',
      'hi': 'कॉफी भुनी हुई कॉफी बीन्स से तैयार किया जाने वाला पेय है। यह अधिक ऊंचाई पर सबसे अच्छा बढ़ता है।',
      'te': 'కాఫీ అనేది వేయించిన కాఫీ గింజల నుండి తయారుచేసే పానీయం. ఇది ఎత్తైన ప్రదేశాల్లో బాగా పెరుగుతుంది.'
     },
     'growing_conditions': {
      'soil': {'en': 'Volcanic, Rich', 'hi': 'ज्वालामुखीय, समृद्ध', 'te': 'అగ్నిపర్వత, సారవంతమైన'},
      'climate': {'en': 'Cool Tropical', 'hi': 'ठंडा उष्णकटिबंधीय', 'te': 'చల్లని ఉష్ణమండల'},
      'water': {'en': 'Regular', 'hi': 'नियमित', 'te': 'క్రమం తప్పకుండా'},
    },
    'diseases': [],
  },
  {
    'name': {'en': 'Apples', 'hi': 'सेब', 'te': 'యాపిల్స్'},
    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCBzU00Pa5_c0iMPsaTH3WSQELLl0Ix2aYgqbynOp9sUQSSQaETnxriVjPqKui0tpmGfx30WpID3DMXu_upO6zqoQmW0bOn_vUXeojtYNOFtFecAF8pDM-UpUjLqJ3wgCX7XV8k1fXosNkK1CFsmS0cixuxzDgEP8zCZ_1kEz4Hf8zOsI-9U6qc5gVuwtTZwG42HuI_PRyW1AuSEcD2AUs4882zrf9LEl3JxB6hW3azYwHi_qt5eTXCaXwsGXR-5xd5bmjy95jDZt0',
    'categories': ['fruits', 'cash_crops'],
    'tags': [
      {'icon': Icons.ac_unit, 'label': {'en': 'Cold Climate', 'hi': 'ठंडी जलवायु', 'te': 'చల్లని వాతావరణం'}},
    ],
    'description': {
      'en': 'An apple is an edible fruit produced by an apple tree. Requires cold hours to fruit properly.',
      'hi': 'सेब एक खाद्य फल है। इसे ठीक से फल देने के लिए ठंड के घंटों की आवश्यकता होती है।',
      'te': 'యాపిల్ ఒక తినదగిన పండు. ఇది పండ్లను ఇవ్వడానికి చల్లని వాతావరణం అవసరం.'
    },
     'growing_conditions': {
      'soil': {'en': 'Well-drained', 'hi': 'अच्छी जल निकासी', 'te': 'నీరు నిలవని'},
      'climate': {'en': 'Temperate / Cold', 'hi': 'शीतोष्ण / शीत', 'te': 'సమశీతోష్ణ / చల్లని'},
      'water': {'en': 'Moderate', 'hi': 'मध्यम', 'te': 'మితమైన'},
    },
    'diseases': [],
  },
];
