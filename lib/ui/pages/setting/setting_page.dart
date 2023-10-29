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
    initSettingPage();
  }

  @override
  void dispose() {
    textAddCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(slivers: [
            SliverAppBar(
              pinned: false,
              backgroundColor: Colors.white,
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.white,
                  child: const Center(
                      child: Text(
                    "Cấu hình & Cài đặt",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ),
            SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverToBoxAdapter(
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  List<CategoryTransactionData>
                                      listCategoryIncome = [];
                                  List<CategoryTransactionData>
                                      listCategoryExpense = [];
                                  if (state
                                      is GetListCategoryTransactionState) {
                                    {
                                      listCategoryIncome.clear();
                                      listCategoryExpense.clear();
                                      listCategoryIncome = context
                                          .read<HomeBloc>()
                                          .listCategoryTransaction
                                          .where((element) => element.type
                                              .contains(
                                                  TransactionType.income.name))
                                          .toList();
                                      listCategoryExpense = context
                                          .read<HomeBloc>()
                                          .listCategoryTransaction
                                          .where((element) => element.type
                                              .contains(
                                                  TransactionType.expense.name))
                                          .toList();
                                    }
                                  }

                                  return ListView(
                                    primary: true,
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
                                child: ListTile(
                                  onTap: () async {
                                    String? selectedDirectory = await FilePicker
                                        .platform
                                        .getDirectoryPath();
                                    if (selectedDirectory == null) {
                                      return;
                                    }
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
                                  subtitle: Text(
                                      "Địa chỉ lưu: ${addressSaveBackups ?? "/Downloads"}"),
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
                )),
          ]),
        ));
  }
}
