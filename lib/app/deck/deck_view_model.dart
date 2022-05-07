import 'package:a_deck/app/models/command.dart';
import 'package:a_deck/services/data_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deckCommandProvider = FutureProvider<List<Command>>((ref) async {
  final commandsList = ref.watch(dataProvider);
  final _dataApi = ref.watch(dataProvider.notifier);

  //get Images from The Desktop application
  for (var i = 0; i < commandsList.length; i++) {
    commandsList[i].picture = await _dataApi.getImageById(commandsList[i].id!);
  }
  return commandsList;
});

final deckViewModelProvider = Provider((ref) {
  final _dataApi = ref.watch(dataProvider.notifier);
  return DeckViewModel(dataApi: _dataApi);
});

class DeckViewModel extends StateNotifier {
  DeckViewModel({required this.dataApi}) : super(null);

  final DataApi dataApi;

  sendCommand(String id) {
    dataApi.sendCommand('StartApplication', id);
  }
}
