/// ジョブ（職業）定義
class JobDefinition {
  final String id;
  final String nameJa;
  final String nameEn;
  final String description;
  final String imagePath;
  final Map<String, int> requiredParams;

  const JobDefinition({
    required this.id,
    required this.nameJa,
    required this.nameEn,
    required this.description,
    required this.imagePath,
    required this.requiredParams,
  });
}

/// ジョブ定義一覧
class Jobs {
  Jobs._();

  static const List<JobDefinition> all = [
    JobDefinition(
      id: 'strategist_master',
      nameJa: '戦略家',
      nameEn: 'Strategist',
      description: '深い分析力と先を見通す洞察力を持つ者',
      imagePath: 'assets/images/jobs/strategist.png',
      requiredParams: {'analysis': 100, 'vision': 50},
    ),
    JobDefinition(
      id: 'holy_knight',
      nameJa: '聖騎士',
      nameEn: 'Holy Knight',
      description: '仲間を守り、チームを導くリーダー',
      imagePath: 'assets/images/jobs/holy_knight.png',
      requiredParams: {'empathy': 100, 'discipline': 50},
    ),
    JobDefinition(
      id: 'speed_runner',
      nameJa: '疾風の使い',
      nameEn: 'Speed Runner',
      description: '圧倒的なスピードで成果を生み出す',
      imagePath: 'assets/images/jobs/speed_runner.png',
      requiredParams: {'speed': 100, 'quality': 50},
    ),
    JobDefinition(
      id: 'innovator',
      nameJa: '革新者',
      nameEn: 'Innovator',
      description: '既存の枠を壊し、新しい価値を創造する',
      imagePath: 'assets/images/jobs/innovator.png',
      requiredParams: {'creativity': 100, 'riskTaking': 50},
    ),
    JobDefinition(
      id: 'sage',
      nameJa: '賢者',
      nameEn: 'Sage',
      description: '深い専門知識と冷静な判断力を持つ',
      imagePath: 'assets/images/jobs/sage.png',
      requiredParams: {'expertise': 100, 'metacognition': 50},
    ),
    JobDefinition(
      id: 'diplomat',
      nameJa: '外交官',
      nameEn: 'Diplomat',
      description: '人々をつなぎ、調和をもたらす',
      imagePath: 'assets/images/jobs/diplomat.png',
      requiredParams: {'negotiation': 100, 'articulation': 50},
    ),
    JobDefinition(
      id: 'architect',
      nameJa: '設計士',
      nameEn: 'Architect',
      description: '再現性のある仕組みを構築する',
      imagePath: 'assets/images/jobs/architect.png',
      requiredParams: {'systematization': 100, 'analysis': 50},
    ),
    JobDefinition(
      id: 'phoenix',
      nameJa: '不死鳥',
      nameEn: 'Phoenix',
      description: '幾度の逆境も乗り越えて復活する',
      imagePath: 'assets/images/jobs/phoenix.png',
      requiredParams: {'resilience': 100, 'unlearning': 50},
    ),
  ];
}
