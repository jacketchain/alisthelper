import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/model/alist_state.dart';
import 'package:alisthelper/model/updater_state.dart';
import 'package:alisthelper/provider/alist_helper_provider.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/updater_provider.dart';
import 'package:alisthelper/utils/textutils.dart';
import 'package:alisthelper/widgets/choose_alist_package.dart';
import 'package:alisthelper/widgets/choose_rclone_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradePage extends ConsumerStatefulWidget {
  const UpgradePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpgradePageState();
}

class _UpgradePageState extends ConsumerState<UpgradePage> {
  @override
  Widget build(BuildContext context) {
    final alistNotifier = ref.watch(alistProvider.notifier);
    final alistState = ref.watch(alistProvider);
    final alistHelperNotifier = ref.watch(ahProvider.notifier);
    final alistHelperState = ref.watch(ahProvider);
    final updaterState = ref.watch(updaterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.upgrade.upgrade,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              children: [
                //Alist Version
                Card(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(children: [
                    ListTile(
                      title: Text(t.upgrade.alistVersion.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                    ),
                    ListTile(
                      title: Text(t.upgrade.alistVersion.currentVersion),
                      subtitle: Consumer(
                        builder: (context, watch, child) {
                          return Text(alistState.currentVersion);
                        },
                      ),
                      trailing: FilledButton.tonal(
                        onPressed: () async {
                          await launchUrl(Uri.parse(
                              'https://github.com/AlistGo/alist/releases'));
                        },
                        child: const Icon(Icons.link),
                      ),
                    ),
                    ListTile(
                      title: Text(t.upgrade.alistVersion.latestVersion),
                      subtitle: Text((alistState.latestVersion == 'v1.0.0')
                          ? t.upgrade.clickToCheck
                          : alistState.latestVersion),
                      trailing: FilledButton.tonal(
                        onPressed: () async {
                          try {
                            await alistNotifier.fetchLatestVersion();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: e
                                              .toString()
                                              .split('\n')
                                              .map((message) => Text(
                                                    message,
                                                    maxLines: 5,
                                                  ))
                                              .toList())));
                            }
                          }
                        },
                        child: const Icon(Icons.find_replace),
                      ),
                    ),
                    ListTile(
                      title: Text(t.upgrade.upgrade),
                      subtitle: Text(
                        (alistState.latestVersion == 'v1.0.0'
                            ? t.upgrade.checkFirst
                            : (TextUtils.isNewVersion(alistState.currentVersion,
                                    alistState.latestVersion)
                                ? t.upgrade.canUpgrade
                                : t.upgrade.noUpgrade)),
                      ),
                      trailing: UpgradeAlistButton(alistState: alistState),
                    ),
                    Container(height: 10)
                  ]),
                ),
                //Alist Helper Version
                Card(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(children: [
                    ListTile(
                      title: Text(t.upgrade.alistHelperVersion.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                    ),
                    ListTile(
                      title: Text(t.upgrade.alistHelperVersion.currentVersion),
                      subtitle: Consumer(
                        builder: (context, watch, child) {
                          return Text(alistHelperState.currentVersion);
                        },
                      ),
                      trailing: FilledButton.tonal(
                        onPressed: () async {
                          await launchUrl(Uri.parse(
                              'https://github.com/Xmarmalade/alisthelper/releases'));
                        },
                        child: const Icon(Icons.link),
                      ),
                    ),
                    ListTile(
                      title: Text(t.upgrade.alistHelperVersion.latestVersion),
                      subtitle: Text(
                          (alistHelperState.latestVersion == 'v0.0.0')
                              ? t.upgrade.clickToCheck
                              : alistHelperState.latestVersion),
                      trailing: FilledButton.tonal(
                        onPressed: () async {
                          try {
                            await alistHelperNotifier
                                .fetchAlistHelperLatestVersion();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: e
                                              .toString()
                                              .split('\n')
                                              .map((message) => Text(
                                                    message,
                                                    maxLines: 5,
                                                  ))
                                              .toList())));
                            }
                          }
                        },
                        child: const Icon(Icons.find_replace),
                      ),
                    ),
                    ListTile(
                      title: Text(t.upgrade.upgrade),
                      subtitle: Text(
                        (alistHelperState.latestVersion == 'v0.0.0'
                            ? t.upgrade.checkFirst
                            : (TextUtils.isNewVersion(
                                    alistHelperState.currentVersion,
                                    alistHelperState.latestVersion)
                                ? t.upgrade.canUpgrade
                                : t.upgrade.noUpgrade)),
                      ),
                      trailing: FilledButton.tonal(
                        onPressed: (alistHelperState.latestVersion == 'v0.0.0'
                            ? null
                            : (TextUtils.isNewVersion(
                                    alistHelperState.currentVersion,
                                    alistHelperState.latestVersion)
                                ? (() async {
                                    await launchUrl(Uri.parse(
                                        'https://github.com/Xmarmalade/alisthelper/releases/latest'));
                                  })
                                : null)),
                        child: const Icon(Icons.open_in_browser_outlined),
                      ),
                    ),
                    Container(height: 10)
                  ]),
                ),
                //Rclone Version
                Card(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(children: [
                    ListTile(
                      title: Text(t.upgrade.rcloneVersion.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                    ),
                    ListTile(
                      title: Text(t.upgrade.rcloneVersion.currentVersion),
                      subtitle: Consumer(
                        builder: (context, watch, child) {
                          return Text(updaterState.rcloneCurrentVersion);
                        },
                      ),
                      trailing: FilledButton.tonal(
                        onPressed: () async {
                          await launchUrl(Uri.parse(
                              'https://github.com/rclone/rclone/releases'));
                        },
                        child: const Icon(Icons.link),
                      ),
                    ),
                    ListTile(
                      title: Text(t.upgrade.rcloneVersion.latestVersion),
                      subtitle: Text(
                          (updaterState.rcloneLatestVersion == 'v1.0.0')
                              ? t.upgrade.clickToCheck
                              : updaterState.rcloneLatestVersion),
                      trailing: FilledButton.tonal(
                        onPressed: () async {
                          try {
                            await ref
                                .read(updaterProvider.notifier)
                                .getRcloneCurrentVersion();

                            await ref
                                .read(updaterProvider.notifier)
                                .fetchLatestVersion();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: e
                                              .toString()
                                              .split('\n')
                                              .map((message) => Text(
                                                    message,
                                                    maxLines: 5,
                                                  ))
                                              .toList())));
                            }
                          }
                        },
                        child: const Icon(Icons.find_replace),
                      ),
                    ),
                    ListTile(
                      title: Text(t.upgrade.upgrade),
                      subtitle: Text(
                        (updaterState.rcloneLatestVersion == 'v1.0.0'
                            ? t.upgrade.checkFirst
                            : (TextUtils.isNewVersion(
                                    updaterState.rcloneCurrentVersion,
                                    updaterState.rcloneLatestVersion)
                                ? t.upgrade.canUpgrade
                                : t.upgrade.noUpgrade)),
                      ),
                      trailing: UpgradeButton(
                        updaterState: updaterState,
                      ),
                    ),
                    Container(height: 10)
                  ]),
                ),
              ],
            )),
      ),
    );
  }
}

class UpgradeButton extends StatelessWidget {
  const UpgradeButton({super.key, required this.updaterState});

  final UpdaterState updaterState;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: (updaterState.rcloneLatestVersion == 'v1.0.0'
          ? null
          : (TextUtils.isNewVersion(updaterState.rcloneCurrentVersion,
                  updaterState.rcloneLatestVersion)
              ? () => showDialog(
                  context: context,
                  builder: (context) {
                    return const ChooseRclonePackage(isUpgrade: true);
                  })
              : null)),
      child: const Icon(Icons.file_download_outlined),
    );
  }
}

class UpgradeAlistButton extends StatelessWidget {
  const UpgradeAlistButton({super.key, required this.alistState});

  final AlistState alistState;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: (alistState.latestVersion == 'v1.0.0'
          ? null
          : (TextUtils.isNewVersion(
                  alistState.currentVersion, alistState.latestVersion)
              ? () => showDialog(
                  context: context,
                  builder: (context) {
                    return const ChooseAlistPackage(isUpgrade: true);
                  })
              : null)),
      child: const Icon(Icons.file_download_outlined),
    );
  }
}
