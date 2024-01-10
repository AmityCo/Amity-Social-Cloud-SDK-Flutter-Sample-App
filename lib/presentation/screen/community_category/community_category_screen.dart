import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class CommunityCategoryScreen extends StatefulWidget {
  final String categoryId;
  const CommunityCategoryScreen({super.key, required this.categoryId});

  @override
  State<CommunityCategoryScreen> createState() =>
      _CommunityCategoryScreenState();
}

class _CommunityCategoryScreenState extends State<CommunityCategoryScreen> {
  Future<AmityCommunityCategory>? _future;
  @override
  void initState() {
    _future = AmitySocialClient.newCommunityRepository()
        .getCategory(widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Catergory'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _future,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              if (snapshot.hasData) {
                var category = snapshot.data as AmityCommunityCategory;
                return ListTile(
                  leading: category.avatarId != null
                      ? Image.network(
                          category.avatar!.fileUrl!,
                          fit: BoxFit.fill,
                        )
                      : Image.asset('assets/user_placeholder.png'),
                  title: Text(category.name!),
                  subtitle: Text(category.categoryId!),
                );
              }

              if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              }

              return const Text("No Data");
            }
          }),
        ),
      ),
    );
  }
}
