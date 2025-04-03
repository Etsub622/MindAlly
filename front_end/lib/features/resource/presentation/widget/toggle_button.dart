import 'package:flutter/material.dart';

class CustomToggleButton extends StatefulWidget {
  final List<bool> isSelected;
  final Function(int) onToggle;

  const CustomToggleButton({
    super.key,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  @override
  State<CustomToggleButton> createState() => CustomToggleButtonState();
}

class CustomToggleButtonState extends State<CustomToggleButton>
    with SingleTickerProviderStateMixin {
  CustomToggleButtonState();

  final toggleTitles = ['Books', 'Videos', 'Articles'];
  late TabController _tabController;
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    isSelected = [true, false, false];

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == _tabController.index;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void handleToggle(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
    });
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: toggleTabs(),
          ),
        ),
      ),
    );
  }

  List<Widget> toggleTabs() {
    return List.generate(toggleTitles.length, (index) {
      return GestureDetector(
        onTap: () {
          handleToggle(index);
          widget.onToggle(index);
        },
        child: Center(
          child: SizedBox(
            height: 50,
            width: 110,
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
        ),
      );
    });
  }
}
