import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/widgets/home_glass_card.dart';

/// Centered hero + text; fits fixed [height] without overflow.
class HomeVerticalActionCard extends StatelessWidget {
  const HomeVerticalActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.hero,
    required this.footer,
    this.body,
    this.onTap,
    this.height,
    this.compact = false,
    this.dense = false,
  });

  final String title;
  final String subtitle;
  final Color accentColor;
  final Widget hero;
  final Widget? body;
  final Widget footer;
  final VoidCallback? onTap;
  final double? height;
  final bool compact;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final padV = dense ? 8.0 : 10.0;
    final padH = dense ? 8.0 : 10.0;
    final hasBody = body != null;
    final titleSize = dense ? 9.5 : (compact ? 10.0 : 11.0);
    final subSize = dense ? 7.0 : 8.0;
    final gap = dense ? 4.0 : 6.0;

    return HomeGlassCard(
      onTap: onTap,
      height: height,
      radius: 18,
      padding: EdgeInsets.fromLTRB(padH, padV, padH, dense ? 6 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: hasBody ? 38 : 48,
            child: Align(
              alignment: Alignment.center,
              child: hero,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: titleSize,
              fontWeight: FontWeight.w800,
              color: accentColor,
              letterSpacing: 0.5,
              height: 1.1,
            ),
          ),
          SizedBox(height: dense ? 2 : 3),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: dense ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: subSize,
              height: 1.15,
              fontWeight: FontWeight.w500,
              color: colors.onScenicMuted,
            ),
          ),
          if (hasBody) ...[
            SizedBox(height: gap),
            Expanded(
              flex: 42,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: dense ? 4 : 6,
                  horizontal: dense ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: colors.tertiary.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colors.glassBorder.withValues(alpha: 0.4),
                  ),
                ),
                alignment: Alignment.center,
                child: body,
              ),
            ),
          ],
          SizedBox(height: dense ? 4 : 6),
          footer,
        ],
      ),
    );
  }
}
