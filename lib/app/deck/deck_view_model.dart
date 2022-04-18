import 'package:a_deck/app/models/command.dart';
import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/app/top_level_providers.dart';
import 'package:a_deck/services/data_api.dart';
import 'package:a_deck/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deckCommandProvider = FutureProvider.autoDispose<List<Command>>((ref) {
  final commandsList = ref.watch(dataProvider);
  return commandsList;
});

final deckViewModelProvider = Provider((ref) {
  final List<Command> commands = ref.watch(dataProvider);
  return DeckViewModel(commandsList: commands, ref: ref);
});

class DeckViewModel extends StateNotifier<List<Command>> {
  DeckViewModel({required this.commandsList, required this.ref})
      : super(commandsList ?? []);
  List<Command>? commandsList;
  final ProviderRef ref;
  getCommands() {
    // state = await dataApi.apiGetCommands();
    state = commandsList!;
    // ref.refresh(deckCommandProvider);
    // return dataApi.apiGetCommands();
  }

  addCommand() {
    // print(dataApi.listCommand.length);
    state = commandsList!;
    // ref.refresh(deckCommandProvider);
  }
}
