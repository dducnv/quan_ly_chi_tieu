import 'package:quan_ly_chi_tieu/models/calculate_percentage_menu_model.dart';
import 'package:quan_ly_chi_tieu/routes/route_path.dart';

//switch condition name
const String calculatePercentageOfANumber = "calculatePercentageOfANumber";
const String calculatePercentageBetweenTwoNumbers =
    "calculatePercentageBetweenTwoNumbers";
const String calculatePercentageIncreaseDecreaseOfANumber =
    "calculatePercentageIncreaseDecreaseOfANumber";

List<CaculatePercenMenuByCategory> calPercentMenuGroupByCategory = [
  CaculatePercenMenuByCategory(
    name: "Tính phần trăm",
    listMenu: calPercentMenuList,
  ),
];

List<CaculatePercenMenuModel> calPercentMenuList = [
  CaculatePercenMenuModel(
    name: "Tính % của một số",
    recipe: "Công thức: a * x / 100",
    routeName: RoutePaths.calculatePercentageOfANumber,
  ),
  CaculatePercenMenuModel(
    name: "Tính % giữa hai số",
    recipe: "Công thức: (x * 100) / a",
    routeName: calculatePercentageBetweenTwoNumbers,
  ),
  CaculatePercenMenuModel(
    name: "Tính % tăng hoặc giảm của một số",
    recipe: "Công thức: a +|- (a * x / 100)",
    routeName: calculatePercentageIncreaseDecreaseOfANumber,
  ),
];
