import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poly_scheduler/core/presentation/theme_extension.dart';

import '../../core/presentation/app_text_styles.dart';

class ExpandableClassCard extends StatefulWidget {
  final String timeStart;
  final String timeEnd;
  final String title;
  final String? teacher;
  final String abbrType;
  final String type;
  final String location;
  final List<String> groups;
  final String? sdoLink;

  const ExpandableClassCard({
    super.key,
    required this.timeStart,
    required this.timeEnd,
    required this.title,
    this.teacher,
    required this.type,
    required this.location,
    required this.groups,
    required this.abbrType,
    this.sdoLink,
  });

  @override
  State<ExpandableClassCard> createState() => _ExpandableClassCardState();
}

class _ExpandableClassCardState extends State<ExpandableClassCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);
    final theme = context.appTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.timeStart} - ${widget.timeEnd}',
                style: textStyles.mainInfoClassCard,
              ),
              Text(widget.location, style: textStyles.mainInfoClassCard),
            ],
          ),
        ),

        Card(
          color: theme.secondLayerCardBackgroundColor,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                _isExpanded
                    ? _buildExpandedCard(context, textStyles)
                    : _buildCollapsedCard(context, textStyles),
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsedCard(BuildContext context, AppTextStyles textStyles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      key: const ValueKey('collapsed'),
      child: Row(
        children: [
          Expanded(
            child:
                widget.teacher != ''
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: textStyles.mainInfoClassCard,
                          softWrap: true,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.teacher!,
                          style: textStyles.teacherInfoClassCard,
                          softWrap: true,
                        ),
                      ],
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: textStyles.mainInfoClassCard,
                          softWrap: true,
                        ),
                      ],
                    ),
          ),
          Row(
            children: [
              Text(widget.abbrType, style: textStyles.typeOfLessonClassCard),
              IconButton(
                icon: Icon(
                  Icons.expand_more,
                  color: context.appTheme.secondaryColor,
                ),
                onPressed: () => setState(() => _isExpanded = true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _copySdoLink() async {
    if (widget.sdoLink == null || widget.sdoLink!.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: widget.sdoLink!));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ссылка скопирована в буфер обмена'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildExpandedCard(BuildContext context, AppTextStyles textStyles) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      key: const ValueKey('expanded'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: textStyles.mainInfoClassCard.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            widget.type,
            style: textStyles.typeOfLessonClassCard.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),

          if (widget.teacher != '') ...[
            Text(widget.teacher!, style: textStyles.additionalInfoLabel),
            const SizedBox(height: 4),
          ],

          Text(widget.groups.join(', '), style: textStyles.additionalInfoText),
          const SizedBox(height: 12),

          if (widget.sdoLink != null)
            InkWell(
              onTap: _copySdoLink,
              child: Row(
                children: [
                  Text(
                    'Ссылка на СДО',
                    style: textStyles.teacherInfoClassCard.copyWith(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: context.appTheme.secondaryColor,
                      decorationThickness: 1,
                    ),
                  ),
                ],
              ),
            ),

          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => setState(() => _isExpanded = false),
              icon: Icon(
                Icons.expand_less,
                size: 20,
                color: context.appTheme.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
