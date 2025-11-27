import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/configs/assets/app_vectors.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../core/presentation/uikit_2.0/theme_colors.dart';

class EditableFeaturedCard extends StatelessWidget {
  final String title;
  final VoidCallback onDelete;

  const EditableFeaturedCard({
    super.key,
    required this.title,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).extension<ThemeColors>()!.tile,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: textStyles.featuredCard,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 10),
                  SvgPicture.asset(
                    AppVectors.burger,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).extension<ThemeColors>()!.hint,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: SvgPicture.asset(
              AppVectors.trash,
              colorFilter: ColorFilter.mode(
                Theme.of(context).extension<ThemeColors>()!.red,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
