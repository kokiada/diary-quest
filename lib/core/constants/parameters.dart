import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 15項目のMECEパラメーターシステム
/// 5つの大カテゴリ、各3つの小項目で構成

enum ParameterCategory {
  tactics, // 思考
  execution, // 実行
  social, // 対人
  mastery, // 自制
  frontier, // 挑戦
}

enum GrowthParameter {
  // 思考（Tactics）
  analysis, // 分析・構造化
  creativity, // 企画・発想
  expertise, // 専門知識
  // 実行（Execution）
  speed, // スピード
  quality, // 精度・品質
  systematization, // 仕組み化
  // 対人（Social）
  negotiation, // 交渉・調整
  empathy, // 共感・サポート
  articulation, // 言語化
  // 自制（Mastery）
  resilience, // レジリエンス
  discipline, // 規律・習慣
  metacognition, // メタ認知
  // 挑戦（Frontier）
  riskTaking, // リスクテイク
  unlearning, // 学習棄却
  vision, // ビジョン設計
}

/// パラメーター情報
class ParameterInfo {
  final GrowthParameter parameter;
  final ParameterCategory category;
  final String nameJa;
  final String nameEn;
  final String description;
  final String growthMessage;
  final IconData icon;

  const ParameterInfo({
    required this.parameter,
    required this.category,
    required this.nameJa,
    required this.nameEn,
    required this.description,
    required this.growthMessage,
    required this.icon,
  });
}

/// パラメーター定義
class Parameters {
  Parameters._();

  static const Map<GrowthParameter, ParameterInfo> all = {
    // 思考（Tactics）
    GrowthParameter.analysis: ParameterInfo(
      parameter: GrowthParameter.analysis,
      category: ParameterCategory.tactics,
      nameJa: '分析・構造化',
      nameEn: 'Analysis',
      description: '物事を論理的に分解し、構造化する力',
      growthMessage: '論理的思考が冴え渡った',
      icon: Icons.analytics,
    ),
    GrowthParameter.creativity: ParameterInfo(
      parameter: GrowthParameter.creativity,
      category: ParameterCategory.tactics,
      nameJa: '企画・発想',
      nameEn: 'Creativity',
      description: '新しいアイデアを生み出す発想力',
      growthMessage: '創造の翼が広がった',
      icon: Icons.lightbulb,
    ),
    GrowthParameter.expertise: ParameterInfo(
      parameter: GrowthParameter.expertise,
      category: ParameterCategory.tactics,
      nameJa: '専門知識',
      nameEn: 'Expertise',
      description: '業務領域における深い知見',
      growthMessage: '知識の泉が深まった',
      icon: Icons.school,
    ),

    // 実行（Execution）
    GrowthParameter.speed: ParameterInfo(
      parameter: GrowthParameter.speed,
      category: ParameterCategory.execution,
      nameJa: 'スピード',
      nameEn: 'Speed',
      description: '迅速に行動し、成果を出す力',
      growthMessage: '疾風の如く駆け抜けた',
      icon: Icons.speed,
    ),
    GrowthParameter.quality: ParameterInfo(
      parameter: GrowthParameter.quality,
      category: ParameterCategory.execution,
      nameJa: '精度・品質',
      nameEn: 'Quality',
      description: '高い品質で仕事を仕上げる力',
      growthMessage: '匠の技が光った',
      icon: Icons.verified,
    ),
    GrowthParameter.systematization: ParameterInfo(
      parameter: GrowthParameter.systematization,
      category: ParameterCategory.execution,
      nameJa: '仕組み化',
      nameEn: 'Systematization',
      description: '再現性のある仕組みを作る力',
      growthMessage: '効率の魔法陣を描いた',
      icon: Icons.settings_suggest,
    ),

    // 対人（Social）
    GrowthParameter.negotiation: ParameterInfo(
      parameter: GrowthParameter.negotiation,
      category: ParameterCategory.social,
      nameJa: '交渉・調整',
      nameEn: 'Negotiation',
      description: '関係者間の調整を行う力',
      growthMessage: '外交術が磨かれた',
      icon: Icons.handshake,
    ),
    GrowthParameter.empathy: ParameterInfo(
      parameter: GrowthParameter.empathy,
      category: ParameterCategory.social,
      nameJa: '共感・サポート',
      nameEn: 'Empathy',
      description: '他者を理解し支援する力',
      growthMessage: '心の絆が深まった',
      icon: Icons.favorite,
    ),
    GrowthParameter.articulation: ParameterInfo(
      parameter: GrowthParameter.articulation,
      category: ParameterCategory.social,
      nameJa: '言語化',
      nameEn: 'Articulation',
      description: '考えを明確に伝える力',
      growthMessage: '言霊の力が宿った',
      icon: Icons.record_voice_over,
    ),

    // 自制（Mastery）
    GrowthParameter.resilience: ParameterInfo(
      parameter: GrowthParameter.resilience,
      category: ParameterCategory.mastery,
      nameJa: 'レジリエンス',
      nameEn: 'Resilience',
      description: '困難から立ち直る精神力',
      growthMessage: '不屈の精神が宿った',
      icon: Icons.shield,
    ),
    GrowthParameter.discipline: ParameterInfo(
      parameter: GrowthParameter.discipline,
      category: ParameterCategory.mastery,
      nameJa: '規律・習慣',
      nameEn: 'Discipline',
      description: '継続的に自分を律する力',
      growthMessage: '鉄の意志が鍛えられた',
      icon: Icons.event_repeat,
    ),
    GrowthParameter.metacognition: ParameterInfo(
      parameter: GrowthParameter.metacognition,
      category: ParameterCategory.mastery,
      nameJa: 'メタ認知',
      nameEn: 'Metacognition',
      description: '自分を客観視する力',
      growthMessage: '内なる目が開眼した',
      icon: Icons.psychology,
    ),

    // 挑戦（Frontier）
    GrowthParameter.riskTaking: ParameterInfo(
      parameter: GrowthParameter.riskTaking,
      category: ParameterCategory.frontier,
      nameJa: 'リスクテイク',
      nameEn: 'Risk Taking',
      description: 'リスクを取って挑戦する勇気',
      growthMessage: '勇者の心が燃えた',
      icon: Icons.trending_up,
    ),
    GrowthParameter.unlearning: ParameterInfo(
      parameter: GrowthParameter.unlearning,
      category: ParameterCategory.frontier,
      nameJa: '学習棄却',
      nameEn: 'Unlearning',
      description: '既存の考えを捨て新しく学ぶ力',
      growthMessage: '古き殻を脱ぎ捨てた',
      icon: Icons.autorenew,
    ),
    GrowthParameter.vision: ParameterInfo(
      parameter: GrowthParameter.vision,
      category: ParameterCategory.frontier,
      nameJa: 'ビジョン設計',
      nameEn: 'Vision',
      description: '未来を描き導く力',
      growthMessage: '未来を見通す眼を得た',
      icon: Icons.visibility,
    ),
  };

