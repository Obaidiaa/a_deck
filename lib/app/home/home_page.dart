// home page nothing else for now

import 'dart:math';

import 'package:a_deck/app/deck/deck_page.dart';
import 'package:a_deck/app/deck/deck_view_model.dart';
import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/app/settings/setting_page.dart';
import 'package:a_deck/app/top_level_providers.dart';
import 'package:a_deck/routing/app_router.dart';
import 'package:a_deck/services/data_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  // final Settings settings;

  static Future<void> show(BuildContext context, {Settings? settings}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.homePage,
      arguments: settings,
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("A Deck"),
        actions: [
          ElevatedButton(
              // onPressed: () => ref.read(dataProvider.notifier).send(),
              onPressed: () => SettingPage.show(context),
              child: const Text('Settings')),
          const ConnectionStatus()
        ],
      ),
      body: const DeckPage(),
    ));
  }
}

class ConnectionStatus extends ConsumerWidget {
  const ConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(webSocketConnectionStatusProvider);
    return Text('$count');
  }
}
