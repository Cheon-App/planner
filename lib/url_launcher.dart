import 'package:url_launcher/url_launcher.dart';

/// Opens a web url in the device's default browser
Future<void> launchUrl(String url) async {
  final bool canLaunchUrl = await canLaunch(url);
  if (canLaunchUrl) {
    final bool successful = await launch(url);
    if (!successful) {
      return Future<void>.error('Failed to launch $url');
    }
  } else {
    return Future<void>.error('Could not launch $url');
  }
}

/// Opens the device's email app with the given email and optionally a subject
/// and body
Future<void> launchEmail(String email, {String subject, String body}) async {
  final parameters = <String, dynamic>{
    'subject': subject,
    'body': body,
  }..removeWhere((_, dynamic value) => value == null);

  final uri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: parameters.isNotEmpty ? parameters : null,
  );

  await launchUrl(uri.toString());
}
