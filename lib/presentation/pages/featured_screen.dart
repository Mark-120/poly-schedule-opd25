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
  final List<List<String>> _featuredData;

  final List<String> _pageTitles = ['Группы', 'Преподаватели', 'Аудитории'];

  _FeaturedScreenState()
    : _featuredData = [
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
    });
  }

  void _deleteItem(int pageIndex, int index) {
    setState(() {
      _featuredData[pageIndex].removeAt(index);
    });
  }

  void _reorderItems(int pageIndex, int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _featuredData[pageIndex].removeAt(oldIndex);
      _featuredData[pageIndex].insert(newIndex, item);
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
              physics:
                  _editMode
                      ? const NeverScrollableScrollPhysics()
                      : const PageScrollPhysics(),
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child:
                _editMode
                    ? Padding(
                      key: ValueKey('add_button'),
                      padding: const EdgeInsets.only(top: 57),
                      child: FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: Color(0xFF4FA24E),
                        shape: CircleBorder(),
                        elevation: 0,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    )
                    : Padding(
                      key: ValueKey('edit_button'),
                      padding: const EdgeInsets.only(top: 57),
                      child: FloatingActionButton(
                        onPressed: _toggleEditMode,
                        backgroundColor: Color(0xFF4FA24E),
                        shape: CircleBorder(),
                        elevation: 0,
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
          ),
          AnimatedOpacity(
            opacity: _editMode ? 0.0 : 1.0,
            duration: Duration(milliseconds: 500),
            child: Padding(
              key: ValueKey('page_routing_dots'),
              padding: EdgeInsets.symmetric(vertical: 56),
              child: _bottomIndicator(),
            ),
          ),
        ],
      ),
      floatingActionButton:
          _editMode
              ? FloatingActionButton(
                onPressed: _toggleEditMode,
                backgroundColor: const Color(0xFF4FA24E),
                shape: const CircleBorder(),
                elevation: 0,
                child: const Icon(Icons.done, color: Colors.white, size: 40),
              )
              : null,
    );
  }

  Widget _featuredSection(int pageIndex) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 36),
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
              AnimatedOpacity(
                key: ValueKey('edit_title'),
                opacity: _editMode ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    'режим изменения',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5F5F5F),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child:
                  _editMode
                      ? ReorderableListView.builder(
                        key: ValueKey('reorder_list'),
                        physics: const ClampingScrollPhysics(),
                        itemCount: _featuredData[pageIndex].length,
                        onReorder:
                            (oldIndex, newIndex) =>
                                _reorderItems(pageIndex, oldIndex, newIndex),
                        itemBuilder:
                            (context, index) => _editableCard(pageIndex, index),
                      )
                      : ListView.builder(
                        key: ValueKey('choose_list'),
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        itemCount: _featuredData[pageIndex].length,
                        itemBuilder:
                            (_, index) =>
                                _featuredCard(_featuredData[pageIndex][index]),
                      ),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                  Expanded(
                    child: Text(
                      _featuredData[pageIndex][index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF244029),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Image.asset('assets/icons/drag_icon.png'),
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
                duration: const Duration(milliseconds: 500),
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
