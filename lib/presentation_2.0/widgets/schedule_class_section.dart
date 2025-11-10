import 'package:flutter/material.dart';

import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../domain/entities/schedule/lesson.dart';

class ScheduleClassSection extends StatefulWidget {
  final Lesson lesson;
  const ScheduleClassSection({super.key, required this.lesson});

  @override
  State<ScheduleClassSection> createState() => _ScheduleClassSectionState();
}

class _ScheduleClassSectionState extends State<ScheduleClassSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final lesson = widget.lesson;
    final teachers = lesson.teachers
        .map((teacher) => teacher.fullName)
        .join(', ');
    final auditories = lesson.auditories
        .map((room) => '${room.building.abbr}, ${room.name} ауд.')
        .join(';');
    final lessonType = lesson.type;
    final type = lesson.type;
    final groups = lesson.groups.map((e) => e.name).toList();
    final timeStart = lesson.start;
    final timeEnd = lesson.end;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
      child: InkWell(
        onTap:
            () => setState(() {
              _isExpanded = !_isExpanded;
            }),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _LectureTime(timeStart, timeEnd),
              _buildScheduleSeparator(primaryColor),
              Expanded(
                child: _LectureInfo(
                  title: lesson.subject,
                  type: type,
                  location: auditories,
                  groups: groups,
                  lessonType: lessonType,
                  isExpanded: _isExpanded,
                  teachers: teachers,
                ),
              ),
              _buildArrowIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleSeparator(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 45,
        width: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildArrowIcon() {
    return Column(
      mainAxisAlignment:
          _isExpanded ? MainAxisAlignment.end : MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          icon:
              _isExpanded
                  ? Icon(Icons.arrow_drop_up)
                  : Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }
}

class _LectureTime extends StatelessWidget {
  final String timeStart;
  final String timeEnd;
  const _LectureTime(this.timeStart, this.timeEnd);

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;

    return Column(
      children: [
        Text(timeStart, style: textStyles.timeBody),
        Text(timeEnd, style: textStyles.timeBody),
      ],
    );
  }
}

class _LectureInfo extends StatelessWidget {
  final bool _isExpanded;
  final String title;
  final String type;
  final String location;
  final String? teachers;
  final List<String> groups;
  final String lessonType;

  const _LectureInfo({
    required this.title,
    required this.type,
    required this.location,
    this.teachers,
    required this.groups,
    required this.lessonType,
    required isExpanded,
  }) : _isExpanded = isExpanded;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;

    return _isExpanded
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text(title, style: textStyles.expandedSubjectTitle),
            Text(
              type,
              style: textStyles.expandedSubjectSubtitle.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(location, style: textStyles.expandedSubjectSubtitle),
            Text(
              teachers ?? '—',
              style: textStyles.expandedSubjectSubtitle.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(groups.join(', '), style: textStyles.expandedSubjectSubtitle),
            Text('Ссылка на СДО', style: textStyles.expandedSubjectSubtitle),
          ],
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            Text(title, style: textStyles.subjectTitle),
            Text(teachers ?? '—', style: textStyles.subjectSubtitle),
            Text('$location, $lessonType', style: textStyles.subjectSubtitle),
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
