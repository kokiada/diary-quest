import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 日記入力カード - ホーム画面のメイン機能
class DiaryInputCard extends ConsumerStatefulWidget {
  const DiaryInputCard({super.key});

  @override
  ConsumerState<DiaryInputCard> createState() => _DiaryInputCardState();
}

class _DiaryInputCardState extends ConsumerState<DiaryInputCard> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade50, Colors.purple.shade50],
            ),
          ),
          child: Stack(
            children: [
              // 背景画像
              Positioned.fill(
                child: Opacity(
                  opacity: 0.6,
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC6meIvE7FL-l8x7OGZMpy94KE0Ql67QbAYOPknFTE5PqsK1bhtrM9rrv0L1mQaHTJJZj7tphaYotTY7ICAQ_P3Ef8la53_vY8O-oqM4OQREBNNIIbdBLvnP8tIrP-63usXOcl0NL71C4EUc5okQgcTnxNPn1huUyUskuFBNT9AKExY9ecgdjI9iGLxfmny0XVBCyenT1heKtKgnr9C9jRzLCDRrmgEuPOy3iJ4n0BYjQffFz1Da9Ca3itm5vCBouTJco8Rh_LJEuI',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.blue.shade100,
                        child: const Icon(
                          Icons.landscape,
                          size: 80,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // グラデーションオーバーレイ
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ),
              // コンテンツ
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ロケーション表示
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Whispering Woods',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                    // タイトルとサブタイトル
                    Text(
                      'Campfire Base',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Sanctuary Level 1',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.blue.shade100,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.verified,
                          size: 14,
                          color: Colors.blue.shade100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // アップグレードボタン
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.upgrade, color: Color(0xFF3B82F6)),
                    onPressed: () {
                      // TODO: アップグレード機能
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
