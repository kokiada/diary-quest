/// スキル定義
class SkillDefinition {
  final String id;
  final String nameJa;
  final String nameEn;
  final String description;
  final String category;
  final int requiredTotalExp;

  const SkillDefinition({
    required this.id,
    required this.nameJa,
    required this.nameEn,
    required this.description,
    required this.category,
    required this.requiredTotalExp,
  });
}

/// スキル定義一覧
class Skills {
  Skills._();

  static const List<SkillDefinition> all = [
    // 思考（Tactics）スキル
    SkillDefinition(
      id: 'logical_thinking',
      nameJa: 'ロジカル・シンキング',
      nameEn: 'Logical Thinking',
      description: '物事を論理的に分解・整理する技法',
      category: 'tactics',
      requiredTotalExp: 100,
    ),
    SkillDefinition(
      id: 'creative_ideation',
      nameJa: 'クリエイティブ・アイデーション',
      nameEn: 'Creative Ideation',
      description: '革新的なアイデアを生み出す発想技法',
      category: 'tactics',
      requiredTotalExp: 200,
    ),
    SkillDefinition(
      id: 'domain_mastery',
      nameJa: 'ドメイン・マスタリー',
      nameEn: 'Domain Mastery',
      description: '専門領域における深い知識と経験',
      category: 'tactics',
      requiredTotalExp: 500,
    ),

    // 実行（Execution）スキル
    SkillDefinition(
      id: 'rapid_execution',
      nameJa: 'ラピッド・エクゼキューション',
      nameEn: 'Rapid Execution',
      description: '迅速に行動し成果を出す実行力',
      category: 'execution',
      requiredTotalExp: 100,
    ),
    SkillDefinition(
      id: 'quality_craft',
      nameJa: 'クオリティ・クラフト',
      nameEn: 'Quality Craft',
      description: '高品質なアウトプットを生み出す技術',
      category: 'execution',
      requiredTotalExp: 200,
    ),
    SkillDefinition(
      id: 'process_automation',
      nameJa: 'プロセス・オートメーション',
      nameEn: 'Process Automation',
      description: '反復作業を仕組み化する能力',
      category: 'execution',
      requiredTotalExp: 500,
    ),

    // 対人（Social）スキル
    SkillDefinition(
      id: 'stakeholder_management',
      nameJa: 'ステークホルダー・マネジメント',
      nameEn: 'Stakeholder Management',
      description: '関係者との調整・合意形成能力',
      category: 'social',
      requiredTotalExp: 100,
    ),
    SkillDefinition(
      id: 'psychological_safety',
      nameJa: '心理的安全性の構築',
      nameEn: 'Psychological Safety',
      description: 'チームに安心感をもたらす能力',
      category: 'social',
      requiredTotalExp: 200,
    ),
    SkillDefinition(
      id: 'storytelling',
      nameJa: 'ストーリーテリング',
      nameEn: 'Storytelling',
      description: '物語として伝え、人を動かす力',
      category: 'social',
      requiredTotalExp: 500,
    ),

    // 自制（Mastery）スキル
    SkillDefinition(
      id: 'stress_management',
      nameJa: 'ストレス・マネジメント',
      nameEn: 'Stress Management',
      description: 'プレッシャーに負けない精神力',
      category: 'mastery',
      requiredTotalExp: 100,
    ),
    SkillDefinition(
      id: 'habit_formation',
      nameJa: 'ハビット・フォーメーション',
      nameEn: 'Habit Formation',
      description: '良い習慣を定着させる技術',
      category: 'mastery',
      requiredTotalExp: 200,
    ),
    SkillDefinition(
      id: 'self_awareness',
      nameJa: 'セルフ・アウェアネス',
      nameEn: 'Self Awareness',
      description: '自己を客観視し改善する能力',
      category: 'mastery',
      requiredTotalExp: 500,
    ),

    // 挑戦（Frontier）スキル
    SkillDefinition(
      id: 'calculated_risk',
      nameJa: 'カルキュレイテッド・リスク',
      nameEn: 'Calculated Risk',
      description: 'リスクを見極め挑戦する判断力',
      category: 'frontier',
      requiredTotalExp: 100,
    ),
    SkillDefinition(
      id: 'paradigm_shift',
      nameJa: 'パラダイム・シフト',
      nameEn: 'Paradigm Shift',
      description: '既存の考えを捨て変革する力',
      category: 'frontier',
      requiredTotalExp: 200,
    ),
    SkillDefinition(
      id: 'visionary_leadership',
      nameJa: 'ビジョナリー・リーダーシップ',
      nameEn: 'Visionary Leadership',
      description: '未来を描き人を導く力',
      category: 'frontier',
      requiredTotalExp: 500,
    ),
  ];
}
