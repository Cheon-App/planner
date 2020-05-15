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
Future<void> launchEmail(String email, {String subject, String body}) {
  if (subject != null && body != null) {
    // Creates an email with a subject and body
    return launchUrl('mailto:$email?subject=$subject&body=$body');
  } else if (subject != null) {
    // Creates an email with a subject
    return launchUrl('mailto:$email?subject=$subject');
  } else if (body != null) {
    // Creates an email with a body
    return launchUrl('mailto:$email?body=$body');
  } else {
    // Creates an email without a subject or body
    return launchUrl('mailto:$email');
  }
}
