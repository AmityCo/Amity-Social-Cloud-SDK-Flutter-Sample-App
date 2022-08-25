import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/widgets.dart';

class AmityLiveCollectionHasNext {
  late LiveCollection messageLiveCollection;
  List<AmityMessage> amityMessages = [];
  final scrollcontroller = ScrollController();
  /* begin_sample_code
    gist_id: c244b0dda92d25a264f820884d8fc667
    filename: AmityLiveCollectionHasNext.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter live collection example
    */
  void initState(String channelId) {
    messageLiveCollection = AmityChatClient.newMessageRepository()
        .getMessages(channelId)
        .stackFromEnd(true)
        .getLiveCollection(pageSize: 20);

    messageLiveCollection.asStream().listen((event) {
      // update latest results here
      // setState(() {
      //   amityMessages = event;
      // });
    });
     
    //load first page when initiating widget
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      messageLiveCollection.loadNext();
    });

    scrollcontroller.addListener(paginationListener);
  }

  void paginationListener() {
    if ((scrollcontroller.position.pixels >=
            (scrollcontroller.position.maxScrollExtent - 100)) &&
        messageLiveCollection.hasNextPage()) {
      messageLiveCollection.loadNext();
    }
  }

  /* end_sample_code */
}
