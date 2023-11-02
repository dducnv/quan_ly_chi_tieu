import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_state.dart';
import 'package:quan_ly_chi_tieu/core/local/database/expense_management_db.dart';
import 'package:quan_ly_chi_tieu/core/local/database/platform/native.dart';
import 'package:quan_ly_chi_tieu/core/local/local_pref/pref_helper.dart';
import 'package:quan_ly_chi_tieu/core/local/local_pref/pref_keys.dart';
import 'package:quan_ly_chi_tieu/resource/enum.dart';
import 'package:quan_ly_chi_tieu/ui/pages/setting/components/setting_compnent.dart';
import 'package:quan_ly_chi_tieu/ui/pages/setting/widgets/setting_card.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/app_button_custom_widget.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';
import 'package:restart_app/restart_app.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  String addressSaveBackups = "";
  bool isShowTitleAppBar = false;
  List<CategoryTransactionData> listCategoryIncome = [];
  List<CategoryTransactionData> listCategoryExpense = [];
  late ScrollController scrollController;
  bool switchValue = false;
  late TextEditingController textAddCategoryController;
  Future<void> initSettingPage() async {
    addressSaveBackups =
        await PrefHelper().readData(PrefKeys.folderSavebackups) ??
            "/storage/emulated/0/Download";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    textAddCategoryController = TextEditingController();
    scrollController = ScrollController();
    listCategoryIncome = context
        .read<HomeBloc>()
        .listCategoryTransaction
        .where((element) => element.type.contains(TransactionType.income.name))
        .toList();
    listCategoryExpense = context
        .read<HomeBloc>()
        .listCategoryTransaction
        .where((element) => element.type.contains(TransactionType.expense.name))
        .toList();
    scrollController.addListener(() {
      if (scrollController.offset > 100) {
        if (isShowTitleAppBar == false) {
          setState(() {
            isShowTitleAppBar = true;
          });
        }
      } else {
        if (isShowTitleAppBar == true) {
          setState(() {
            isShowTitleAppBar = false;
          });
        }
      }
    });

    initSettingPage();
  }

  @override
  void dispose() {
    textAddCategoryController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(controller: scrollController, slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              title: AnimatedOpacity(
                curve: Curves.easeIn,
                opacity: isShowTitleAppBar ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: const TextFont(
                  text: "Cấu hình & Cài đặt",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.2,
                background: Container(
                  color: Colors.white,
                  child: Center(
                      child: AnimatedOpacity(
                    opacity: !isShowTitleAppBar ? 1.0 : 0.0,
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 100),
                    child: const Text(
                      "Cấu hình & Cài đặt",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  )),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SettingCard(
                      //   title: "Cấu hình hiển thị",
                      //   children: [
                      //     Card(
                      //       elevation: 0,
                      //       color: Theme.of(context)
                      //           .colorScheme
                      //           .primaryContainer
                      //           .withOpacity(0.4),
                      //       child: Padding(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 10, vertical: 10),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             const TextFont(
                      //               text: "Sử dụng tính năng số dư",
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w500,
                      //             ),
                      //             Switch(
                      //               activeColor: Theme.of(context)
                      //                   .colorScheme
                      //                   .primary
                      //                   .withOpacity(0.8),
                      //               value: switchValue,
                      //               onChanged: (value) {
                      //                 setState(() {
                      //                   switchValue = value;
                      //                 });
                      //               },
                      //               activeTrackColor: Theme.of(context)
                      //                   .colorScheme
                      //                   .primary
                      //                   .withOpacity(0.3),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     Card(
                      //       elevation: 0,
                      //       color: Theme.of(context)
                      //           .colorScheme
                      //           .primaryContainer
                      //           .withOpacity(0.4),
                      //       child: Padding(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 10, vertical: 10),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             const TextFont(
                      //               text: "Ngôn ngữ",
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w500,
                      //             ),
                      //             DropdownButtonHideUnderline(
                      //               child: DropdownButton<String>(
                      //                 value: 'Tiếng Việt',
                      //                 items: <String>['Tiếng Việt', 'Tiếng Anh']
                      //                     .map((String value) {
                      //                   return DropdownMenuItem<String>(
                      //                     value: value,
                      //                     child: Text(value),
                      //                   );
                      //                 }).toList(),
                      //                 onChanged: (_) {},
                      //               ),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),

                      SettingCard(
                        title: "Quản lý danh mục",
                        titleRightButton: SizedBox(
                          width: 50,
                          height: 50,
                          child: AppButtonCustomWidget(
                              constraints: const BoxConstraints(maxWidth: 50),
                              text: "+",
                              onPressed: () {
                                popupAddCategory();
                              }),
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<HomeBloc, BaseState>(
                                buildWhen: (previous, current) =>
                                    current is GetListCategoryTransactionState,
                                builder: (context, state) {
                                  listCategoryIncome = context
                                      .read<HomeBloc>()
                                      .listCategoryTransaction
                                      .where((element) => element.type.contains(
                                          TransactionType.income.name))
                                      .toList();
                                  listCategoryExpense = context
                                      .read<HomeBloc>()
                                      .listCategoryTransaction
                                      .where((element) => element.type.contains(
                                          TransactionType.expense.name))
                                      .toList();
                                  return ListView(
                                    primary: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      const TextFont(
                                        text: "Danh mục cho khoản thu",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      Wrap(
                                        spacing: 4.0,
                                        runSpacing: 0.0,
                                        children: List<Widget>.generate(
                                            listCategoryIncome
                                                .length, // place the length of the array here
                                            (int index) {
                                          return ActionChip(
                                              avatar: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                showPopupDeleteCategory(
                                                    id: listCategoryIncome[
                                                            index]
                                                        .id,
                                                    name: listCategoryIncome[
                                                            index]
                                                        .name);
                                              },
                                              elevation: 6.0,
                                              backgroundColor: Colors.white,
                                              shadowColor: Colors.grey[60],
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              iconTheme: IconThemeData(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              label: Text(
                                                  listCategoryIncome[index]
                                                      .name));
                                        }).toList(),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const TextFont(
                                        text: "Danh mục cho khoản chi",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      Wrap(
                                        spacing: 4.0,
                                        runSpacing: 0.0,
                                        children: List<Widget>.generate(
                                            listCategoryExpense
                                                .length, // place the length of the array here
                                            (int index) {
                                          return ActionChip(
                                              avatar: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              backgroundColor: Colors.white,
                                              onPressed: () {
                                                showPopupDeleteCategory(
                                                    id: listCategoryExpense[
                                                            index]
                                                        .id,
                                                    name: listCategoryExpense[
                                                            index]
                                                        .name);
                                              },
                                              elevation: 6.0,
                                              shadowColor: Colors.grey[60],
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              iconTheme: IconThemeData(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              label: Text(
                                                  listCategoryExpense[index]
                                                      .name));
                                        }).toList(),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SettingCard(title: "Sao lưu & khôi phục", children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Card(
                                elevation: 0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                    .withOpacity(0.4),
                                child: ListTile(
                                  onTap: () async {
                                    String status = await backupDb();
                                    if (status == "success") {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Sao lưu thành công")));
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Sao lưu thất bại")));
                                    }
                                  },
                                  title: const Text("Sao lưu dữ liệu"),
                                  subtitle:
                                      Text("Địa chỉ lưu: $addressSaveBackups"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: AppButtonCustomWidget(
                                onPressed: () {
                                  AppPopUp.showPopup(
                                      context: context,
                                      onPressedSelect: () async {
                                        String? selectedDirectory =
                                            await FilePicker.platform
                                                .getDirectoryPath();
                                        if (selectedDirectory == null) {
                                          return;
                                        }
                                        bool statusSave = await PrefHelper()
                                            .saveData(
                                                PrefKeys.folderSavebackups,
                                                selectedDirectory);
                                        if (statusSave) {
                                          setState(() {});
                                          initSettingPage();
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Thay đổi thành công")));
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Thay đổi thất bại")));
                                        }
                                      },
                                      childMessage: const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: TextFont(
                                          text:
                                              "Bạn muốn thay đổi địa chỉ lưu?",
                                          fontSize: 16,
                                        ),
                                      ));
                                },
                                text: '',
                                constraints: const BoxConstraints(),
                                child: const Center(child: Icon(Icons.folder)),
                              ),
                            )
                          ],
                        ),
                        Card(
                            elevation: 0,
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.4),
                            child: ListTile(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();

                                  if (result == null) {
                                    return;
                                  } else {
                                    bool isSuccess = await importBb(
                                        result.files.single.path!);
                                    if (isSuccess) {
                                      Restart.restartApp();
                                    }
                                  }
                                },
                                title: const Text("Nhập dữ liệu & khôi phục"))),
                      ])
                    ],
                  )),
            ),
          ]),
        ));
  }
}
