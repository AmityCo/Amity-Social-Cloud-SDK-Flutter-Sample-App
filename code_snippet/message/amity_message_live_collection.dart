import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/widgets.dart';

class AmityMessageLiveCollection {
  /* begin_sample_code
    gist_id: 5ce897888da3296f244106a25ca8ef1a
    filename: AmityMessageLiveCollection.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message live collection example
    */
  late MessageLiveCollection messageLiveCollection;
  List<AmityMessage> amityMessages = [];
  final scrollcontroller = ScrollController();

  void observMessages(String channelId) {
    //initialize message live collection
    messageLiveCollection = AmityChatClient.newMessageRepository()
        .getMessages(channelId)
        //stack from end = true - means the first message will be last created message
        //compatible with UI that needs the latest message on the bottom of the UI
        //vice versa with stack from end = false - the first message will be first created message
        .stackFromEnd(true)
        .getLiveCollection(pageSize: 20);

    //listen to data changes from live collection
    messageLiveCollection.asStream().stream.listen((event) {
      // update latest results here
      // setState(() {
      amityMessages = event;
      // });
    });

    //load first page when initiating widget
    messageLiveCollection.loadNext();

    //add pagination listener when srolling to top/bottom
    scrollcontroller.addListener(paginationListener);
  }

  void paginationListener() {
    //check if
    //#1 scrolling reached top/bottom
    //#2 live collection has next page to load more
    if ((scrollcontroller.position.pixels >=
            (scrollcontroller.position.maxScrollExtent - 100)) &&
        messageLiveCollection.hasNextPage()) {
      //load next page data
      messageLiveCollection.loadNext();
    }
  }
  /* end_sample_code */
}
