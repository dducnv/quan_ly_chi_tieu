import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/ui/pages/calculate_percentage/data/home_data.dart';
import 'package:quan_ly_chi_tieu/ui/pages/calculate_percentage/widgets/calcutate_percentage_card.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/feedback_button.dart';

class CalculatePercentagePage extends StatefulWidget {
  const CalculatePercentagePage({Key? key}) : super(key: key);

  @override
  CalculatePercentagePageState createState() => CalculatePercentagePageState();
}

class CalculatePercentagePageState extends State<CalculatePercentagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            backgroundColor: Colors.white,
            actions: const [
              FeedbackButton(),
            ],
            //55% of screen
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                child: const Center(
                    child: Text(
                  "Tính nhanh",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: calPercentMenuGroupByCategory.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CalcutatePercentageCard(
                    title: calPercentMenuGroupByCategory[index].name,
                    calPercentMenuList:
                        calPercentMenuGroupByCategory[index].listMenu);
              },
            ),
          ),
        ],
      ),
    );
  }
}
