import 'package:flutter/material.dart';

Widget classCard(
  String timeStart,
  String timeEnd,
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
              '$timeStart - $timeEnd',
              style: const TextStyle(
                color: Color(0xFF244029),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              location,
              style: const TextStyle(
                color: Color(0xFF244029),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      Card(
        color: Color(0xFFACC3AC),
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF244029),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(height: 6),
                    Text(
                      teacher,
                      style: const TextStyle(
                        color: Color(0xFF5F7863),
                        fontSize: 12,
                        height: 1,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(type, style: const TextStyle(color: Color(0xFF505050))),
                  IconButton(
                    icon: const Icon(
                      Icons.expand_more,
                      color: Color(0xFF244029),
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
