import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../auth/login_screen.dart';
import '../auth/navigator_selection_screen.dart';
import 'widgets/edit_profile_dialog.dart';
import 'widgets/language_settings.dart';

/// 設定画面
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('設定', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),

          // プロフィールセクション
          _buildProfileSection(context, authState),
          const SizedBox(height: 24),

          // ナビゲーター設定
          _buildNavigatorSection(context, authState),
          const SizedBox(height: 24),

          // アプリ設定
          _buildAppSettings(context),
          const SizedBox(height: 24),

          // ログアウト
          _buildLogoutButton(context, ref),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, AuthState authState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.surfaceLight,
            child: Text(
              authState.userModel?.displayName.substring(0, 1) ?? '冒',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authState.userModel?.displayName ?? '冒険者',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  authState.firebaseUser?.email ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => const EditProfileDialog(),
              );
              if (result == true) {
                // プロフィール更新成功
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigatorSection(BuildContext context, AuthState authState) {
    final navigator = authState.userModel?.selectedNavigator;
    final info = navigator != null ? Navigators.getInfo(navigator) : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('相棒', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (context) => const NavigatorSelectionScreen(
                        isChanging: true, // 変更モードフラグ
                      ),
                    ),
                  );
                  if (result == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ナビゲーターを変更しました')),
                    );
                  }
                },
                child: const Text('変更'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                child: const Icon(Icons.psychology, color: AppColors.tactics),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info?.nameJa ?? '軍師',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      info?.description ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('アプリ設定', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildSettingItem(
            context,
            icon: Icons.notifications,
            title: '通知',
            subtitle: '朝のバフ・夜の報告',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: 通知設定
              },
              activeColor: AppColors.secondary,
            ),
          ),
          const Divider(),
          _buildSettingItem(
            context,
            icon: Icons.language,
            title: '言語',
            subtitle: '日本語',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LanguageSettings(),
                ),
              );
            },
          ),
          const Divider(),
          _buildSettingItem(
            context,
            icon: Icons.info,
            title: 'バージョン',
            subtitle: '1.0.0',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null && trailing == null)
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () async {
          await ref.read(authProvider.notifier).signOut();
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('ログアウト'),
      ),
    );
  }
}
