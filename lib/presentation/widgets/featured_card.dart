import 'package:flutter/material.dart';

import '../../core/presentation/uikit/app_colors.dart';
import '../../core/presentation/uikit/app_text_styles.dart';
import '../../core/presentation/uikit/theme_extension.dart';

class FeaturedCard extends StatelessWidget {
  final String featureName;
  final Function()? onTap;
  final bool isChosen;
  final bool isCenterText;

  const FeaturedCard(
    this.featureName, {
    super.key,
    this.onTap,
    this.isChosen = false,
    this.isCenterText = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      color:
          isChosen
              ? context.appTheme.primaryColor
              : context.appTheme.firstLayerCardBackgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
          child: Text(
            featureName,
            style:
                isChosen
                    ? textStyles.itemText.copyWith(color: AppColors.white)
                    : textStyles.itemText,
            textAlign: isCenterText ? TextAlign.center : null,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
