import 'package:autowheel_workshop/utils/components/library.dart';

//Snackbar Error
void showCustomSnackbar(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onActionPressed}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: duration,
    backgroundColor: AppColor.colRideFare,
    action: actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed ?? () {},
          )
        : null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

//Snackbar Success
void showCustomSnackbarSuccess(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onActionPressed}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: duration,
    backgroundColor: AppColor.colPrimary,
    action: actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed ?? () {},
          )
        : null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
