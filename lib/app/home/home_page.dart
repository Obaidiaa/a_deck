// home page nothing else for now

import 'package:a_deck/app/deck/deck_page.dart';
import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/app/settings/setting_page.dart';
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
          InkWell(
              onTap: () => SettingPage.show(context),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.settings),
              )),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ConnectionStatus(),
          )
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
    final connected = ref.watch(webSocketConnectionStatusProvider);
    if (connected) {
      return const Icon(Icons.wifi);
    } else {
      return InkWell(
        onTap: () => ref.refresh(dataProvider),
        child: Row(
          children: const [
            Icon(Icons.wifi_off),
            Text('Reconnect'),
          ],
        ),
      );
    }
  }
}
