import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swash/exceptions/network.dart';
import 'package:swash/path.dart';
import 'dart:convert';

Future<String> addPrize(
    {required String content, required String points, XFile? image}) async {
  var request =
      MultipartRequest('post', Uri.parse(AppPath.domain + '/add_prize.php'));
  request.fields['content'] = content;
  request.fields['points'] = points;
  if (image != null) {
    request.files.add(await MultipartFile.fromPath('image', image.path));
  }
  StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    Map<String, dynamic> data =
        jsonDecode(await response.stream.bytesToString());
    if (data['status']) {
      return data['message'];
    } else {
      return Future.error(NetworkError(msg: data['message']));
    }
  }
  return Future.error(NetworkError(msg: 'something went wrong'));
}
