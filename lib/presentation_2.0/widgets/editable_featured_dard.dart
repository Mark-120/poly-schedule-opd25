import 'package:flutter/material.dart';

import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../core/presentation/uikit_2.0/theme_colors.dart';

class EditableFeaturedCard extends StatelessWidget {
  final String title;
  final VoidCallback onDelete;
  final Widget dragHandle;

  const EditableFeaturedCard({
    super.key,
    required this.title,
    required this.onDelete,
    required this.dragHandle,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<ThemeColors>()!.tile,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          dragHandle,
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: textStyles.featuredCard,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
