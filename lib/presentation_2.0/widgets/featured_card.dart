import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/configs/assets/app_vectors.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../core/presentation/uikit_2.0/theme_colors.dart';

class FeaturedCard extends StatelessWidget {
  final String featureName;
  final Function()? onTap;
  final bool isChosen;
  final bool isFeatured;

  const FeaturedCard(
    this.featureName, {
    super.key,
    this.onTap,
    this.isChosen = false,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;

    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap ?? () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isChosen ? 8 : 10,
          horizontal: isChosen ? 14 : 16,
        ),
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).extension<ThemeColors>()!.tile,
          borderRadius: BorderRadius.circular(50),
          border:
              isChosen
                  ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                featureName,
                style: textStyles.featuredCard,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 10),
            isFeatured
                ? SvgPicture.asset(
                  width: 13,
                  height: 13,
                  AppVectors.starOutlined,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor,
                    BlendMode.srcIn,
                  ),
                )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
