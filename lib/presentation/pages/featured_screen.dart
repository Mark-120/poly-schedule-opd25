import 'package:flutter/material.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _editMode = false;
  List<List<String>> _groupsData;
  List<List<String>> _originalData;

  final List<String> _pageTitles = ['Группы', 'Преподаватели', 'Аудитории'];

  _FeaturedScreenState()
    : _groupsData = [
        List.generate(15, (e) => '5130903/3000$e'),
        List.generate(4, (e) => 'Филимоненкова Надежда Викторовна'),
        List.generate(
          8,
          (e) =>
              e == 0
                  ? '132 ауд. 11 уч. корпус'
                  : '156 ауд. Гидротехнический уч. корпус',
        ),
      ],
      _originalData = [
        List.generate(15, (e) => '5130903/3000$e'),
        List.generate(4, (e) => 'Филимоненкова Надежда Викторовна'),
        List.generate(
          8,
          (e) =>
              e == 0
                  ? '132 ауд. 11 уч. корпус'
                  : '156 ауд. Гидротехнический уч. корпус',
        ),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _editMode = !_editMode;
      if (!_editMode) {
        // При выходе из режима редактирования сохраняем оригинальные данные
        _originalData = List<List<String>>.from(
          _groupsData.map((e) => List<String>.from(e)),
        );
      }
    });
  }

  void _saveChanges() {
    setState(() {
      _editMode = false;
      // Здесь можно добавить сохранение в базу данных
    });
  }

  void _deleteItem(int pageIndex, int index) {
    setState(() {
      _groupsData[pageIndex].removeAt(index);
    });
  }

  void _reorderItems(int pageIndex, int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _groupsData[pageIndex].removeAt(oldIndex);
      _groupsData[pageIndex].insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _featuredSection(0),
                _featuredSection(1),
                _featuredSection(2),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 57),
            child: FloatingActionButton(
              onPressed: _toggleEditMode,
              child: const Icon(Icons.edit_outlined, color: Colors.white),
              backgroundColor: Color(0xFF4FA24E),
              shape: CircleBorder(),
              elevation: 0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 56),
            child: _bottomIndicator(),
          ),
        ],
      ),
      // floatingActionButton:
      //     _editMode
      //         ? null
      //         : FloatingActionButton(
      //           onPressed: _toggleEditMode,
      //           child: const Icon(Icons.edit_outlined, color: Colors.white),
      //           backgroundColor: const Color(0xFF4FA24E),
      //           shape: const CircleBorder(),
      //           elevation: 0,
      //         ),
    );
  }

  Widget _featuredSection(int pageIndex) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 65),
          child: Column(
            children: [
              Text(
                _pageTitles[pageIndex],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  color: Color(0xFF244029),
                ),
              ),
              if (_editMode)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Режим редактирования',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                _editMode
                    ? ReorderableListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: _groupsData[pageIndex].length,
                      onReorder:
                          (oldIndex, newIndex) =>
                              _reorderItems(pageIndex, oldIndex, newIndex),
                      itemBuilder:
                          (context, index) => _editableCard(pageIndex, index),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _groupsData[pageIndex].length,
                      itemBuilder:
                          (_, index) =>
                              _featuredCard(_groupsData[pageIndex][index]),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _featuredCard(String groupName) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      color: const Color(0xFFCFE3CF),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              SizedBox(width: 16),
              Text(
                groupName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF244029),
                ),
              ),
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _editableCard(int pageIndex, int index) {
    return Row(
      key: Key('item_$index'),
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
            color: const Color(0xFFCFE3CF),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
              child: Row(
                children: [
                  // const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _groupsData[pageIndex][index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF244029),
                      ),
                    ),
                  ),
                  Image.asset('assets/icons/drag_icon.png'),
                  // const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF244029)),
          onPressed: () => _deleteItem(pageIndex, index),
        ),
      ],
    );
  }

  Widget _bottomIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 23),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentPage == index
                        ? Color(0xFF4FA24A)
                        : Color(0xFFACC3AC),
              ),
            ),
          );
        }),
      ),
    );
  }
}
