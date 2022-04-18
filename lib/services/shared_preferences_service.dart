// class for local data storage eg. settings

import 'package:a_deck/app/models/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
    StateNotifierProvider<SharedPreferencesService, Settings>(
        (ref) => throw UnimplementedError());

// final settingsDataProvider =
//     StateNotifierProvider<SharedPreferencesService, Settings>(
//         (ref) => throw UnimplementedError());

class SharedPreferencesService extends StateNotifier<Settings> {
  // late final SharedPreferences sharedPreferences;

  SharedPreferencesService(this.sharedPreferences)
      : super(Settings(serverIp: '', serverPort: '')) {
    getSettings();
  }

  final SharedPreferences sharedPreferences;

  Settings? settings;
// server ip sharedPref
  static const serverIp = 'serverIp';
// server port shardPref
  static const serverPort = 'serverPort';

  setSettings(String ip, String port) async {
    await sharedPreferences.setString(serverIp, ip);
    await sharedPreferences.setString(serverPort, port);
    state = Settings(serverIp: ip, serverPort: port);
  }

  void getSettings() {
    final serverIpPref = sharedPreferences.getString(serverIp) ?? "";
    final serverPortPref = sharedPreferences.getString(serverPort) ?? "0000";
    state = Settings(serverIp: serverIpPref, serverPort: serverPortPref);
    // return Settings(serverIp: serverIpPref, serverPort: serverPortPref);
  }

  void deleteSettings() {
    sharedPreferences.remove(serverIp);
    sharedPreferences.remove(serverPort);
    state = Settings(serverIp: '', serverPort: '');
  }
}
