import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_event.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_state.dart';
import 'package:quan_ly_chi_tieu/resource/enum.dart';
import 'package:quan_ly_chi_tieu/ui/pages/setting/setting_page.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';

extension SettingComponent on SettingPageState {
  Future<dynamic> popupAddCategory() {
    TransactionType typeOfTransactionSelected = TransactionType.income;
    return AppPopUp.showPopup(
      title: "Thêm danh mục",
      context: context,
      onPressedSelect: () {
        if (textAddCategoryController.text.isEmpty) {
          AppPopUp.showPopup(
              context: context,
              isShowButtonSelect: false,
              textCancel: "Đã hiểu",
              childMessage: const Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFont(
                  text: "Bạn chưa nhập tên danh mục",
                  fontSize: 16,
                ),
              ));
          return;
        }
        context.read<HomeBloc>().add(SaveCategoryTransactionEvent(
              name: textAddCategoryController.text,
              type: typeOfTransactionSelected.name,
            ));
        textAddCategoryController.text = "";
        Navigator.pop(context);
      },
      textSelect: "Thêm",
      childMessage: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textAddCategoryController,
              maxLength: 60,
              scrollPadding: const EdgeInsets.all(10),
              autofocus: true,
              onSubmitted: (value) {
                if (textAddCategoryController.text.isEmpty) {
                  AppPopUp.showPopup(
                      context: context,
                      isShowButtonSelect: false,
                      textCancel: "Đã hiểu",
                      childMessage: const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFont(
                          text: "Bạn chưa nhập tên danh mục",
                          fontSize: 16,
                        ),
                      ));
                  return;
                }
                context.read<HomeBloc>().add(SaveCategoryTransactionEvent(
                      name: textAddCategoryController.text,
                      type: typeOfTransactionSelected.name,
                    ));
                textAddCategoryController.text = "";
                Navigator.pop(context);
              },
              decoration: InputDecoration(
                hintText: "Tên giao dịch",
                counterText: "",
                hintStyle: TextStyle(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text("Chọn kiểu danh mục",
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<HomeBloc, BaseState>(
              buildWhen: (previous, current) =>
                  current is SelectTypeOfCategoryState,
              builder: (context, state) {
                if (state is SelectTypeOfCategoryState) {
                  typeOfTransactionSelected = state.value;
                }
                return Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        context.read<HomeBloc>().add(
                            SelectTypeOfCategoryEvent(TransactionType.income));
                      },
                      child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                              border: typeOfTransactionSelected ==
                                      TransactionType.income
                                  ? Border.all(
                                      color: const Color(0xFF329932), width: 1)
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFF329932).withOpacity(0.2)),
                          child: const Center(
                              child: Center(
                            child: Text(
                              "Thu nhập",
                              style: TextStyle(color: Color(0xFF329932)),
                            ),
                          ))),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        context.read<HomeBloc>().add(
                            SelectTypeOfCategoryEvent(TransactionType.expense));
                      },
                      child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            border: typeOfTransactionSelected ==
                                    TransactionType.expense
                                ? Border.all(
                                    color: Theme.of(context).colorScheme.error,
                                    width: 1)
                                : null,
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context)
                                .colorScheme
                                .errorContainer
                                .withOpacity(0.4),
                          ),
                          child: Center(
                            child: Text(
                              "Chi tiêu",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          )),
                    )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showPopupDeleteCategory({
    required int id,
    required String name,
  }) {
    print("id: $id");
    return AppPopUp.showPopup(
        context: context,
        onPressedSelect: () {
          context.read<HomeBloc>().add(DeleteCategoryTransactionEvent(id));
          Navigator.pop(context);
        },
        childMessage: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TextFont(
              maxLines: 3,
              fontSize: 14,
              textAlign: TextAlign.center,
              text: "Bạn muốn xoá tên giao dịch \"$name\" này không?"),
        ));
  }
}
