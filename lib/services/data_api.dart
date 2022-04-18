// load data from server

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:a_deck/app/models/command.dart';
import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/services/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// final dataApiProvider = Provider.autoDispose<DataApi>((ref) {
//   final settings = ref.watch(sharedPreferencesServiceProvider);
//   return DataApi(settings: settings.getSettings());
// });

final dataProvider = StateNotifierProvider<DataApi, List<Command>>((ref) {
  final settings = ref.watch(sharedPreferencesServiceProvider);
  return DataApi(settings: settings, ref: ref);
});

final webSocketConnectionStatusProvider =
    StateNotifierProvider<WebSocketConnectionStatus, bool>(((ref) {
  return WebSocketConnectionStatus(false);
}));

class WebSocketConnectionStatus extends StateNotifier<bool> {
  WebSocketConnectionStatus(bool state) : super(state) {
    // Future.delayed(const Duration(milliseconds: 2000), () async {
    //   // state = d;
    //   setConnectionStatus(true);
    // });
  }

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
    // var commandsJson = jsonEncode(d.map((e) => e.toJson()).toList());
    // print(commandsJson);
    if (isWebsocketRunning) return; //check if its already running
    // const url = 'wss://192.168.100.191:7777';
    // connect to the socket server
    socket = await Socket.connect('192.168.100.191', 7777);

    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
    ref
        .read(webSocketConnectionStatusProvider.notifier)
        .setConnectionStatus(true);
    isWebsocketRunning = true;
    send();
    // listen for responses from the server
    socket.listen(
      // handle data from the server
      (Uint8List data) async {
        final serverResponse = String.fromCharCodes(data);
        print(serverResponse);

        try {
          final List<dynamic> json = jsonDecode(serverResponse);
          final List<Command> commandsList =
              json.map((e) => Command.fromJson(e)).toList();
          state = commandsList;
        } catch (e) {
          state = [];
        }
        print('Server: $serverResponse');
      },

      // handle errors
      onError: (error) {
        isWebsocketRunning = false;
        ref
            .read(webSocketConnectionStatusProvider.notifier)
            .setConnectionStatus(false);
        print('errrrorr $error');
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
        print('Server left.');
        socket.destroy();
        startClient();
      },
    );
  }

  Stream<dynamic> getImageById(String imageID) {
    WebSocketChannel _btcWebsocket = WebSocketChannel.connect(
      Uri.parse('ws://192.168.100.191:8888'),
    );
    _btcWebsocket.sink
        .add(json.encode({'command': 'getImage', 'parameters': imageID}));
    return _btcWebsocket.stream;
  }

  Future re2(Stream<dynamic> socket) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var file = File(tempPath + '/tempimage.png').openWrite();
    // var file = File('tempimage').openWrite();
    try {
      await socket.map(toIntList2).pipe(file);
    } finally {
      file.close();
      print(
          'Done 2 File downloaded ${File(tempPath + '/tempimage.png').path} ${await File(tempPath + '/tempimage.png').length()}');
      String filePath = File(tempPath + '/1').path;
      String fileName = filePath.split('/').last;

      state = [
        for (final command in state)
          if (command.id == fileName)
            Command(
                id: command.id,
                name: command.name,
                command: command.command,
                picture: filePath)
          else
            command
      ];
      print(jsonEncode(state));
    }
  }

  List<int> toIntList2(dynamic source) {
    print(source);
    return List.from(source);
  }

  List<Command>? listCommands;
  final List<Command> d = [
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
  @override
  List<Command> get state => super.state;

  List<int> toIntList(Uint8List source) {
    // print(source);
    return List.from(source);
  }

  void send() {
    sendMessage(
        socket, json.encode({'command': 'getCommandsList', 'parameters': ''}));
  }

  Future<void> sendMessage(Socket socket, String message) async {
    print('Client: $message');
    socket.write(message);
    await Future.delayed(Duration(seconds: 2));
  }

  apiGetCommands() {
    return Future.delayed(const Duration(milliseconds: 2000), () async {
      // state = d;
    });
  }

  getImage(String id) {
    return socket.write('{"getImage" : "1"}');
  }
}
