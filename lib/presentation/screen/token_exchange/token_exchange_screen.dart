import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/positive_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';

class TokenExchangeScreen extends StatefulWidget {
  const TokenExchangeScreen({Key? key}) : super(key: key);

  @override
  State<TokenExchangeScreen> createState() => _TokenExchangeScreenState();
}

class _TokenExchangeScreenState extends State<TokenExchangeScreen> {
  late BuildContext _context;

  final _userIdTextEditController = TextEditingController();
  final _displaynameTextEditController = TextEditingController();
  final _secureTokenTextEditController = TextEditingController();

  @override
  void initState() {
    _userIdTextEditController.text = "victimAndroid";
    _displaynameTextEditController.text = "victimAndroid";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Get user token')),
      body: Builder(builder: (context) {
        _context = context;
        return Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _userIdTextEditController,
                decoration: const InputDecoration(
                  label: Text('UserId*'),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _displaynameTextEditController,
                decoration: const InputDecoration(
                  label: Text('Displayname (Optional)'),
                ),
              ),
              TextFormField(
                controller: _secureTokenTextEditController,
                decoration: const InputDecoration(
                  label: Text('Secure token (Optional)'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () async {
                    ProgressDialog.show(context, asyncFunction: getUserToken)
                        .then((value) {
                      PositiveDialog.show(
                        context,
                        title: 'User token result',
                        message: 'accessToken: ${value.accessToken}',
                      );
                    }).onError((error, stackTrace) {
                      ErrorDialog.show(context,
                          title: 'Error', message: error.toString());
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(12),
                  ),
                  child: Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: RichText(
                        text: const TextSpan(children: [
                      TextSpan(text: 'Exchange!'),
                    ])),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Future<AmityUserToken> getUserToken() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final userId = _userIdTextEditController.text.trim();
    final displayname = _displaynameTextEditController.text.trim();
    final secureToken = _secureTokenTextEditController.text.trim();

    return await AmityUserTokenManager(
            apiKey: "b0eeed0f3fd3f5614b31894d560e1688845adeeabe3c3d25",
            endpoint: AmityRegionalHttpEndpoint.SG)
        .createUserToken(userId,
            displayname: displayname, secureToken: secureToken);
  }
}
