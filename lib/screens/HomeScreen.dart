import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/AllNotesScreen.dart';
import 'package:student_app/screens/AllTestList.dart';
import 'package:student_app/screens/AnnouncementScreen.dart';
import 'package:student_app/screens/LiveVideoList.dart';
import 'package:student_app/screens/Login.dart';
import 'package:student_app/screens/NativeLiveVideo.dart';
import 'package:student_app/screens/NativeVideoWebView.dart';
import 'package:student_app/screens/PackageHomeScreen.dart';
import 'package:student_app/screens/PerformanceList.dart';
import 'package:student_app/screens/SubjectsScreen.dart';
import 'package:student_app/screens/VideoList.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  StudentUser user = StudentUser();
  HomeScreen(this.user);
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen(user);
  }
}

class _HomeScreen extends State<HomeScreen> {
  StudentUser user = StudentUser();
  _HomeScreen(this.user);
  final FirebaseMessaging _messaging = FirebaseMessaging();
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  bool cancel = false;
  bool toUpdate = false;
  List<dynamic> options = [
    {'name': 'Subjects', 'screen': SubjectsScreen, 'image': 'assets/ebook.png'},
    {
      'name': 'All Videos',
      'screen': VideoList,
      'image': 'assets/videoplayer.png'
    },
    {
      'name': 'All Notes',
      'screen': AllNotesScreen,
      'image': 'assets/notebook.png'
    },
    {'name': 'All Tests', 'screen': AllTestList, 'image': 'assets/exam.png'},
    {
      'name': 'Performance',
      'screen': PerformanceList,
      'image': 'assets/exam1.png'
    },
    {
      'name': 'Packages',
      'screen': PackageHomeScreen,
      'image': 'assets/package.png'
    },
    {'name': 'Attendance', 'screen': '', 'image': 'assets/attendance.png'},
    {
      'name': 'Youtube Live',
      'screen': LiveVideoList,
      'image': 'assets/live.png'
    },
    {
      'name': 'Live Videos',
      'screen': NativeLiveVideo,
      'image': 'assets/youtube.png'
    },
    {
      'name': 'Announcements',
      'screen': AnnouncementScreen,
      'image': 'assets/messages.png'
    },
  ];
  homeScreenBanners(key) async {
    var response = await getHomeScreenBanners(key);
    return response['banners'];
  }

  _launchUrl(finalURL) async {
    if (await canLaunch(finalURL)) {
      await launch(finalURL);
    } else {
      throw "Could not open url";
    }
  }

