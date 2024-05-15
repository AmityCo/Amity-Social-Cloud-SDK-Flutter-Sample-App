import 'dart:math';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class ValidateTextScreen extends StatefulWidget {
  const ValidateTextScreen({super.key});

  @override
  State<ValidateTextScreen> createState() => _ValidateTextScreenState();
}

class _ValidateTextScreenState extends State<ValidateTextScreen> {
  final TextEditingController _validateTextController = TextEditingController();
  bool? isValid = null;
  bool isLoading = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate Text'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter Text seperated by comma',
                ),
                controller: _validateTextController,
                onChanged: (value) {
                  _validateTextController.text = value;
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              if (isLoading) const CircularProgressIndicator(),
              isValid != null ? Text('Is Valid -> : $isValid') : const SizedBox(),
              const SizedBox(height: 16),
              if (errorText != null) Text('Error -> : $errorText'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                    isValid = false;
                    errorText == null; 
                  });
                  var list = _validateTextController.text.split(',');
                  AmityCoreClient().validateTexts(list).then((value) {
                    print("Results --->  $value");
                    setState(() {
                      isLoading = false;
                      isValid = value;
                    });
                  }).onError((error, stackTrace) {
                    setState(() {
                      isLoading = false;
                      isValid = null;
                      print("Error --->  $error");
                      errorText = error.toString();
                    });
                  });
                },
                child: const Text('Validate Texts'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
