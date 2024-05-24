import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class ValidateUrlScreen extends StatefulWidget {
  const ValidateUrlScreen({super.key});

  @override
  State<ValidateUrlScreen> createState() => _ValidateUrlScreenState();
}

class _ValidateUrlScreenState extends State<ValidateUrlScreen> {
  final TextEditingController _validateTextController = TextEditingController();
  bool? isValid = null; 
  bool isLoading = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate URL'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter URL seperated by comma',
                ),
                controller: _validateTextController,
                onChanged: (value) {
                  _validateTextController.text = value;
                  setState(() {});
                },
              ),  
              const SizedBox(height: 16),
              if(isLoading) const CircularProgressIndicator(),
              isValid!=null? Text('Is Valid -> : $isValid'): const SizedBox(),
              const SizedBox(height: 16),
              if (errorText != null) Text('Error -> : $errorText'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async  {
                  setState(() {
                    isLoading = true;
                    isValid = false;
                    errorText == null; 
                  });
                  var list = _validateTextController.text.split(',');
                  AmityCoreClient().validateUrls(list).then((value){
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