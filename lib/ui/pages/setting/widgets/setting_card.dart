import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final Widget? titleRightButton;
  final List<Widget> children;
  const SettingCard(
      {Key? key,
      required this.title,
      required this.children,
      this.titleRightButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withOpacity(0.4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  titleRightButton ?? const SizedBox()
                ]),
            const SizedBox(height: 16),
            ...children
          ],
        ),
      ),
    );
  }
}
