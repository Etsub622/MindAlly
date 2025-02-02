import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomToggleButton extends StatelessWidget {
  final List<bool> isSelected;
  final Function(int) onToggle;

  const CustomToggleButton({
    super.key,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final toggleTitles = ['Books', 'Videos', 'Articles'];

    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(toggleTitles.length, (index) {
            return GestureDetector(
              onTap: () {
                onToggle(index);
              },
              child: SizedBox(
                height: 60,
                width: 150,
                child: Card(
                  color: isSelected[index] ? Color(0xff08E0EEA) : Colors.white,
                  elevation: 7,
                  child: Center(
                    child: Text(
                      toggleTitles[index],
                      style: TextStyle(
                        color: isSelected[index] ? Colors.white : Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
