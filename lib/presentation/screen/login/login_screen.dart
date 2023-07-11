import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
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
    //DEV Server
    // _userIdTextController.text = 'victimAndroid';
    // _displayNameTextController.text = 'Victim Android';
    // _apiKeyTextController.text = 'b0ecee0c39dca1651d628b1c535d15dbd30ad9b0eb3c3a2f';
    // _serverUrlTextController.text = AmityRegionalHttpEndpoint.SG.endpoint;

    //STAGING Server
    _userIdTextController.text = 'victimAndroid';
    _displayNameTextController.text = 'Victim Android';
    _apiKeyTextController.text = 'b0efe90c3bdda2304d628918520c1688845889e4bc363d2c';
    _serverUrlTextController.text = AmityRegionalHttpEndpoint.custom('https://api.staging.amity.co/').endpoint;

    //SG Server
    // 1
    // _userIdTextController.text = 'johnwick2';
    // _displayNameTextController.text = 'John Wick';
    // _apiKeyTextController.text = 'b3babb0b3a89f4341d31dc1a01091edcd70f8de7b23d697f';
    // _serverUrlTextController.text = AmityRegionalHttpEndpoint.SG.endpoint;

    //2
    // _userIdTextController.text = 'bb01';
    // _displayNameTextController.text = 'BB01';
    // _apiKeyTextController.text = 'b0eeed0f3fd3f5614b31894d560e1688845adeeabe3c3d25';
    // _serverUrlTextController.text = AmityRegionalHttpEndpoint.SG.endpoint;

    //US Server
    // _apiKeyTextController.text =
    //     'b0eeed0f3fd2a4311d658d1f030e168884008ce0e8673924';
    // _serverUrlTextController.text = AmityRegionalHttpEndpoint.US.value;

    ThemeData themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text('ASC Flutter SDK', style: themeData.textTheme.titleLarge),
              const SizedBox(height: 24),
              TextFormField(
                key: const Key('user_id_txtip'),
                controller: _userIdTextController,
                decoration: const InputDecoration(
                  label: Text('User Id'),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                key: const Key('display_name_txtip'),
                controller: _displayNameTextController,
                decoration: const InputDecoration(
                  label: Text('Display name'),
                ),
              ),
              const SizedBox(height: 48),
              TextFormField(
                key: const Key('api_key_txtip'),
                controller: _apiKeyTextController,
                decoration: const InputDecoration(
                  label: Text('Api Key'),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                key: const Key('server_url_txtip'),
                controller: _serverUrlTextController,
                decoration: const InputDecoration(
                  label: Text('Server url'),
                ),
              ),
              const SizedBox(height: 48),
              TextButton(
                key: const Key('Login_btn_id'),
                onPressed: () async {
                  try {
                    FocusManager.instance.primaryFocus!.unfocus();
                    // Setup the Amity Option First
                    String apikey = _apiKeyTextController.text.trim();
                    String serverUrl = _serverUrlTextController.text.trim();
                    await AmityCoreClient.setup(
                      option: AmityCoreClientOption(
                          apiKey: apikey,
                          httpEndpoint: AmityRegionalHttpEndpoint(_serverUrlTextController.text),
                          mqttEndpoint: AmityRegionalMqttEndpoint.custom('ssq.staging.amity.co'),
                          // mqttEndpoint: AmityRegionalMqttEndpoint.SG,
                          showLogs: true),
                      sycInitialization: true,
                    );

                    // await Future.delayed(Duration(seconds: 1));

                    //Login the user
                    String userId = _userIdTextController.text.trim();
                    String userDisplayName = _displayNameTextController.text.trim();
                    await AmityCoreClient.login(userId).displayName(userDisplayName).submit();

                    GoRouter.of(context).go(AppRoute.homeRoute);
                  } catch (error) {
                    CommonSnackbar.showNagativeSnackbar(context, 'Error', error.toString());
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(12),
                ),
                child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: const Text('Login'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
