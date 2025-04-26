import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4FA24E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {},
        ),
        title: Column(
          children: [
            const Text(
              '07.04 - 13.04',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('четная', style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDaySection('7 апреля', 'Понедельник', [
            _buildClassCard(
              '8:00 - 9:40',
              'Иностранный язык. Профессионально-ориентированный курс',
              'Филимоненская Надежда Викторовна',
              'Лекция',
              '12:3 буд. 11 уч.к.',
            ),
            _buildClassCard(
              '10:00 - 11:40',
              'Элективная физическая культура и спорт',
              'Филимоненская Надежда Викторовна',
              'Практика',
              '12:3 буд. 11 уч.к.',
            ),
            // Добавьте остальные карточки по аналогии
          ]),
          const SizedBox(height: 24),
          _buildDaySection('8 апреля', 'Вторник', [
            _buildClassCard(
              '8:00 - 9:40',
              'Иностранный язык. Профессионально-ориентированный курс',
              'Филимоненская Надежда Викторовна',
              'Лекция',
              '12:3 буд. 11 уч.к.',
            ),
            // Добавьте остальные карточки
          ]),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF4FA24E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
              iconSize: 28,
              onPressed: () {},
            ),
            const Text(
              '5130903/30003',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            IconButton(
              icon: const Icon(Icons.star_outline_outlined, color: Colors.white),
              iconSize: 28,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySection(String date, String day, List<Widget> classes) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xFFCFE3CF),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Color(0xFF244029),
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                day,
                style: const TextStyle(color: Color(0xFF5F7863), fontSize: 20),
              ),
            ],
          ),

          const SizedBox(height: 10),
          ...classes,
        ],
      ),
    );
  }

  Widget _buildClassCard(
    String time,
    String title,
    String teacher,
    String type,
    String location,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Color(0xFF388E3C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                location,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                      Text(
                        teacher,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        softWrap: true,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(color: Color(0xFF4CAF50)),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.expand_more,
                        color: Color(0xFF4CAF50),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
