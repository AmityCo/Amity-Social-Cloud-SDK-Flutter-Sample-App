import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIdTextController = TextEditingController();
  final _displayNameTextController = TextEditingController();
  final _apiKeyTextController = TextEditingController();
  final _serverUrlTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //STAGING Server
    // _userIdTextController.text = 'victimAndroid';
    // _displayNameTextController.text = 'Victim Android';
    // _apiKeyTextController.text =
    //     'b3bee858328ef4344a308e4a5a091688d05fdee2be353a2b';
    // _serverUrlTextController.text = AmityRegionalHttpEndpoint.STAGING.value;

    //SG Server
    //1
    // _userIdTextController.text = 'johnwick2';
    // _displayNameTextController.text = 'John Wick';
    // _apiKeyTextController.text =
    //     'b3babb0b3a89f4341d31dc1a01091edcd70f8de7b23d697f';
    // _serverUrlTextController.text = AmityRegionalHttpEndpoint.SG.value;

    //2
    _userIdTextController.text = 'userB_80835352';
    _displayNameTextController.text = 'User userB_80835352';
    _apiKeyTextController.text =
        'b3bee90c39d9a5644831d84e5a0d1688d100ddebef3c6e78';
    _serverUrlTextController.text = AmityRegionalHttpEndpoint.SG.value;

    //US Server
    // _apiKeyTextController.text =
    //     'b0eeed0f3fd2a4311d658d1f030e168884008ce0e8673924';
    // _serverUrlTextController.text = AmityRegionalHttpEndpoint.US.value;

    ThemeData _themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text('ASC Flutter SDK', style: _themeData.textTheme.headline6),
              const SizedBox(height: 24),
              TextFormField(
                controller: _userIdTextController,
                decoration: const InputDecoration(
                  label: Text('User Id'),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _displayNameTextController,
                decoration: const InputDecoration(
                  label: Text('Display name'),
                ),
              ),
              const SizedBox(height: 48),
              TextFormField(
                controller: _apiKeyTextController,
                decoration: const InputDecoration(
                  label: Text('Api Key'),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _serverUrlTextController,
                decoration: const InputDecoration(
                  label: Text('Server url'),
                ),
              ),
              const SizedBox(height: 48),
              TextButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus!.unfocus();
                  // Setup the Amity Option First
                  String apikey = _apiKeyTextController.text.trim();
                  String serverUrl = _serverUrlTextController.text.trim();
                  final data = await AmityCoreClient.setup(
                    option: AmityCoreClientOption(
                        apiKey: apikey,
                        httpEndpoint: AmityRegionalHttpEndpoint.values
                            .where((element) => element.value == serverUrl)
                            .first,
                        showLogs: true),
                    sycInitialization: true,
                  );

                  // await Future.delayed(Duration(seconds: 1));

                  //Login the user
                  String userId = _userIdTextController.text.trim();
                  String userDisplayName =
                      _displayNameTextController.text.trim();
                  await AmityCoreClient.login(userId)
                      .displayName(userDisplayName)
                      .submit();

                  GoRouter.of(context).go(AppRoute.homeRoute);
                  // Go.of(context).Navigator.of(context).pushReplacement(
                  //       MaterialPageRoute(
                  //         builder: (context) => const DashboardScreen(),
                  //       ),
                  //     );
                },
                child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: const Text('Login'),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  primary: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
