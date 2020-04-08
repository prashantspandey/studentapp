import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/MainTestScreen.dart';
import 'package:flutter/material.dart';
import 'package:student_app/screens/NativeVideoWebView.dart';

class ChapterTests extends StatefulWidget {
  StudentUser user = StudentUser();
  int chapterId;
  ChapterTests(this.user, this.chapterId);
  @override
  _ChapterTestsState createState() => _ChapterTestsState();
}

class _ChapterTestsState extends State<ChapterTests> {
  getChapterwiseTest() async {
    var response = await getChapterTests(widget.user.key, widget.chapterId);
    return response;
  }
  showConfirmationDialog(context,test){
    return showDialog(context: context,barrierDismissible: false,builder: (context){
      return AlertDialog(content: Container(child: Column(children: <Widget>[
        Text('You want to start test now? You can only take this test only once'),
        Row(children: <Widget>[
          RaisedButton(color:Colors.black,child: Text('Start test',style: TextStyle(color: Colors.white),), onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MainTestScreen(widget.user, test)));

          },),
          RaisedButton(color:Colors.black,child: Text('Start test',style: TextStyle(color: Colors.white),), onPressed: () {
            Navigator.pop(context);
          },),
        ],)

      ],),),);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: getChapterwiseTest(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          var tests = snapshot.data['tests'];
          if (tests.length != 0) {
            return ListView.builder(
              itemCount: tests.length,
              itemBuilder: (BuildContext context, int index) {
                     return ListTile(
                    title: Text(tests[index]['numberQuestions'].toString() +
                        ' questions'),
                    leading: Icon(Icons.threesixty),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text('Time: ' +
                                tests[index]['time'].toString() +
                                ' min'),
                            Text('Marks: ' +
                                tests[index]['totalMarks'].toString())
                          ],
                        ),
                        Text('Subjects'),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: tests[index]['subjects'].length,
                            itemBuilder:
                                (BuildContext context, int subjectindex) {
                              return Text(tests[index]['subjects'][subjectindex]
                                  ['name']);
                            },
                          ),
                        ),
                        Text('Chapters'),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: tests[index]['chapters'].length,
                            itemBuilder:
                                (BuildContext context, int chapterindex) {
                              return Text(tests[index]['chapters'][chapterindex]
                                  ['name']);
                            },
                          ),
                        ),
                        Divider(
                          color: Colors.orange,
                        )
                      ],
                    ),
                    onTap: () async {
                      var test = await getIndividualTest(widget.user.key, tests[index]['id']);
                      print('all test test ${test.id}');
                      showConfirmationDialog(context, test);
                    },
                  );


              },
            );
          } else {
            return Center(
              child: Text('No tests in this chapter.'),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
