import 'package:flutter/material.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _pageTitles = ['Группы', 'Преподаватели', 'Аудитории'];
  final List<List<String>> _groupsData = [
    List.generate(15, (e) => '5130903/3000$e'),
    List.generate(4, (e) => 'Филимоненкова Надежда Викторовна'),
    List.generate(8, (e) => e == 0 ? '132 ауд. 11 уч. корпус' : '156 ауд. Гидротехнический уч. корпус'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
              onPressed: () {},
              child: const Icon(Icons.edit_outlined, color: Colors.white,),
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
    );
  }

  Widget _featuredSection(int pageIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 100),
                Text(
                  _pageTitles[pageIndex],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                    color: Color(0xFF244029),
                  ),
                ),
                SizedBox(height: 65),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => _featuredCard(_groupsData[pageIndex][index]),
              childCount: _groupsData[pageIndex].length,
            ),
          ),
        ],
      ),
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
              SizedBox(width: 16,),
              Text(groupName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF244029))),
            ],
          ),
        ),
        onTap: () {},
      )
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
                color: _currentPage == index ? Color(0xFF4FA24A) : Color(0xFFACC3AC),
              ),
            ),
          );
        }),
      ),
    );
  }
}
