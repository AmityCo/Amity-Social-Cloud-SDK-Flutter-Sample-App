class ReactionUtils {
  static String getReactionAssets(String reaction) {
    switch (reaction) {
      case 'like':
        return 'assets/ic_like.png';
      case 'love':
        return 'assets/ic_heart.png';
      case 'heart':
        return 'assets/ic_heart.png';
      default:
        return 'assets/ic_like.png';
    }
  }

  static String getActiveReactionAssets(String reaction) {
    switch (reaction) {
      case 'like':
        return 'assets/ic_liked.png';
      case 'love':
        return 'assets/ic_heart.png';
      case 'heart':
        return 'assets/ic_heart.png';
      default:
        return 'assets/ic_liked.png';
    }
  }
}
