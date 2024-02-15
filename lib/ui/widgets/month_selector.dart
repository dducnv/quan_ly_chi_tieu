import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/utils/function.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/multi_directional_infinite_scroll.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/tappable.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';

class MonthSelector extends StatefulWidget {
  const MonthSelector(
      {Key? key, required this.setSelectedDateStart, required this.initDateNow})
      : super(key: key);
  final Function(DateTime, int) setSelectedDateStart;
  final Function(DateTime, int) initDateNow;
  @override
  State<MonthSelector> createState() => MonthSelectorState();
}

class MonthSelectorState extends State<MonthSelector> {
  DateTime selectedDateStart = DateTime.now();
  int pageOffset = 0;
  bool showScrollBottom = false;
  bool showScrollTop = false;

  GlobalKey<MultiDirectionalInfiniteScrollState>
      MultiDirectionalInfiniteScrollKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.initDateNow(selectedDateStart, pageOffset);
    });
  }

  scrollTo(double position) {
    MultiDirectionalInfiniteScrollKey.currentState!
        .scrollTo(const Duration(milliseconds: 700), position: position);
  }

  setSelectedDateStart(DateTime dateTime, int offset) {
    setState(() {
      selectedDateStart = dateTime;
      pageOffset = offset;
    });
  }

  _onScroll(double position) {
    const upperBound = 200;
    final lowerBound = -200 - MediaQuery.of(context).size.width / 2 - 100;
    if (position > upperBound) {
      if (showScrollBottom == false) {
        setState(() {
          showScrollBottom = true;
        });
      }
    } else if (position < lowerBound) {
      if (showScrollTop == false) {
        setState(() {
          showScrollTop = true;
        });
      }
    }
    if (position > lowerBound && position < upperBound) {
      if (showScrollTop == true) {
        setState(() {
          showScrollTop = false;
        });
      }
      if (showScrollBottom == true) {
        setState(() {
          showScrollBottom = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MultiDirectionalInfiniteScroll(
          key: MultiDirectionalInfiniteScrollKey,
          onScroll: (position) {
            _onScroll(position);
          },
          height: 50,
          overBoundsDetection: 50,
          initialItems: 10,
          startingScrollPosition:
              -(MediaQuery.of(context).size.width / 2 + 100) / 2,
          duration: const Duration(milliseconds: 1500),
          itemBuilder: (index) {
            DateTime currentDateTime =
                DateTime(DateTime.now().year, DateTime.now().month + index);
            bool isSelected =
                selectedDateStart.month == currentDateTime.month &&
                    selectedDateStart.year == currentDateTime.year;
            bool isToday = currentDateTime.month == DateTime.now().month &&
                currentDateTime.year == DateTime.now().year;
            return Container(
              color: Theme.of(context).colorScheme.background,
              child: Stack(
                children: [
                  SizedBox(
                    height: 50,
                    child: Tappable(
                      onTap: () {
                        widget.setSelectedDateStart(currentDateTime, index);
                      },
                      borderRadius: 10,
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        width: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isSelected
                                  ? TextFont(
                                      key: const ValueKey(1),
                                      fontSize: 14,
                                      text: getMonth(currentDateTime.month - 1),
                                      textColor: Colors.black,
                                      fontWeight: isToday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    )
                                  : TextFont(
                                      key: const ValueKey(2),
                                      fontSize: 14,
                                      text: getMonth(currentDateTime.month - 1),
                                      textColor: Colors.grey,
                                      fontWeight: isToday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                            DateTime.now().year != currentDateTime.year
                                ? AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: isSelected
                                        ? TextFont(
                                            key: const ValueKey(1),
                                            fontSize: 9,
                                            text:
                                                currentDateTime.year.toString(),
                                            textColor: Colors.black,
                                          )
                                        : TextFont(
                                            key: const ValueKey(2),
                                            fontSize: 9,
                                            text:
                                                currentDateTime.year.toString(),
                                            textColor: Colors.black,
                                          ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  isToday && !isSelected
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            width: 100,
                            child: Center(
                              heightFactor: 0.5,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(40),
                                    topLeft: Radius.circular(40),
                                  ),
                                  color: Colors.grey,
                                ),
                                width: 75,
                                height: 7,
                              ),
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 500),
                            scale: isSelected ? 1 : 0,
                            curve: isSelected
                                ? Curves.decelerate
                                : Curves.easeOutQuart,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  topLeft: Radius.circular(40),
                                ),
                                color: Colors.black,
                              ),
                              width: 100,
                              height: 4,
                            ),
                          ),
                        ),
                  //button line
                ],
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedScale(
            scale: showScrollBottom ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            alignment: Alignment.centerLeft,
            curve: Curves.fastOutSlowIn,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 2),
              child: Tappable(
                borderRadius: 10,
                color: Theme.of(context).colorScheme.primary,
                onTap: () {
                  MultiDirectionalInfiniteScrollKey.currentState!
                      .scrollTo(const Duration(milliseconds: 700));
                  widget.setSelectedDateStart(
                      DateTime(DateTime.now().year, DateTime.now().month), 0);
                },
                child: SizedBox(
                  width: 44,
                  height: 34,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Icon(
                      Icons.arrow_left_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedScale(
            scale: showScrollTop ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            alignment: Alignment.centerRight,
            curve: Curves.fastOutSlowIn,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, right: 2),
              child: Tappable(
                borderRadius: 10,
                color: Theme.of(context).colorScheme.primary,
                onTap: () {
                  MultiDirectionalInfiniteScrollKey.currentState!
                      .scrollTo(const Duration(milliseconds: 700));
                  widget.setSelectedDateStart(
                      DateTime(DateTime.now().year, DateTime.now().month), 0);
                },
                child: SizedBox(
                  width: 44,
                  height: 34,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Icon(Icons.arrow_right_outlined,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
