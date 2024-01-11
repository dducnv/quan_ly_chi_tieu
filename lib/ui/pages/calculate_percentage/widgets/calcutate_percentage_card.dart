import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/models/calculate_percentage_menu_model.dart';
import 'package:quan_ly_chi_tieu/routes/route_path.dart';

class CalcutatePercentageCard extends StatelessWidget {
  final String title;
  final List<CaculatePercenMenuModel> calPercentMenuList;
  const CalcutatePercentageCard(
      {Key? key, required this.title, required this.calPercentMenuList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              itemCount: calPercentMenuList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        calPercentMenuList[index].routeName,
                      );
                    },
                    title: Text(calPercentMenuList[index].name),
                    subtitle: Text(calPercentMenuList[index].recipe),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
