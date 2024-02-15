import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/common/user_management.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/app_button_custom_widget.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/tappable.dart';

class AppPopUp {
  static Future<T?> showPopup<T>({
    required BuildContext context,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? title,
    Widget? titleWidget,
    bool isShowTitle = true,
    String? message,
    void Function()? onPressedCancel,
    void Function()? onPressedSelect,
    String? textCancel,
    String? textSelect,
    Color? colorBtnCancel,
    Color? colorBtnSelect,
    Widget? buttonCancel,
    Widget? buttonSelect,
    Widget? childMessage,
    bool isShowButtonSelect = true,
    bool isShowButtonCancel = true,
    TextStyle? styleTitle,
  }) async {
    final lstButtonDefault = Row(
      children: [
        Visibility(
          visible: isShowButtonCancel,
          child: Expanded(
            child: SizedBox(
              height: 50,
              child: buttonCancel ??
                  AppButtonCustomWidget(
                    color: Theme.of(context).colorScheme.errorContainer,
                    constraints: const BoxConstraints(maxWidth: 100),
                    onPressed: onPressedCancel ??
                        () {
                          Navigator.pop(context);
                        },
                    text: textCancel ?? 'Hủy',
                    child: Center(
                      child: Text(
                        textCancel ?? 'Hủy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorBtnCancel ??
                              Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ),
        Visibility(
            visible: isShowButtonCancel == true && isShowButtonSelect == true,
            child: const SizedBox(width: 20)),
        Visibility(
          visible: isShowButtonSelect,
          child: Expanded(
            child: SizedBox(
              height: 50,
              child: buttonSelect ??
                  AppButtonCustomWidget(
                      constraints: const BoxConstraints(maxWidth: 100),
                      onPressed: onPressedSelect ?? () {},
                      text: textSelect ?? 'Đồng ý',
                      child: Center(
                        child: Text(
                          textSelect ?? 'Đồng ý',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colorBtnSelect ??
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )),
            ),
          ),
        )
      ],
    );
    final popup = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0))),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isShowTitle)
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 0),
                child: titleWidget ??
                    Text(
                      title ?? 'Thông báo',
                      style: styleTitle ??
                          const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff212C42),
                          ),
                    ),
              ),
            childMessage ??
                Padding(
                  padding: message == ''
                      ? const EdgeInsets.symmetric(horizontal: 22, vertical: 20)
                      : EdgeInsets.zero,
                  child: Text(message ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff212C42),
                      )),
                ),
            if (isShowButtonCancel || isShowButtonSelect)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                child: lstButtonDefault,
              )
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
    return showDialog(
      context: context,
      barrierColor: barrierColor ?? Colors.black45,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return popup;
      },
    );
  }

  static Future<T?> showPopupBottom<T>({
    required BuildContext context,
    String? title,
    String? message,
    Widget? messageWidget,
    //back popup
    bool backPopup = false,
    void Function()? onBackPopup,
    //button
    bool isShowButtonCancel = false,
    bool isShowButtonSelect = false,
    String? textCancel,
    String? textSelect,
    Widget? buttonCancel,
    Widget? buttonSelect,
    void Function()? onPressedCancel,
    void Function()? onPressedSelect,
    Color? colorBtnCancel,
    Color? colorBtnSelect,
    Widget? content,
    bool isScrollControlled = false,
    bool enableDrag = true,
    bool isDismissible = false,
    double borderRadius = 35,
  }) {
    final bcontext = UserManagement().navigatorKey.currentContext!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorBG = Theme.of(context).colorScheme.secondaryContainer;
    final colorTextTheme = isDarkMode ? Colors.white : Colors.black;
    final lstButtonDefault = Row(
      children: [
        Visibility(
          visible: isShowButtonCancel,
          child: Expanded(
            child: buttonCancel ??
                Tappable(
                  child: Center(
                    child: Text(
                      textCancel ?? 'Hủy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorTextTheme,
                      ),
                    ),
                  ),
                ),
          ),
        ),
        SizedBox(width: isShowButtonSelect ? 20 : 0),
        Visibility(
          visible: isShowButtonSelect,
          child: Expanded(
            child: buttonSelect ??
                AppButtonCustomWidget(
                  constraints: const BoxConstraints(maxWidth: 100),
                  onPressed: onPressedSelect ?? () {},
                  text: textSelect ?? 'Đồng ý',
                ),
          ),
        )
      ],
    );
    final popupBottom = Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //header popup
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: <Widget>[
                backPopup
                    ? Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: onBackPopup ??
                                () {
                                  Navigator.pop(bcontext);
                                },
                            child: const Icon(Icons.keyboard_arrow_left),
                          ),
                        ),
                      )
                    : const Expanded(child: SizedBox()),
                Text(
                  title ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextTheme,
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(bcontext);
                      },
                      child: const Icon(Icons.close_rounded),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          if (content != null)
            content
          else ...<Widget>[
            //content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: messageWidget ??
                  Text(
                    message ?? '',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorTextTheme,
                    ),
                  ),
            ),
            //button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: lstButtonDefault,
            ),
          ],
        ],
      ),
    );
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(borderRadius),
          topLeft: Radius.circular(borderRadius),
        ),
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: colorBG,
      context: bcontext,
      isScrollControlled: isScrollControlled,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: isScrollControlled ? 0.9 : null,
          child: popupBottom,
        );
      },
    );
  }

  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    BoxConstraints? constraints,
    ShapeBorder? shape,
    Color? backGroundColor,
  }) async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: backGroundColor,
      constraints: constraints,
      context: context,
      shape: shape ??
          const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      builder: (BuildContext context) {
        return child;
      },
    );
  }
}
