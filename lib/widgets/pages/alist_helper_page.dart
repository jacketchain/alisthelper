import 'package:alisthelper/i18n/strings.g.dart';
import 'package:alisthelper/provider/alist_provider.dart';
import 'package:alisthelper/provider/settings_provider.dart';
import 'package:alisthelper/widgets/button_card.dart';
import 'package:alisthelper/widgets/pages/first_launch_page.dart';
import 'package:alisthelper/widgets/logs_viewer.dart';
import 'package:alisthelper/widgets/responsive_builder.dart';
import 'package:alisthelper/widgets/sponsor_btn.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlistHelperPage extends ConsumerWidget {
  final SizingInformation sizingInformation;

  const AlistHelperPage({super.key, required this.sizingInformation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    if (settings.isFirstRun == true) {
      return FirstLaunchPage(sizingInformation: sizingInformation);
    }
    return Scaffold(
        appBar: (sizingInformation.isDesktop
            ? null
            : AppBar(
                title: const Text('Alist Helper',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )),
        body: Center(
            child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              SponsorBtn(),
              const AlistMultiButtonCard(),
              ListTile(
                title: Text(t.home.logs,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18)),
              ),
              Expanded(
                child: Card(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: LogsViewer(
                      output: ref.watch(alistProvider).output,
                    )),
              ),
            ],
          ),
        )));
  }
}
