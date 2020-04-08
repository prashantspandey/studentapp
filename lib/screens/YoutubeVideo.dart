// import 'package:student_app/pojos/basic.dart';
// import 'package:student_app/screens/VideoList.dart';
// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// 
// class YoutubeVideo extends StatefulWidget {
  // StudentUser user = StudentUser();
  // String videoId;
  // YoutubeVideo(this.user, this.videoId);
  // @override
  // State<StatefulWidget> createState() {
    // return _YoutubeVideo(user);
  // }
// }
// 
// class _YoutubeVideo extends State<YoutubeVideo> {
  // StudentUser user = StudentUser();
  //static String videoId;
  // static String vidId = 'gZaVvHsiAUk';
  // YoutubePlayerController _controller;
  // _YoutubeVideo(this.user);
  // @override
  // void initState() {
    // super.initState();
   // videoId = widget.videoId;
    // print('video Id ${widget.videoId.toString()}');
    // _controller = YoutubePlayerController(
      // initialVideoId: vidId,
      // flags: YoutubePlayerFlags(
        // isLive: true,
        // autoPlay: true,
      // ),
    // );
  // }
// 
  // @override
  // Widget build(BuildContext context) {
    // return Scaffold(
      // appBar: AppBar(
        // title: Text('Live Video'),
        // backgroundColor: Colors.black.withOpacity(0.95),
      // ),
      // body: Container(
        // child: YoutubePlayer(
          // controller: _controller,
          // showVideoProgressIndicator: true,
// 
          // onReady: (){
            // print('ready');
          // },
        // ),
        // 
      // ),
    // );
  // }
// }
// 