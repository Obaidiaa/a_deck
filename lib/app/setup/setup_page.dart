// setting page

import 'dart:async';
import 'dart:io';

import 'package:a_deck/app/home/home_page.dart';
import 'package:a_deck/app/models/settings.dart';
import 'package:a_deck/app/setup/setup_view_model.dart';
import 'package:a_deck/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({Key? key, this.settings}) : super(key: key);
  final Settings? settings;

  static Future<void> show(BuildContext context, {Settings? settings}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.setupPage,
      arguments: settings,
    );
  }

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<SetupPage> {
  final _formKey = GlobalKey<FormState>();

  String? _serverIP;
  String? _serverPort;

  @override
  void initState() {
    super.initState();
    // print(setupProvider.state);
    // final loadedSetting = ref.read(setupViewModelProvider);
    // // if (loadedSetting.serverIp != null) {
    // _serverIP = loadedSetting.serverIp;
    // _serverPort = loadedSetting.serverPort;
    // }
  }

  onSetSetting(WidgetRef ref, String? serverIP, String serverPort) {
    ref.read(setupViewModelProvider).setSettings(serverIP, serverPort);
  }

  String? _validateIp(String? value) {
    if (InternetAddress.tryParse(value!) != null) {
      return null;
    }
    return "false";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Setup")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Column(
              children: [
                const Text(
                  'Setup Server',
                  style: TextStyle(fontSize: 46),
                ),
                _buildContents(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    final _serverIPController = TextEditingController(text: _serverIP);
    final _serverPortController = TextEditingController(text: _serverPort);

    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Server IP'),
        keyboardAppearance: Brightness.light,
        validator: (value) => _validateIp(value),
        controller: _serverIPController,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Server Port'),
        keyboardAppearance: Brightness.light,
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        controller: _serverPortController,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 25),
        child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Settings saved'),
                      backgroundColor: Colors.green),
                );
                onSetSetting(
                    ref, _serverIPController.text, _serverPortController.text);
                const HomePage();
              }
            },
            child: const Text("Submit")),
      )
    ];
  }
}
