import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../toasty.dart';
import 'dart:convert';
import '../path.dart';

Future postEvent(
    {required String title,
    required String descriptions,
    required http.MultipartFile? multipartFile,
    required String mediaType,
    String duration = '',
    required String userID}) async {
  var request = http.MultipartRequest(
      "POST", Uri.parse('${AppPath.domain}/post_event.php'));

  if (multipartFile != null) {
    request.files.add(multipartFile);
  }

  request.fields['user_id'] = userID;
  request.fields['duration'] = duration;
  request.fields['title'] = title;
  request.fields['descriptions'] = descriptions;
  request.fields['media_type'] = mediaType;

  var response = await request.send();
  if (response.statusCode == 200) {
    var resp = await response.stream.bytesToString();
    print(resp);
    var data = jsonDecode(resp);

    if (data['status'] == true) {
      Toasty().show(data['message'], Toast.LENGTH_SHORT, ToastGravity.TOP);
    } else {
      Toasty().show(data['message'], Toast.LENGTH_SHORT, ToastGravity.TOP);
    }
  } else {
    Toasty().show("Failed to ", Toast.LENGTH_SHORT, ToastGravity.TOP);
  }
}
