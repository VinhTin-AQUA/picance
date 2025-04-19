import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityPlusUtil {
  static Future<bool> checkInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }
}
