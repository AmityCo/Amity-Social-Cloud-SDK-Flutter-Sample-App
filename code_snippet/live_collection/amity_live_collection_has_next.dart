import 'package:amity_sdk/amity_sdk.dart';

class AmityLiveCollectionHasNext {
  late LiveCollection liveCollection;
  /* begin_sample_code
    gist_id: fd760cbed7685a2b1b4e9debd33fd810
    filename: AmityLiveCollectionHasNext.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter live collection check next page example
    */
  void loadNextPage() async {
    if (liveCollection.hasNextPage()) {
      liveCollection.loadNext();
    }
  }
  /* end_sample_code */
}
