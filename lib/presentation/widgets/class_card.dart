import 'package:flutter/material.dart';
import 'package:poly_scheduler/core/presentation/app_text_styles.dart';
import 'package:poly_scheduler/core/presentation/theme_extension.dart';

Widget classCard(
  String timeStart,
  String timeEnd,
  String title,
  String teacher,
  String type,
  String location,
  BuildContext context,
) {
  final textStyles = AppTextStylesProvider.of(context);

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$timeStart - $timeEnd', style: textStyles.mainInfoClassCard),
            Text(location, style: textStyles.mainInfoClassCard),
          ],
        ),
      ),
      Card(
        color: context.appTheme.secondLayerCardBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textStyles.mainInfoClassCard,
                      softWrap: true,
                    ),
                    SizedBox(height: 6),
                    Text(
                      teacher,
                      style: textStyles.teacherInfoClassCard,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(type, style: textStyles.typeOfLessonClassCard),
                  IconButton(
                    icon: Icon(
                      Icons.expand_more,
                      color: context.appTheme.secondaryColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
