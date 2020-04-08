import 'dart:convert';
import 'dart:async';
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/screens/ChangePasswordOTP.dart';
import 'package:http/http.dart' as http;
import 'package:student_app/pojos/ContentPojo.dart';

Future studentLogin(username, password) async {
  StudentUser studentUser = StudentUser();
  Map<String, String> body = {
    'username': username,
    'password': password,
  };
  var headers = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  String url = 'http://15.206.150.90/api/membership/login_student/';
  var data = await http.post(url, body: body, headers: headers);
  print('student login data ${data.toString()}');
  if (data.statusCode == 200 || data.statusCode == 201) {
    var response = json.decode(data.body);
    studentUser = StudentUser.fromJson(response);
    String key = studentUser.key;
    print(key);
    return studentUser;
  } else {
    print(data.body);
  }
}

Future studentRegister(name, username, password, instituteCode) async {
  Map<String, String> body = {
    'name': name,
    'username': username,
    'password': password,
    'institute_code': instituteCode,
  };
  var headers = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  String url = 'http://15.206.150.90/api/membership/register_student/';
  var data = await http.post(url, body: body, headers: headers);
  print('student register data ${data.toString()}');
  if (data.statusCode == 200 || data.statusCode == 201) {
    var response = json.decode(data.body);
    //studentUser = StudentUser.fromJson(response);
    //String key = studentUser.key;
    //print(key);
    return response;
  } else {
    print(data.body);
  }
}

Future getHomeScreenBanners(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url =
      'http://15.206.150.90/api/basicinformation/student_homescreen_banners/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print(response);
    return response;
  } else {
    print(data.statusCode.toString());
  }
}

Future getAllVideos(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/content/student_all_videos/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print(response);
    return response;
  } else {
    print(data.statusCode.toString());
  }
}

Future getAllSubjects(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/basicinformation/student_subjects/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print(response);
    return response;
  } else {
    print(data.statusCode.toString());
  }
}

Future getSubjectChapters(key, subjectId) async {
  Map<String, String> body = {
    'subject_id': jsonEncode(subjectId),
  };
  var headers = {
    'Authorization': 'token $key',
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  String url =
      'http://15.206.150.90/api/basicinformation/student_subject_chapters/';
  var data = await http.post(url, body: body, headers: headers);
  print('student login data ${data.toString()}');
  if (data.statusCode == 200 || data.statusCode == 201) {
    var response = json.decode(data.body);
    print(' chapters ${response.toString()}');
    return response;
  } else {
    print(data.body);
  }
}

Future getAllTests(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/content/student_all_tests/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print(response);
    return response;
  } else {
    print(data.statusCode.toString());
  }
}

