import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key, required this.onChanged})
      : super(key: key);
  final Function(int) onChanged;
  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    if (index == selectedIndex) {
      // if (index == 0) homePageStateKey.currentState?.scrollToTop();
      // if (index == 1) transactionsListPageStateKey.currentState?.scrollToTop();
      // if (index == 2) budgetsListPageStateKey.currentState?.scrollToTop();
      // if (index == 3) settingsPageStateKey.currentState?.scrollToTop();
    } else {
      widget.onChanged(index);
      setState(() {
        selectedIndex = index;
      });
    }
    FocusScope.of(context).unfocus(); //remove keyboard focus on any input boxes
  }

  void setSelectedIndex(index) {
    setState(() {
      selectedIndex = index;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      animationDuration: const Duration(milliseconds: 1000),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.payments_rounded),
          label: "Quản lý chi tiêu",
          tooltip: "",
        ),
        NavigationDestination(
          icon: Icon(Icons.swap_horiz_outlined, size: 20),
          label: "Chuyển đổi tiền tệ",
          tooltip: "",
        ),
        NavigationDestination(
          icon: Icon(Icons.calculate_outlined, size: 20),
          label: "Tính nhanh",
          tooltip: "",
        ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemTapped,
    );
  }
}
