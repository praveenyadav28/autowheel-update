//Url Louncher
import 'package:autowheel_workshop/utils/components/library.dart';

Future sendMessage(
    BuildContext context, String phoneNumber, String name) async {
  if (!await launchUrl(
    Uri.parse("sms:$phoneNumber?body=$name"),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch ');
  }
}

Future makeCall(BuildContext context, String phoneNumber) async {
  if (!await launchUrl(
    Uri.parse("tel:$phoneNumber"),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch ');
  }
}

Future openWhatsApp(
    BuildContext context, String phoneNumber, String name) async {
  if (!await launchUrl(
    Uri.parse("https://wa.me/+91$phoneNumber?text=$name"),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch ');
  }
}
