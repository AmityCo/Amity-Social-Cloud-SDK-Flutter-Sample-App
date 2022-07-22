import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/presentation/screen/global_feed/global_feed_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/user_profile/user_profile_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _bottomSheetIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _bottomSheetIndex = index;
          });
        },
      ),
    );
  }

  Widget _getBody() {
    switch (_bottomSheetIndex) {
      case 0:
        return const GlobalFeedScreen();
      case 2:
        return UserProfileScreen(
          userId: AmityCoreClient.getUserId(),
        );
      default:
        return Container();
    }
  }
}
