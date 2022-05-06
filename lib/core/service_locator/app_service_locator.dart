import 'package:get_it/get_it.dart';

final sl = GetIt.asNewInstance(); //sl is referred to as Service Locator

class AppServiceLocator {
//Dependency injection
  static Future<void> initServiceLocator({bool syc = false}) async {
    DateTime startTime = DateTime.now();

    print('>>>>>> Init all the dependenciies');

    DateTime endTime = DateTime.now();

    print(
        '>> Time took to initilize the DI ${endTime.difference(startTime).inMilliseconds} Milis');
  }
}
