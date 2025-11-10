import 'package:flutter/material.dart';

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

  // Future<void> _copySdoLink() async {
  //   if (widget.sdoLink == null || widget.sdoLink!.isEmpty) return;

  //   await Clipboard.setData(ClipboardData(text: widget.sdoLink!));

  //   if (mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Ссылка скопирована в буфер обмена'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   }
  // }
}
