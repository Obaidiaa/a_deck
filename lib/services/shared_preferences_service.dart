// class for local data storage eg. settings

import 'package:a_deck/app/models/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

class SharedPreferencesService {
  // late final SharedPreferences sharedPreferences;

  SharedPreferencesService(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

// server ip sharedPref
  static const serverIp = 'serverIp';
// server port shardPref
  static const serverPort = 'serverPort';

  setSettings(String ip, String port) async {
    await sharedPreferences.setString(serverIp, ip);
    await sharedPreferences.setString(serverPort, port);
  }

  Settings getSettings() {
    final serverIpPref = sharedPreferences.getString(serverIp) ?? "";
    final serverPortPref = sharedPreferences.getString(serverPort) ?? "0000";
    return Settings(serverIp: serverIpPref, serverPort: serverPortPref);
  }

  void deleteSettings() {
    sharedPreferences.remove(serverIp);
    sharedPreferences.remove(serverPort);
  }
}
