import 'package:flutter/material.dart';

Widget featuredCard(String featureName, {Function()? onTap, bool? isChosen}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 0,
    color: (isChosen ?? false) ? Color(0xFF4FA24A) : const Color(0xFFCFE3CF),
    child: InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                featureName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: (isChosen ?? false) ? Colors.white : Color(0xFF244029),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
