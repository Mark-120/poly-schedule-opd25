import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/presentation/uikit/app_text_styles.dart';
import '../../core/presentation/uikit/theme_extension.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';

class ScheduleClassCard extends StatefulWidget {
  final String timeStart;
  final String timeEnd;
  final String title;
  final String? teacher;
  final String abbrType;
  final String type;
  final String location;
  final List<String> groups;
  final String? sdoLink;
  const ScheduleClassCard({
    super.key,
    required this.timeStart,
    required this.timeEnd,
    required this.title,
    this.teacher,
    required this.abbrType,
    required this.type,
    required this.location,
    required this.groups,
    this.sdoLink,
  });

  @override
  State<ScheduleClassCard> createState() => _ScheduleClassCardState();
}

class _ScheduleClassCardState extends State<ScheduleClassCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _lectureTime(textStyles),
          _scheduleSeparator(primaryColor),
          Expanded(child: _lectureInfo(textStyles)),
          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_drop_down)),
        ],
      ),
    );
  }

  Widget _lectureTime(AppTypography textStyles) {
    return Column(
      children: [
        Text(widget.timeStart, style: textStyles.timeBody),
        Text(widget.timeEnd, style: textStyles.timeBody),
      ],
    );
  }

  Widget _scheduleSeparator(Color color) {
    return SizedBox(
      height: 45,
      width: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: color,
        ),
      ),
    );
  }

  Widget _lectureInfo(AppTypography textStyles) {
    return _isExpanded
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: textStyles.subjectTitle),
            Text(widget.teacher ?? '—', style: textStyles.subjectSubtitle),
            Text(
              '${widget.location}, ${widget.abbrType}',
              style: textStyles.subjectSubtitle,
            ),
          ],
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              widget.title,
              style: textStyles.expandedSubjectTitle,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.type,
              style: textStyles.expandedSubjectSubtitle.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(widget.location, style: textStyles.expandedSubjectSubtitle),
            Text(
              widget.teacher ?? '—',
              style: textStyles.expandedSubjectSubtitle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.groups.join(', '),
              style: textStyles.expandedSubjectSubtitle,
            ),
            Text('Ссылка на СДО', style: textStyles.expandedSubjectSubtitle),
          ],
        );
  }

  Widget _buildCollapsedCard(BuildContext context, AppTextStyles textStyles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      key: const ValueKey('collapsed'),
      child: Row(
        children: [
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

// ScheduleClassCard
// -Padding
// -Row
// --Row
// ---Column
// ----Text: "12:00"
// ----Text: "13:40"
// ---SizedBox
// ----Container
// ---Column
// ----Text: "Алгоритмизация и программирование"
// ----Text: "Лекции"
// ----Text: " 11 к., 148 ауд."
// ----Text: "Щукин Александр Валентинович"
// ----Text: "5130903/50002, 5130903/5000…"
// ----Text: "Ссылка на СДО"
// --IconButton
// ---Iсon
