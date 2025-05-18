import 'package:flutter/material.dart';
import 'package:poly_scheduler/core/presentation/theme_extension.dart';

import '../../core/presentation/app_strings.dart';
import '../../core/presentation/app_text_styles.dart';
import 'featured_screen.dart';
import 'settings_screen.dart';

class EmptyScheduleScreen extends StatelessWidget {
  const EmptyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.appTheme.iconColor),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: context.appTheme.iconColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/mingcute_sad-line.png'),
          SizedBox(height: 26),
          Text(
            AppStrings.noFeaturedInfoMessage,
            style: textStyles.noInfoMessage,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: context.appTheme.iconColor,
              ),
              iconSize: 28,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  ),
            ),
            IconButton(
              icon: Icon(
                Icons.star_outline_outlined,
                color: context.appTheme.iconColor,
              ),
              iconSize: 28,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeaturedScreen()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
