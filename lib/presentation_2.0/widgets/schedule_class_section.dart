import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/configs/assets/app_vectors.dart';
import '../../core/presentation/navigation/scaffold_ui_state/global_navigation_ontroller.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../core/presentation/uikit_2.0/theme_colors.dart';
import '../../domain/entities/entity.dart';
import '../../domain/entities/featured.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/schedule/lesson.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/usecases/featured_usecases/is_featured.dart';
import '../../service_locator.dart';
import '../pages/schedule_page.dart';

class ScheduleClassSection extends StatefulWidget {
  final Lesson lesson;
  const ScheduleClassSection({super.key, required this.lesson});

  @override
  State<ScheduleClassSection> createState() => _ScheduleClassSectionState();
}

class _ScheduleClassSectionState extends State<ScheduleClassSection>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      upperBound: 0.5,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final lesson = widget.lesson;
    final teachers =
        lesson.teachers.isNotEmpty
            ? lesson.teachers.map((teacher) => teacher.fullName).join(', ')
            : null;
    final auditories = lesson.auditories
        .map((room) => '${room.building.abbr}, ${room.name} ауд.')
        .join(';');
    final lessonType = lesson.type;
    final type = lesson.type;
    final groups = lesson.groups.map((e) => e.name).toList();
    final timeStart = lesson.start;
    final timeEnd = lesson.end;

    return InkWell(
      onTap: _onClassTap,
      overlayColor: WidgetStateProperty.all(Colors.transparent),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
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
                  teachersList: lesson.teachers,
                  groupsList: lesson.groups,
                  auditoriesList: lesson.auditories,
                  onNavigateToEntity: _navigateToEntity,
                ),
              ),
              _buildArrowIcon(),
            ],
          ),
        ),
      ),
    );
  }

  void _onClassTap() {
    setState(() {
      if (_isExpanded) {
        _controller.reverse(from: 0.5);
      } else {
        _controller.forward(from: 0.0);
      }
      _isExpanded = !_isExpanded;
    });
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
        RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: SvgPicture.asset(
            AppVectors.arrowDropDown,
            colorFilter: ColorFilter.mode(
              Theme.of(context).extension<ThemeColors>()!.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _navigateToEntity(Entity entity) async {
    if (entity is ScheduleEntity) {
      final isSavedInFeatured = sl<IsSavedInFeatured>();
      final entityId = entity.getId();
      final isFeatured = await isSavedInFeatured(entityId);

      final featured = _createFeaturedFromEntity(entity, isFeatured);

      final route = MaterialPageRoute(
        builder: (_) {
          return SchedulePage(dayTime: DateTime.now(), featured: featured);
        },
      );

      // ignore: use_build_context_synchronously
      await context.read<GlobalNavigationController>().pushToTab(0, route);
    }
  }

  Featured<Entity> _createFeaturedFromEntity(Entity entity, bool isFeatured) {
    if (entity is Group) return Featured<Group>(entity, isFeatured: isFeatured);
    if (entity is Teacher) {
      return Featured<Teacher>(entity, isFeatured: isFeatured);
    }
    if (entity is Room) return Featured<Room>(entity, isFeatured: isFeatured);
    throw UnimplementedError();
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
  final List<Teacher> teachersList;
  final List<Group> groupsList;
  final List<Room> auditoriesList;
  final Function(Entity) onNavigateToEntity;

  const _LectureInfo({
    required this.title,
    required this.type,
    required this.location,
    this.teachers,
    required this.groups,
    required this.lessonType,
    required isExpanded,
    required this.teachersList,
    required this.groupsList,
    required this.auditoriesList,
    required this.onNavigateToEntity,
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
            _buildClickableAuditories(textStyles),
            _buildClickableTeachers(textStyles),
            _buildClickableGroups(textStyles),
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

  Widget _buildClickableAuditories(AppTypography textStyles) {
    if (auditoriesList.isEmpty) {
      return Text(location, style: textStyles.expandedSubjectSubtitle);
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children:
          auditoriesList.map((room) {
            final roomText = '${room.building.abbr}, ${room.name} ауд.';
            return GestureDetector(
              onTap: () => onNavigateToEntity(room),
              child: Text(
                roomText,
                style: textStyles.expandedSubjectSubtitle.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildClickableTeachers(AppTypography textStyles) {
    if (teachersList.isEmpty) {
      return Text(
        '—',
        style: textStyles.expandedSubjectSubtitle.copyWith(
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children:
          teachersList.map((teacher) {
            return GestureDetector(
              onTap: () => onNavigateToEntity(teacher),
              child: Text(
                teacher.fullName,
                style: textStyles.expandedSubjectSubtitle.copyWith(
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildClickableGroups(AppTypography textStyles) {
    if (groupsList.isEmpty) {
      return SizedBox.shrink();
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children:
          groupsList.map((group) {
            return GestureDetector(
              onTap: () => onNavigateToEntity(group),
              child: Text(
                group.name,
                style: textStyles.expandedSubjectSubtitle.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            );
          }).toList(),
    );
  }
}
