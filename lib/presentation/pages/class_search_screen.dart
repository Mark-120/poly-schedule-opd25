import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poly_scheduler/presentation/state_managers/class_search_screen_bloc/class_search_bloc.dart';

import '../../core/presentation/uikit/app_text_styles.dart';
import '../../core/presentation/uikit/theme_extension.dart';
import '../../core/presentation/uikit/app_strings.dart';
import '../../domain/entities/room.dart';
import '../../service_locator.dart';
import '../widgets/featured_card.dart';
import 'schedule_screen.dart';

class ClassSearchScreen extends StatefulWidget {
  final int buildingId;
  final Function(Room) onSaveRoom;

  const ClassSearchScreen({
    super.key,
    required this.buildingId,
    required this.onSaveRoom,
  });

  @override
  State<ClassSearchScreen> createState() => _ClassSearchScreenState();
}

class _ClassSearchScreenState extends State<ClassSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    return BlocProvider(
      create:
          (context) =>
              ClassSearchBloc(getRoomsOfBuilding: sl(), addFeaturedRoom: sl())
                ..add(LoadRoomsForBuilding(widget.buildingId)),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(AppStrings.classSearchTitle, style: textStyles.title),
              const SizedBox(height: 65),
              Expanded(child: _buildSearchResults(context)),
              Padding(
                padding: EdgeInsets.only(top: 88, bottom: 112),
                child: Text(
                  AppStrings.secondPage,
                  style: textStyles.noInfoMessage,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<ClassSearchBloc, ClassSearchState>(
          builder: (context, state) {
            return state is ClassSearchLoaded && state.selectedRoom != null
                ? FloatingActionButton(
                  onPressed: () {
                    context.read<ClassSearchBloc>().add(
                      SaveSelectedRoomToFeatured(),
                    );
                    widget.onSaveRoom(state.selectedRoom!);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (e) => ScheduleScreen.room(
                              roomId: state.selectedRoom!.getId(),
                              dayTime: DateTime.now(),
                              bottomTitle: AppStrings.fullNameOfRoom(
                                state.selectedRoom!,
                              ),
                            ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.done,
                    color: context.appTheme.iconColor,
                    size: 40,
                  ),
                )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return BlocBuilder<ClassSearchBloc, ClassSearchState>(
      builder: (context, state) {
        if (state is ClassSearchInitial) {
          return const SizedBox.shrink();
        } else if (state is ClassSearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClassSearchError) {
          return Center(child: Text(state.message));
        } else if (state is ClassSearchLoaded) {
          return ListView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            children:
                state.rooms.map((room) {
                  return featuredCard(
                    context,
                    room.name,
                    isChosen: room == state.selectedRoom,
                    isCenterText: true,
                    onTap: () {
                      context.read<ClassSearchBloc>().add(RoomSelected(room));
                    },
                  );
                }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
