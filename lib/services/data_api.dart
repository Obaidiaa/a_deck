// load data from server

import 'package:a_deck/app/models/command.dart';
import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final dataApiProvider = Provider.autoDispose<DataApi>((ref) {
//   final settings = ref.watch(sharedPreferencesServiceProvider);
//   return DataApi(settings: settings.getSettings());
// });

final dataProvider = Provider<DataApi>((ref) {
  final settings = ref.watch(sharedPreferencesServiceProvider);
  return DataApi(settings: settings.getSettings());
});

class DataApi {
  final Settings settings;

  DataApi({required this.settings});
  List<Command> listCommand = [
    Command(
        id: "1",
        name: "Discord",
        command: "C:/discord.exe",
        picture:
            "https://assets.mofoprod.net/network/images/discord.original.jpg"),
    Command(
        id: "2",
        name: "chrome",
        command: "C:/chrome.exe",
        picture:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/archive/a/a5/20160124180756%21Google_Chrome_icon_%28September_2014%29.svg/120px-Google_Chrome_icon_%28September_2014%29.svg.png"),
  ];
  Future<List<Command>> apiGetCommands() {
    return Future.delayed(const Duration(milliseconds: 1000), () async {
      return listCommand;
    });
  }

  // void printData() {
  //   print(settings.serverPort);
  // }

  void addCommand() {
    listCommand.add(
      Command(
          id: "2",
          name: "chrome",
          command: "C:/chrome.exe",
          picture:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/archive/a/a5/20160124180756%21Google_Chrome_icon_%28September_2014%29.svg/120px-Google_Chrome_icon_%28September_2014%29.svg.png"),
    );
  }
}
