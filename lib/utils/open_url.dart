

import 'package:url_launcher/url_launcher.dart';

openUrlLauncher({required String urlLink}) async{
  final Uri url = Uri.parse(urlLink);
  if (await canLaunchUrl(url)) {
  await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
  throw 'Could not launch $url';
  }
}