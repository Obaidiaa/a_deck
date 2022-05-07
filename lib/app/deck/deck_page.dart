// deck page showing all commands

import 'dart:io';

import 'package:a_deck/app/deck/deck_view_model.dart';
import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/routing/app_router.dart';
import 'package:flutter/foundation.dart';
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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deckProvider = ref.read(deckViewModelProvider);
    imageCache!.clear();
    imageCache!.clearLiveImages();
    if (kDebugMode) {
      print('rebuild');
    }
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
                        if (kDebugMode) {
                          print(data[index].picture);
                        }
                        return Card(
                          child: InkWell(
                              onTap: () =>
                                  deckProvider.sendCommand(data[index].id!),
                              child: Image(
                                image: FileImage(
                                  File(data[index].picture!),
                                ),
                              )),
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