  isUpdateApp(context) async {
    var currentVersion;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var version = packageInfo.version;
    //print('version ${version.toString()} ${version.runtimeType.toString()}');
    currentVersion = int.parse(version.split('.').last);
    print('current version ${currentVersion.toString()}');
    var response = await checkUpdate(user.key, currentVersion);
    if (response['status'] == 'Success') {
      setState(() {
        toUpdate = response['update'];
        //toUpdate = true;
      });
      if (toUpdate) {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                content: Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'New version of this app is available with bugs fixed and new features. Do you want to update?',
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.black,
                            child: Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              print('update');
                              PackageInfo packageInfo =
                                  await PackageInfo.fromPlatform();
                              String playStoreUrl =
                                  "https://play.google.com/store/apps/details?id=";
                              String packageName = packageInfo.packageName;
                              String finalURL = playStoreUrl + packageName;
                              _launchUrl(finalURL);
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _messaging.getToken().then((token) async {
      var response = await studentUpdateFirebaseToken(user.key, token);
    });
    SchedulerBinding.instance.addPostFrameCallback((_) => isUpdateApp(context));
  }

  showLoader(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }

  instituteInformation() async {
    var info = await getInstituteInformation(user.key);
    return info;
  }

  showLogoutDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  Text('Are you sure you want to logout?',
                      style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                          color: Colors.black,
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            SharedPreferences prefs = await preferences;
                            prefs.clear();
                            setState(() {
                              cancel = false;
                            });
                            Navigator.pop(context);
                          }),
                      RaisedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          setState(() {
                            cancel = true;
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: CircleAvatar(
                    radius: 25,
                    child: ClipOval(
                      child: Image.asset('assets/logo.png'),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text('Welcome to ' + user.institute,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.bold)),
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  await showLogoutDialog(context);
                  if (cancel == false) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  }
                },
                child:
                    Icon(Icons.settings_power, color: Colors.black, size: 30),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: homeScreenBanners(user.key),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.data != null) {
                      var links = snapshot.data;
                      return Container(
                        child: CarouselSlider(
                          height: 280.0,
                          items: links.map<Widget>((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: CachedNetworkImage(
                                      imageUrl: i,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ));
                              },
                            );
                          }).toList(),
                        ),
                      );
                    } else {
                      return CircularProgressIndicator(
                        backgroundColor: Colors.deepOrange,
                      );
                    }
                    // else {
                    //   return CarouselSlider(
                    //     height: 200.0,
                    //     items: ['Loading', 'Loading'].map((i) {
                    //       return Builder(
                    //         builder: (BuildContext context) {
                    //           return Container(
                    //               width: MediaQuery.of(context).size.width,
                    //               margin: EdgeInsets.symmetric(horizontal: 5.0),
                    //               decoration: BoxDecoration(color: Colors.amber),
                    //               child: Text(
                    //                 'text $i',
                    //                 style: TextStyle(fontSize: 16.0),
                    //               ));
                    //         },
                    //       );
                    //     }).toList(),
                    //   );
                    // }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        showLoader(context);
                        PackageInfo packageInfo =
                            await PackageInfo.fromPlatform();
                        String playStoreUrl =
                            "https://play.google.com/store/apps/details?id=";
                        String packageName = packageInfo.packageName;
                        Navigator.pop(context);
                        Share.share(playStoreUrl + packageName);
                      },
                      child: Text('Share App', style: TextStyle(fontSize: 10)),
                    ),
                    GestureDetector(
                      onTap: () async {
                        showLoader(context);
                        var info = await instituteInformation();
                        String aboutUs = info['aboutUs'];
                        if (aboutUs != null || aboutUs != '') {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NativeVideoWebView(aboutUs)));
                        } else {
                          Fluttertoast.showToast(msg: 'No about us found.');
                          Navigator.pop(context);
                        }
                      },
                      child: Text('About Us', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: GridView.count(
                crossAxisCount: 3,
                children: options.map<Widget>((e) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        if (e['screen'].toString() == 'VideoList') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoList(user)));
                        } else if (e['screen'].toString() == 'SubjectsScreen') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubjectsScreen(user)));
                        } else if (e['screen'].toString() == 'AllTestList') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllTestList(user)));
                        } else if (e['screen'].toString() ==
                            'PerformanceList') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PerformanceList(user)));
                        } else if (e['screen'].toString() == 'LiveVideoList') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LiveVideoList(user)));
                        } else if (e['screen'].toString() ==
                            'PackageHomeScreen') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PackageHomeScreen(user)));
                        } else if (e['screen'].toString() == 'AllNotesScreen') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllNotesScreen(user)));
                        } else if (e['screen'].toString() ==
                            'NativeLiveVideo') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NativeLiveVideo(user)));
                        } else if (e['screen'].toString() ==
                            'AnnouncementScreen') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnnouncementScreen(user)));
                        }
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          // side: BorderSide(
                          //     width: 1, color: Colors.orangeAccent)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            e['image'] == null
                                ? Icon(Icons.ac_unit)
                                : Image.asset(
                                    e['image'],
                                    height: MediaQuery.of(context).size.height *
                                        0.035,
                                    // width: MediaQuery.of(context).size.width*0.08,
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                e['name'],
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
// class HomeScreen extends StatefulWidget {
// StudentUser user = StudentUser();
// HomeScreen(this.user);
// @override
// State<StatefulWidget> createState() {
// return _HomeScreen(user);
// }
// }
//
// class _HomeScreen extends State<HomeScreen> {
// StudentUser user = StudentUser();
// _HomeScreen(this.user);
// final FirebaseMessaging _messaging = FirebaseMessaging();
// List<dynamic> options = [
// {'name': 'Subjects', 'screen': SubjectsScreen},
// {'name': 'All Videos', 'screen': VideoList},
// {'name': 'All Notes', 'screen': AllNotesScreen},
// {'name': 'All Tests', 'screen': AllTestList},
// {'name': 'Test Performance', 'screen': PerformanceList},
// {'name': 'Packages', 'screen': PackageHomeScreen},
// {'name': 'My Attendance', 'screen': ''},
// {'name': 'Live Videos', 'screen': LiveVideoList},
// ];
// homeScreenBanners(key) async {
// var response = await getHomeScreenBanners(key);
// print('banners' + response['banners'].toString());
// return response['banners'];
// }
//
// @override
// void initState() {
// super.initState();
// _messaging.getToken().then((token) async {
// print('studen ttoken ${token}');
// var response = await studentUpdateFirebaseToken(user.key, token);
// print('firebase token response ${response.toString()}');
// });
// }
//
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// body: Container(
// child: Column(
// children: <Widget>[
// SizedBox(
// height: 40,
// ),
// FutureBuilder(
// future: homeScreenBanners(user.key),
// builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
// if (snapshot.data != null) {
// var links = snapshot.data;
// print('link ${links.toString()}');
// return Container(
// child: CarouselSlider(
// height: 200.0,
// items: links.map<Widget>((i) {
// print(i.toString());
// return Builder(
// builder: (BuildContext context) {
// return Container(
// width: MediaQuery.of(context).size.width,
// margin: EdgeInsets.symmetric(horizontal: 5.0),
// decoration: BoxDecoration(color: Colors.white),
// child: Image.network(i));
// },
// );
// }).toList(),
// ),
// );
// } else {
// return CarouselSlider(
// height: 200.0,
// items: ['Loading', 'Loading'].map((i) {
// return Builder(
// builder: (BuildContext context) {
// return Container(
// width: MediaQuery.of(context).size.width,
// margin: EdgeInsets.symmetric(horizontal: 5.0),
// decoration: BoxDecoration(color: Colors.amber),
// child: Text(
// 'text $i',
// style: TextStyle(fontSize: 16.0),
// ));
// },
// );
// }).toList(),
// );
// }
// },
// ),
// Expanded(
// child: GridView.count(
// crossAxisCount: 3,
// children: options.map<Widget>((e) {
// print('e ${e.toString()}');
// print('e name ${e['name']}');
// return GestureDetector(
// onTap: (){
// print('pressed ${e['screen'].toString()}');
// if (e['screen'].toString() == 'VideoList') {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => VideoList(user)));
// } else if (e['screen'].toString() ==
// 'SubjectsScreen') {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// SubjectsScreen(user)));
// } else if (e['screen'].toString() == 'AllTestList') {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => AllTestList(user)));
// } else if (e['screen'].toString() ==
// 'PerformanceList') {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// PerformanceList(user)));
// } else if (e['screen'].toString() ==
// 'LiveVideoList') {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => LiveVideoList(user)));
// } else if (e['screen'].toString() ==
// 'PackageHomeScreen') {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// PackageHomeScreen(user)));
// }
// else if (e['screen'].toString() ==
// 'AllNotesScreen') {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// AllNotesScreen(user)));
// }
//
//
// },
// child: Card(
//
// elevation: 1,
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: <Widget>[
// Icon(
// Icons.ac_unit,
// size: 30,
// ),
//
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// e['name'],
// style: TextStyle(
// fontSize: 10, fontWeight: FontWeight.bold),
// ),
// )
// ],
// ),
// ),
// );
// }).toList(),
// ))
// ],
// ),
// ),
// );
// }
// }
//
