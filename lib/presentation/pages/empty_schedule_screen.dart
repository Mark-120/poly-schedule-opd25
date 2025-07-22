import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poly_scheduler/core/presentation/uikit/theme_extension.dart';

import '../../core/date_formater.dart';
import '../../core/presentation/uikit/app_strings.dart';
import '../../core/presentation/uikit/app_text_styles.dart';
import '../../service_locator.dart';
import '../state_managers/featured_screen_bloc/featured_bloc.dart';
import 'featured_screen.dart';

class EmptyScheduleScreen extends StatelessWidget {
  const EmptyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);
    final weekStart = DateFormater.truncDate(DateTime.now());
    final weekEnd = weekStart.add(Duration(days: 6));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.appTheme.iconColor),
          onPressed: () {},
        ),
        title: Column(
          children: [
            Text(
              '${DateFormater.showShortDateToUser(weekStart)} - ${DateFormater.showShortDateToUser(weekEnd)}',
              style: textStyles.titleAppbar,
            ),
            Text(
              weekStart.isOdd ? AppStrings.oddWeek : AppStrings.evenWeek,
              style: textStyles.subtitleAppbar,
            ),
          ],
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
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: Icon(
                Icons.star_outline_outlined,
                color: context.appTheme.iconColor,
              ),
              iconSize: 28,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BlocProvider(
                            lazy: false,
                            create:
                                (context) => FeaturedBloc(
                                  getFeaturedGroups: sl(),
                                  getFeaturedTeachers: sl(),
                                  getFeaturedRooms: sl(),
                                  setFeaturedGroups: sl(),
                                  setFeaturedTeachers: sl(),
                                  setFeaturedRooms: sl(),
                                  saveLastSchedule: sl(),
                                ),
                            child: FeaturedScreen(),
                          ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
