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
    final toggleTitles = ['Articles', 'Videos', 'Books'];

    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(toggleTitles.length, (index) {
            return GestureDetector(
              onTap: () {
                onToggle(index);
              },
              child: SizedBox(
                height: 50,
                width: 110,
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Center(
                    child: Text(
                      toggleTitles[index],
                      style: TextStyle(
                        color: isSelected[index]
                            ? const Color(0xff08E0EEA)
                            : Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
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