  /// カテゴリ情報
  static const Map<ParameterCategory, CategoryInfo> categories = {
    ParameterCategory.tactics: CategoryInfo(
      category: ParameterCategory.tactics,
      nameJa: '思考',
      nameEn: 'Tactics',
      description: '論理的に考え、知見を深めた',
      color: AppColors.tactics,
      icon: Icons.psychology_alt,
      parameters: [
        GrowthParameter.analysis,
        GrowthParameter.creativity,
        GrowthParameter.expertise,
      ],
    ),
    ParameterCategory.execution: CategoryInfo(
      category: ParameterCategory.execution,
      nameJa: '実行',
      nameEn: 'Execution',
      description: '手を動かし、効率的に完遂した',
      color: AppColors.execution,
      icon: Icons.rocket_launch,
      parameters: [
        GrowthParameter.speed,
        GrowthParameter.quality,
        GrowthParameter.systematization,
      ],
    ),
    ParameterCategory.social: CategoryInfo(
      category: ParameterCategory.social,
      nameJa: '対人',
      nameEn: 'Social',
      description: '人を動かし、周囲を支えた',
      color: AppColors.social,
      icon: Icons.groups,
      parameters: [
        GrowthParameter.negotiation,
        GrowthParameter.empathy,
        GrowthParameter.articulation,
      ],
    ),
    ParameterCategory.mastery: CategoryInfo(
      category: ParameterCategory.mastery,
      nameJa: '自制',
      nameEn: 'Mastery',
      description: '心を整え、自分を律した',
      color: AppColors.mastery,
      icon: Icons.self_improvement,
      parameters: [
        GrowthParameter.resilience,
        GrowthParameter.discipline,
        GrowthParameter.metacognition,
      ],
    ),
    ParameterCategory.frontier: CategoryInfo(
      category: ParameterCategory.frontier,
      nameJa: '挑戦',
      nameEn: 'Frontier',
      description: '変化を恐れず、未来へ踏み出した',
      color: AppColors.frontier,
      icon: Icons.explore,
      parameters: [
        GrowthParameter.riskTaking,
        GrowthParameter.unlearning,
        GrowthParameter.vision,
      ],
    ),
  };

  /// パラメーターのカテゴリを取得
  static ParameterCategory getCategoryFor(GrowthParameter param) {
    return all[param]!.category;
  }

  /// カテゴリの色を取得
  static Color getColorFor(GrowthParameter param) {
    final category = getCategoryFor(param);
    return categories[category]!.color;
  }
}

/// カテゴリ情報
class CategoryInfo {
  final ParameterCategory category;
  final String nameJa;
  final String nameEn;
  final String description;
  final Color color;
  final IconData icon;
  final List<GrowthParameter> parameters;

  const CategoryInfo({
    required this.category,
    required this.nameJa,
    required this.nameEn,
    required this.description,
    required this.color,
    required this.icon,
    required this.parameters,
  });
}
