import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front_end/core/utils/constants.dart';

class ProfileAboutInfo extends StatefulWidget {
  const ProfileAboutInfo({super.key});

  @override
  State<ProfileAboutInfo> createState() => _ProfileAboutInfoState();
}

class _ProfileAboutInfoState extends State<ProfileAboutInfo> {
  String currentVersion = "";
  String latestVersion = "";

  @override
  void initState() {
    super.initState();
  }



  int compareVersions(String v1, String v2) {
    // Split version strings into parts
    List<int> v1Parts = v1.split('.').map(int.parse).toList();
    List<int> v2Parts = v2.split('.').map(int.parse).toList();

    // Compare each version part
    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] < v2Parts[i]) {
        return -1; // v1 is less than v2
      } else if (v1Parts[i] > v2Parts[i]) {
        return 1; // v1 is greater than v2
      }
    }
    return 0; // v1 is equal to v2
  }

  bool _isUpdateAvailable() {
    return latestVersion.isNotEmpty &&
        compareVersions(latestVersion, currentVersion) > 0;
  }

  void _showUpdateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Center(
                child: SvgPicture.asset(AppImage.dashIcon),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("Version", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(
                height: 20,
              ),
              // Image.asset(
              //   AppImage.iconNew,
              //   color: Theme.of(context).brightness == Brightness.dark
              //       ? Colors.white
              //       : null,
              //   height: 60,
              //   width: 60,
              // ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "MindAlly",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                currentVersion,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                      "Version up to date",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
     return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                // context.push(AppRoutes.privacyPolicyPage);
              },
              // leading: SvgPicture.asset(
              //   AppImage.privacyIcon,
              //   color: Theme.of(context).colorScheme.onSurface,
              // ),
              title: Text(
                "Privacy policy",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            ListTile(
              onTap: () {
                // context.push(AppRoutes.termsAndConditionsPage);
              },
              // leading: SvgPicture.asset(
              //   AppImage.termsAndConditionIcon,
              //   color: Theme.of(context).colorScheme.onSurface,
              // ),
              title: Text(
                "Terms and conditions",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            ListTile(
              onTap: () {
              },
              // leading: SvgPicture.asset(
              //   "assets/svg/faq.svg",
              //   color: Theme.of(context).colorScheme.onSurface,
              //   width: 20,
              //   height: 20,
              // ),
              title: Text(
                "About",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            ListTile(
              onTap: () => _showUpdateModal(context),
              trailing: Text(
                currentVersion,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // leading: SvgPicture.asset(
              //   AppImage.aboutIcon,
              //   color: Theme.of(context).colorScheme.onSurface,
              // ),
              title: Text(
                "Version",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
  }
}
