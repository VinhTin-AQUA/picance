// Future<bool> checkInternetConnection() async {
//   var connectivityResult = await Connectivity().checkConnectivity();
//   return connectivityResult != ConnectivityResult.none;
// }

// // Sử dụng:
// void someNetworkOperation() async {
//   if (!await checkInternetConnection()) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const NoInternetScreen()),
//     );
//     return;
//   }

//   // Tiếp tục các thao tác cần mạng
// }