Future getIndividualTest(key, testId) async {
  Test test = Test();
  Map<String, String> body = {
    'test_id': jsonEncode(testId),
  };
  var headers = {
    'Authorization': 'token $key',
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  String url = 'http://15.206.150.90/api/content/student_get_test/';
  var data = await http.post(url, body: body, headers: headers);
  print('student login data ${data.toString()}');
  if (data.statusCode == 200 || data.statusCode == 201) {
    var response = json.decode(data.body);
    print('test respones ${response.toString()}');
    test = Test.fromJson(response['test']);
    print(' teest ${test.toString()}');
    return test;
  } else {
    print(data.body);
  }
}

submitTest(key, testId, answers, totalTime) async {
  var body = {
    'test_id': testId.toString(),
    'answers': jsonEncode(answers.toString()),
    'totalTime': jsonEncode(totalTime),
  };
  var headers = {
    "Authorization": "token $key",
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  String url = 'http://15.206.150.90/api/content/evaluate_test/';
  var encoding = Encoding.getByName("utf-8");
  var data =
      await http.post(url, body: body, headers: headers, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print(responseCode);
    return responseCode;
  } else {
    print(data.statusCode);
  }
}

getTestPerformance(key, performanceId) async {
  //TestSubmitData testPerformance = TestSubmitData();
  var body = {
    'marks_id': performanceId.toString(),
  };
  var headers = {
    "Authorization": "token $key",
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  String url = 'http://15.206.150.90/api/content/student_test_performance/';
  var encoding = Encoding.getByName("utf-8");
  var data =
      await http.post(url, body: body, headers: headers, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('response code ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }
}

Future getTakenTests(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/content/student_taken_test_list/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print(response);
    return response;
  } else {
    print(data.statusCode.toString());
  }
}

Future getNotBoughtPackages(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/content/student_not_bought_packages/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('not bougth packages ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
  }
}

Future getBoughtPackages(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/content/student_get_bought_packages/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('get bougth packages ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
  }
}

getIndividualPackageDetails(key, packageId) async {
  var body = {
    'package_id': packageId.toString(),
  };
  var headers = {
    "Authorization": "token $key",
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  String url = 'http://15.206.150.90/api/content/student_individual_package/';
  var encoding = Encoding.getByName("utf-8");
  var data =
      await http.post(url, body: body, headers: headers, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('individual package details ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }
}

studentBuyPackage(key, packageId, amount) async {
  var body = {
    'package_id': packageId.toString(),
    'amount': amount.toString(),
  };
  var headers = {
    "Authorization": "token $key",
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  String url = 'http://15.206.150.90/api/content/student_buy_package/';
  var encoding = Encoding.getByName("utf-8");
  var data =
      await http.post(url, body: body, headers: headers, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('student buy package  ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }
}

studenCheckTakenTest(key, testId) async {
  var body = {
    'test_id': testId.toString(),
  };
  var headers = {
    "Authorization": "token $key",
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  String url = 'http://15.206.150.90/api/content/student_check_test_taken/';
  var encoding = Encoding.getByName("utf-8");
  var data =
      await http.post(url, body: body, headers: headers, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('student test taken  ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }
}

studentUpdateFirebaseToken(key, token) async {
  var body = {
    'token': token.toString(),
  };
  var headers = {
    "Authorization": "token $key",
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  String url =
      'http://15.206.150.90/api/content/student_firebase_token_update/';
  var encoding = Encoding.getByName("utf-8");
  var data =
      await http.post(url, body: body, headers: headers, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('student firebase token  ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }
}

changePasswordOTP(phone) async {
  var body = {
    'phone': phone.toString(),
  };
  String url = 'http://15.206.150.90/api/membership/forget_password_send_otp/';
  var encoding = Encoding.getByName("utf-8");
  var data = await http.post(url, body: body, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('change otp  ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }
}

changePassword(phone, password) async {
  var body = {
    'username': phone.toString(),
    'new_password': password.toString(),
  };
  String url = 'http://15.206.150.90/api/membership/change_password/';
  var encoding = Encoding.getByName("utf-8");
  var data = await http.post(url, body: body, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('change password  ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }
}

getChapterNotes(key, chapterId) async {
  var body = {
    'chapter_id': chapterId.toString(),
  };
  var headers = {
    'Authorization': 'token $key',
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  String url = 'http://15.206.150.90/api/content/student_get_chapter_notes/';
  var encoding = Encoding.getByName("utf-8");
  var data =
      await http.post(url, headers: headers, body: body, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('chapter notes  ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }
}

Future getAllNotes(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url =
      'http://15.206.150.90/api/content/student_get_all_notes/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('get notes ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
  }
}
Future getLiveVideoLink(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url =
      'http://15.206.150.90/api/content/student_get_live_video_link/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('live videos ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
  }
}


Future getAgoraLiveVideo(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url =
      'http://15.206.150.90/api/content/student_get_agora_live_video/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('agora live videos ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
  }
}


agoraSendMessage(key, message, videoId) async {
  var body = {
    'message': message.toString(),
    'video_id': jsonEncode(videoId),
  };
  var headers = {
    'Authorization': 'token $key',
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  String url = 'http://15.206.150.90/api/content/student_live_video_message/';
  var encoding = Encoding.getByName("utf-8");
  var data =
      await http.post(url, headers: headers, body: body, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('live video send message  ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }
}

Future getChapterVideos(key,chapterId) async {
  var body = {
    'chapter_id': jsonEncode(chapterId),
  };
  var headers = {
    'Authorization': 'token $key',
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  String url = 'http://15.206.150.90/api/content/student_chapterwise_videos/';
  var encoding = Encoding.getByName("utf-8");
  var data =
      await http.post(url, headers: headers, body: body, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('chapterwise videos  ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }

}

Future getChapterTests(key,chapterId) async {
  var body = {
    'chapter_id': jsonEncode(chapterId),
  };
  var headers = {
    'Authorization': 'token $key',
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  String url = 'http://15.206.150.90/api/content/student_chapterwise_tests/';
  var encoding = Encoding.getByName("utf-8");
  var data =
      await http.post(url, headers: headers, body: body, encoding: encoding);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('chapterwise tests ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }

}


Future getInstituteInformation(key) async {
  var headers = {
    'Authorization': 'token $key',
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  String url = 'http://15.206.150.90/api/basicinformation/student_institute_information/';
  var data =
      await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var responseCode = json.decode(data.body);
    print('institute information ${responseCode.toString()}');
    return responseCode;
  } else {
    print(data.statusCode);
  }

}

Future checkUpdate(key, version) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'version': jsonEncode(version),
  };
  String url = 'http://15.206.150.90/api/basicinformation/student_check_app_version/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('app version ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future allAnnouncements(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/communication/student_all_announcements/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('student announcements ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}