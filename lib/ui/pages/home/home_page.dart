import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/utils/debug.dart';
import 'package:quan_ly_chi_tieu/routes/route_path.dart';
import 'package:quan_ly_chi_tieu/ui/pages/home/components/home_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  double maxWidth = 370;
  late TextEditingController textController;
  late TextEditingController textAddCategoryController;
  FocusNode focusNodeTextInput = FocusNode();
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textAddCategoryController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    textAddCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Debug.logMessage(message: "HomePageState build");
    return Scaffold(
      appBar: AppBar(
        title: balanceShowAppbar(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RoutePaths.settingScreen);
            },
            icon: const Icon(Icons.settings_rounded),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(children: [
              const Spacer(),
              amountRemainingWidget(),
              const Spacer(),
              amountEnteredWidget(),
              // transactionNameFieldWidget,
              const SizedBox(height: 10),
              funcTopButtonWidgets(),
              numberButtonWidgetsTopWidget(),
              numberButtonWidgetsBottomWidget(),
            ]),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BottomClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      0.0,
      size.height - 250,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
