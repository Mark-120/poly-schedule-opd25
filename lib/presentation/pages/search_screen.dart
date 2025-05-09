import 'package:flutter/material.dart';

import '../../presentation/widgets/featured_card.dart';

class SearchScreen extends StatefulWidget {
  final SearchScreenType searchScreenType;
  const SearchScreen({super.key, required this.searchScreenType});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  late final List<String> _allFeatured;
  int _chosenIndex = 0;
  bool _isChosen = false;

  @override
  void initState() {
    super.initState();
    _allFeatured = _getFeaturedListByType(widget.searchScreenType);
  }

  void _performSearch(String query) {
    setState(() {
      _searchResults =
          _allFeatured
              .where(
                (featured) =>
                    featured.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      _isChosen = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              _getStringByType(
                widget.searchScreenType,
                groupString: 'Поиск группы',
                teacherString: 'Поиск преподавателя',
              ),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: Color(0xFF244029),
              ),
            ),
            const SizedBox(height: 65),
            _buildSearchField(),
            const SizedBox(height: 20),
            Expanded(child: _buildSearchResults()),
          ],
        ),
      ),
      floatingActionButton:
          _isChosen
              ? FloatingActionButton(
                onPressed: () {},
                backgroundColor: const Color(0xFF4FA24E),
                shape: const CircleBorder(),
                elevation: 0,
                child: const Icon(Icons.done, color: Colors.white, size: 40),
              )
              : null,
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF244029), width: 2),
      ),
      child: SizedBox(
        height: 40,
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          controller: _searchController,
          onChanged: _performSearch,
          cursorColor: Color(0xFF244029),
          selectionControls: materialTextSelectionHandleControls,
          decoration: InputDecoration(
            hintText: _getStringByType(
              widget.searchScreenType,
              groupString: 'Введите номер группы...',
              teacherString: 'Введите ФИО преподавателя...',
            ),
            hintStyle: TextStyle(color: Color(0xFF5F5F5F)),
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            prefixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: Color(0xFF244029),
                size: 24,
              ),
              onPressed: () => _performSearch(_searchController.text),
            ),
          ),
          style: const TextStyle(color: Color(0xFF336633)),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return const Center(
        child: Text(
          'Введите запрос для поиска',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          'По запросу "${_searchController.text}" ничего не найдено',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return featuredCard(
          _searchResults[index],
          context,
          isChosen: index == _chosenIndex && _isChosen,
          onTap: () {
            setState(() {
              _chosenIndex = index;
              _isChosen = true;
            });
          },
        );
      },
    );
  }

  List<String> _getFeaturedListByType(SearchScreenType searchScreenType) {
    switch (searchScreenType) {
      case SearchScreenType.groups:
        return [
          '5130903/30001',
          '5130903/30002',
          '5130903/30003',
          '5130904/30001',
          '5130904/30002',
          '5130905/30001',
        ];
      case SearchScreenType.teachers:
        return [
          'Филимоненкова Надежда Викторовна',
          'Щукин Александр Валентинович',
          'Пак Вадим Геннадьевич',
          'Андрианова Екатерина Евгеньевна',
          'Хитров Егор Германович',
          'Бышук Галина Владимировна',
        ];
    }
  }

  String _getStringByType(
    SearchScreenType searchScreenType, {
    required String groupString,
    required String teacherString,
  }) {
    switch (searchScreenType) {
      case SearchScreenType.groups:
        return groupString;
      case SearchScreenType.teachers:
        return teacherString;
    }
  }
}

enum SearchScreenType { groups, teachers }
