import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/analytic_bloc/analytic_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/analytic_bloc/analytic_event.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:quan_ly_chi_tieu/ui/pages/analytics/components/trans_history_component.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/app_button_custom_widget.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/month_selector.dart';
import 'package:quan_ly_chi_tieu/ui/pages/analytics/widgets/trans_his_list.dart';

class TransactionsHistoryPage extends StatefulWidget {
  const TransactionsHistoryPage({Key? key}) : super(key: key);

  @override
  TransactionsHistoryPageState createState() => TransactionsHistoryPageState();
}

class TransactionsHistoryPageState extends State<TransactionsHistoryPage>
    with AutomaticKeepAliveClientMixin {
  int amountLoaded = DEFAULT_LIMIT;
  late PageController _pageController;
  bool showButtonToTop = false;

  late ScrollController _scrollController;
  String? searchTerm;
  List<dynamic> uniqueDatesTransactionsHistory = [];
  DateTime currentDateTime = DateTime.now();
  TextEditingController textController = TextEditingController();
  FocusNode focusNodeTextInput = FocusNode();
  GlobalKey<MonthSelectorState> monthSelectorStateKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1000000);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    context.read<AnalyticBloc>().add(TransactionPageToTopEvent(isShow: false));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (_scrollController.offset >= 200) {
      context.read<AnalyticBloc>().add(TransactionPageToTopEvent(isShow: true));
    } else {
      context
          .read<AnalyticBloc>()
          .add(TransactionPageToTopEvent(isShow: false));
    }
  }

  _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubicEmphasized);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 70,
        width: double.infinity,
        color: const Color(0xFFf3edf6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: AppButtonCustomWidget(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    constraints: const BoxConstraints(),
                    text: "",
                    child: const Center(
                        child: Icon(
                      Icons.arrow_left_outlined,
                      color: Colors.white,
                    )),
                    onPressed: () {
                      _pageController.animateToPage(
                        (_pageController.page ?? _pageController.initialPage)
                                .round() -
                            1,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutCubicEmphasized,
                      );
                    }),
              ),
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: AppButtonCustomWidget(
                color: const Color(0xFFff9f0a).withOpacity(0.6),
                constraints: const BoxConstraints(),
                text: "",
                child: const Center(
                    child: Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                )),
                onDoubleTap: () {
                  _scrollToTop();
                },
                onPressed: () {
                  if (monthSelectorStateKey.currentState?.pageOffset == 0) {
                    _scrollToTop();
                    return;
                  }
                  if (((_pageController.page ?? 0) -
                              0 -
                              _pageController.initialPage)
                          .abs() ==
                      1) {
                    _pageController.animateToPage(
                      _pageController.initialPage + 0,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOutCubicEmphasized,
                    );
                  } else {
                    _pageController.jumpToPage(
                      _pageController.initialPage + 0,
                    );
                  }
                  monthSelectorStateKey.currentState!.scrollTo(
                      -(MediaQuery.of(context).size.width) / 2 + 100 / 2);
                  monthSelectorStateKey.currentState?.setSelectedDateStart(
                      DateTime(DateTime.now().year, DateTime.now().month), 0);
                },
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 50,
                child: AppButtonCustomWidget(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    constraints: const BoxConstraints(),
                    text: "",
                    child: const Center(
                        child: Icon(
                      Icons.arrow_right_outlined,
                      color: Colors.white,
                    )),
                    onPressed: () {
                      _pageController.animateToPage(
                        (_pageController.page ?? _pageController.initialPage)
                                .round() +
                            1,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutCubicEmphasized,
                      );
                    }),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title:
            const Text("Danh sách giao dịch", style: TextStyle(fontSize: 20.0)),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              showPopupSearchTransHis();
            },
            icon: const Icon(Icons.search),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
              height: 50.0,
              width: double.infinity,
              color: Colors.white,
              child: MonthSelector(
                initDateNow: (DateTime currentDateTime, int index) {
                  DateTime startDate = DateTime(
                      DateTime.now().year, DateTime.now().month + index);
                  currentDateTime = startDate;
                  context.read<AnalyticBloc>().add(
                      GetUniqueDatesTransactionsHistoryEvent(
                          uniqueDates: startDate));
                },
                key: monthSelectorStateKey,
                setSelectedDateStart: (DateTime currentDateTime, int index) {
                  if (((_pageController.page ?? 0) -
                              index -
                              _pageController.initialPage)
                          .abs() ==
                      1) {
                    _pageController.animateToPage(
                      _pageController.initialPage + index,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOutCubicEmphasized,
                    );
                  } else {
                    _pageController.jumpToPage(
                      _pageController.initialPage + index,
                    );
                  }
                },
              )),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int index) {
                final int pageOffset = index - _pageController.initialPage;
                DateTime startDate = DateTime(
                    DateTime.now().year, DateTime.now().month + pageOffset);
                monthSelectorStateKey.currentState
                    ?.setSelectedDateStart(startDate, pageOffset);
                double middle =
                    -(MediaQuery.of(context).size.width) / 2 + 100 / 2;
                monthSelectorStateKey.currentState
                    ?.scrollTo(middle + (pageOffset - 1) * 100 + 100);
              },
              itemBuilder: (BuildContext context, int index) {
                final int pageOffset = index - _pageController.initialPage;
                DateTime startDate = DateTime(
                    DateTime.now().year, DateTime.now().month + pageOffset);
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: TransHisList(
                    scrollController: _scrollController,
                    startDate: startDate,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
