// deck page showing all commands

import 'dart:convert';
import 'dart:ui';

import 'package:a_deck/app/deck/deck_view_model.dart';
import 'package:a_deck/app/models/command.dart';
import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/app/settings/setting_page.dart';
import 'package:a_deck/app/settings/setting_view_model.dart';
import 'package:a_deck/app/top_level_providers.dart';
import 'package:a_deck/routing/app_router.dart';
import 'package:a_deck/services/data_api.dart';
import 'package:a_deck/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeckPage extends ConsumerStatefulWidget {
  const DeckPage({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context, {Settings? settings}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.deckPage,
      arguments: settings,
    );
  }

  @override
  _DeckPageState createState() => _DeckPageState();
}

class _DeckPageState extends ConsumerState<DeckPage> {
  @override
  Widget build(BuildContext context) {
    return const DeckDisplay();
  }
}

class DeckDisplay extends ConsumerWidget {
  const DeckDisplay({Key? key}) : super(key: key);
  onAdd(WidgetRef ref) {
    ref.read(deckViewModelProvider).addCommand();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
            child: ref.watch(deckCommandProvider).when(
                data: (data) => GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: InkWell(
                            onTap: () =>
                                ref.read(dataProvider.notifier).startClient(),
                            child: StreamBuilder(
                              stream: ref
                                  .read(dataProvider.notifier)
                                  .getImageById(data[index].id!),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  try {
                                    return Image.memory(snapshot.data);
                                  } catch (e) {
                                    return const Icon(
                                        Icons.no_photography_rounded);
                                  }
                                }
                                return const SizedBox(
                                    child: Center(
                                        child: CircularProgressIndicator()));
                              },
                            ),
                          ),
                        );
                      },
                    ),
                error: (error, trace) => Text(error.toString()),
                loading: () => const SizedBox(
                      child: Center(child: Text('loading')),
                    ))),
        ElevatedButton(
          onPressed: () {},
          child: const Text('re'),
        )
      ],
    );
  }
}
