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

    return SingleChildScrollView(
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width ,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(toggleTitles.length, (index) {
              return GestureDetector(
                onTap: () {
                  onToggle(index);
                },
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.33,
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
      ),
    );
  }
}
