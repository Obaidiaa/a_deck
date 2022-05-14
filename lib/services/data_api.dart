// load data from server

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:a_deck/app/models/command.dart';
import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/services/shared_preferences_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataProvider = StateNotifierProvider<DataApi, List<Command>>((ref) {
  final settings = ref.watch(sharedPreferencesServiceProvider);
  return DataApi(settings: settings, ref: ref);
});

final webSocketConnectionStatusProvider =
    StateNotifierProvider<WebSocketConnectionStatus, bool>(((ref) {
  return WebSocketConnectionStatus(false);
}));

class WebSocketConnectionStatus extends StateNotifier<bool> {
  WebSocketConnectionStatus(bool state) : super(state);

  @override
  bool get state => super.state;

  setConnectionStatus(connectionStatus) {
    state = connectionStatus;
  }
}

class DataApi extends StateNotifier<List<Command>> {
  final Settings settings;
  final Ref ref;
  DataApi({required this.settings, required this.ref}) : super([]) {
    startClient();
  }

  late Socket socket; //initialize a websocket channel
  bool isWebsocketRunning = false; //status of a websocket
  int retryLimit = 3;
  List data = [];

  void startClient() async {
    if (isWebsocketRunning) return;
    socket = await Socket.connect(
        settings.serverIp, int.parse(settings.serverPort!));
    if (kDebugMode) {
      print(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
    }
    ref
        .read(webSocketConnectionStatusProvider.notifier)
        .setConnectionStatus(true);
    isWebsocketRunning = true;
    sendCommand('getCommandsList', '');
    // listen for responses from the server
    socket.listen(
      // handle data from the server
      (Uint8List data) async {
        final serverResponse = String.fromCharCodes(data);
        if (kDebugMode) {
          print(serverResponse);
        }

        try {
          final List<dynamic> json = jsonDecode(serverResponse);
          final List<Command> commandsList =
              json.map((e) => Command.fromJson(e)).toList();
          state = commandsList;
        } catch (e) {
          state = [];
        }
        if (kDebugMode) {
          print('Server: $serverResponse');
        }
      },

      // handle errors
      onError: (error) {
        isWebsocketRunning = false;
        ref
            .read(webSocketConnectionStatusProvider.notifier)
            .setConnectionStatus(false);
        socket.destroy();
        if (retryLimit != 0) {
          startClient();
          retryLimit--;
        }
      },

      // handle server ending connection
      onDone: () {
        isWebsocketRunning = false;
        ref
            .read(webSocketConnectionStatusProvider.notifier)
            .setConnectionStatus(false);
        if (kDebugMode) {
          print('Server left.');
        }
        socket.destroy();
        startClient();
      },
    );
  }

  @override
  List<Command> get state => super.state;

  void sendCommand(String command, String parameters) {
    sendMessage(
        socket, json.encode({'command': command, 'parameters': parameters}));
  }

  Future<void> sendMessage(Socket socket, String message) async {
    if (kDebugMode) {
      print('Client: $message');
    }
    socket.write(message);
  }
}
