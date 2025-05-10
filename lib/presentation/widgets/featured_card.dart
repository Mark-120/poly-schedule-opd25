import 'package:flutter/material.dart';

import '../../core/presentation/app_text_styles.dart';
import '../../core/presentation/theme_extension.dart';
import '../../core/presentation/app_colors.dart';

Widget featuredCard(
  BuildContext context,
  String featureName, {
  Function()? onTap,
  bool isChosen = false,
  bool isCenterText = false,
}) {
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
