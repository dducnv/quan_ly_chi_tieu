import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:quan_ly_chi_tieu/core/utils/function.dart';

class FeedbackButton extends StatefulWidget {
  const FeedbackButton({Key? key}) : super(key: key);

  @override
  State<FeedbackButton> createState() => _FeedbackButtonState();
}

class _FeedbackButtonState extends State<FeedbackButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        BetterFeedback.of(context).show((feedback) async {
          // draft an email and send to developer
          final screenshotFilePath =
              await writeImageToStorage(feedback.screenshot);

          final Email email = Email(
            body: feedback.text,
            subject: 'Samon App Feedback',
            recipients: ['ducnv0712@gmail.com'],
            attachmentPaths: [screenshotFilePath],
            isHTML: false,
          );

          String platformResponse;

          try {
            await FlutterEmailSender.send(email);
            platformResponse = 'Cảm ơn bạn đã báo cáo lỗi cho chúng tôi, '
                'chúng tôi sẽ kiểm tra và sửa lỗi sớm nhất có thể';
          } catch (error) {
            platformResponse = error.toString();
          }

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(platformResponse),
            ),
          );
        });
      },
      icon: const Icon(Icons.feedback_rounded),
    );
  }
}
