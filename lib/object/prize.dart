import 'package:swash/exceptions/network.dart';
import 'package:swash/models/prize.dart';
import '../path.dart';
import 'package:http/http.dart';
import 'dart:convert';

Future<bool> isTherePrize() async {
  Response response = await post(
    Uri.parse('${AppPath.domain}/prize.php'),
  );

  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    if (data['status']) {
      return true;
    } else {
      // print(data['message']);
      return false;
    }
  } else {
    return Future.error(NetworkError(msg: 'something is wrong'));
  }
}

Future<Prize> getPrize() async {
  Response response = await get(Uri.parse(AppPath.api + '/get_prize.php'));

  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    if (data['status']) {
      return Prize.fromjson(data['message']);
    } else {
      return Future.error(
          NetworkError(msg: data['message'] ?? 'something is wrong'));
    }
  }
  return Future.error(
      NetworkError(msg: data['message'] ?? 'something is wrong'));
}
