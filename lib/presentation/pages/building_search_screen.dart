import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/presentation/uikit/app_strings.dart';
import '../../core/presentation/uikit/app_text_styles.dart';
import '../../core/presentation/uikit/theme_extension.dart';
import '../../domain/entities/room.dart';
import '../../service_locator.dart';
import '../state_managers/building_search_screen_bloc/building_search_bloc.dart';
import '../widgets/featured_card.dart';
import 'class_search_screen.dart';

class BuildingSearchScreen extends StatefulWidget {
  static const route = '/buildingSearch';

  final Function(Room) onSaveRoom;
  const BuildingSearchScreen({super.key, required this.onSaveRoom});

  @override
  State<BuildingSearchScreen> createState() => _BuildingSearchScreenState();
}

class _BuildingSearchScreenState extends State<BuildingSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    return BlocProvider(
      create: (context) => sl<BuildingSearchBloc>()..add(LoadBuildings()),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(AppStrings.buildingSearchTitle, style: textStyles.title),
              const SizedBox(height: 65),
              Expanded(child: _buildSearchResults()),
              Padding(
                padding: EdgeInsets.only(top: 88, bottom: 112),
                child: Text(
                  AppStrings.firstPage,
                  style: textStyles.noInfoMessage,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton:
            BlocBuilder<BuildingSearchBloc, BuildingSearchState>(
              builder: (context, state) {
                if (state is BuildingSearchLoaded &&
                    state.selectedBuilding != null) {
                  return FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        ClassSearchScreen.route,
                        arguments: ClassSearchScreenArguments(
                          buildingId: state.selectedBuilding!.id,
                          onSaveRoom: widget.onSaveRoom,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.arrow_right_alt,
                      color: context.appTheme.iconColor,
                      size: 40,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<BuildingSearchBloc, BuildingSearchState>(
      builder: (context, state) {
        if (state is BuildingSearchInitial) {
          return const SizedBox.shrink();
        } else if (state is BuildingSearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BuildingSearchError) {
          return Center(child: Text(state.message));
        } else if (state is BuildingSearchLoaded) {
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: state.buildings.length,
            itemBuilder: (context, index) {
              final building = state.buildings[index];
              return FeaturedCard(
                building.name,
                isChosen: building == state.selectedBuilding,
                onTap: () {
                  context.read<BuildingSearchBloc>().add(
                    BuildingSelected(building),
                  );
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class BuildingSearchScreenArguments {
  final Function(Room) onSaveRoom;
  const BuildingSearchScreenArguments({required this.onSaveRoom});
}
