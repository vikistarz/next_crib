import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  static Future<void> checkForUpdate(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    String latestVersion = await getLatestVersion();

    if (latestVersion.isNotEmpty && isVersionNewer(currentVersion, latestVersion)) {
      showUpdateDialog(context);
    }
  }

  /// Fetches the latest version from Play Store (Android) or App Store (iOS)
  static Future<String> getLatestVersion() async {
    try {
      String packageName = Platform.isAndroid
          ? "com.company.techx" // Replace with your actual package name
          : "YOUR_APPLE_APP_ID";  // Replace with your App Store ID

      String url = Platform.isAndroid
          ? "https://play.google.com/store/apps/details?id=$packageName"
          : "https://itunes.apple.com/lookup?id=$packageName";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        if (Platform.isAndroid) {
          // Extract version from Play Store response
          RegExp regex = RegExp(r'"softwareVersion":"([\d.]+)"');
          final match = regex.firstMatch(response.body);
          return match?.group(1) ?? '';
        } else {
          final data = jsonDecode(response.body);
          return data["results"].isNotEmpty ? data["results"][0]["version"] : '';
        }
      }
    } catch (e) {
      print("Error fetching latest version: $e");
    }
    return '';
  }

  /// Compares versions to check if an update is needed
  static bool isVersionNewer(String currentVersion, String latestVersion) {
    List<int> currentParts = currentVersion.split('.').map(int.parse).toList();
    List<int> latestParts = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length || latestParts[i] > currentParts[i]) {
        return true; // Latest version is newer
      } else if (latestParts[i] < currentParts[i]) {
        return false; // Current version is already newer (unlikely)
      }
    }
    return false;
  }

  /// Shows an update dialog
  static void showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Available"),
        content: const Text("A new version of the app is available. Please update to the latest version."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Later"),
          ),
          TextButton(
            onPressed: () {
              String url = Platform.isAndroid
                  ? "https://play.google.com/store/apps/details?id=com.company.techx"
                  : "https://apps.apple.com/app/idYOUR_APPLE_APP_ID";
              launchURL(url);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch $url");
    }
  }
}