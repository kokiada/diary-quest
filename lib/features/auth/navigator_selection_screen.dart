import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

/// ナビゲーター（相棒）選択画面
class NavigatorSelectionScreen extends ConsumerStatefulWidget {
  final bool isChanging; // 変更モードフラグ

  const NavigatorSelectionScreen({
    super.key,
    this.isChanging = false,
  });

  @override
  ConsumerState<NavigatorSelectionScreen> createState() =>
      _NavigatorSelectionScreenState();
}

class _NavigatorSelectionScreenState
    extends ConsumerState<NavigatorSelectionScreen> {
  NavigatorType? _selectedNavigator;

  @override
  void initState() {
    super.initState();
    // 変更モードの場合は現在のナビゲーターを選択状態にする
    if (widget.isChanging) {
      final authState = ref.read(authProvider);
      _selectedNavigator = authState.userModel?.selectedNavigator;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(child: _buildNavigatorList()),
            _buildConfirmButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            widget.isChanging ? '相棒を変更' : '相棒を選ぼう',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isChanging
                ? '新しい相棒を選んでください'
                : 'あなたの冒険を共にする仲間を選んでください',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigatorList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: NavigatorType.values.length,
      itemBuilder: (context, index) {
        final type = NavigatorType.values[index];
        final info = Navigators.getInfo(type);
        final isSelected = _selectedNavigator == type;

        return GestureDetector(
          onTap: () => setState(() => _selectedNavigator = type),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.secondary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // アイコン
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getNavigatorColor(type).withValues(alpha: 0.2),
                  ),
                  child: Icon(
                    _getNavigatorIcon(type),
                    size: 32,
                    color: _getNavigatorColor(type),
                  ),
                ),
                const SizedBox(width: 16),

                // テキスト
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.nameJa,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.secondary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        info.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // チェック
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppColors.secondary),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _selectedNavigator == null ? null : _confirmSelection,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.background,
            disabledBackgroundColor: AppColors.surfaceLight,
          ),
          child: Text(
            widget.isChanging ? '変更する' : 'この相棒と冒険を始める',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  IconData _getNavigatorIcon(NavigatorType type) {
    switch (type) {
      case NavigatorType.strategist:
        return Icons.psychology;
      case NavigatorType.bigBrother:
        return Icons.local_fire_department;
      case NavigatorType.spirit:
        return Icons.spa;
      case NavigatorType.knight:
        return Icons.shield;
      case NavigatorType.catFairy:
        return Icons.pets;
    }
  }

  Color _getNavigatorColor(NavigatorType type) {
    switch (type) {
      case NavigatorType.strategist:
        return AppColors.tactics;
      case NavigatorType.bigBrother:
        return AppColors.execution;
      case NavigatorType.spirit:
        return AppColors.mastery;
      case NavigatorType.knight:
        return AppColors.social;
      case NavigatorType.catFairy:
        return AppColors.frontier;
    }
  }

  Future<void> _confirmSelection() async {
    if (_selectedNavigator == null) return;

    // TODO: ユーザープロファイルにナビゲーター選択を保存
    await ref.read(authProvider.notifier).updateNavigator(_selectedNavigator!);

    if (mounted) {
      if (widget.isChanging) {
        // 変更モードの場合は設定画面に戻る
        Navigator.of(context).pop(true);
      } else {
        // 初回選択の場合はホーム画面に遷移
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }
}
