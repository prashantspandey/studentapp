import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/MainTestScreen.dart';
import 'package:flutter/material.dart';
import 'package:student_app/screens/NativeVideoWebView.dart';
import 'package:student_app/screens/NewWebView.dart';
import 'package:url_launcher/url_launcher.dart';

class ChapterNotes extends StatefulWidget {
  StudentUser user = StudentUser();
  int chapterId;
  ChapterNotes(this.user, this.chapterId);
  @override
  _ChapterNotesState createState() => _ChapterNotesState();
}

class _ChapterNotesState extends State<ChapterNotes> {
  var finalURL;
  getChapterwiseNotes() async {
    var response = await getChapterNotes(widget.user.key, widget.chapterId);
    return response;
  }
  _launchUrl()async{
    print('final note url ${finalURL}');
    if(await canLaunch(finalURL)){
      await launch(finalURL,forceWebView: false);

    }
    else{
      throw "Could not open url";
    }


  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: getChapterwiseNotes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          var notes = snapshot.data['notes'];
          if (notes.length != 0) {
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          "assets/notebook.png",
                          height: MediaQuery.of(context).size.height * 0.045,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          notes[index]['title'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Subject : ' + notes[index]['subject'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          finalURL = "https://docs.google.com/viewer?url="+notes[index]['url'].replaceAll('\"', '');
                        });
                        _launchUrl();
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => _launchUrl(
                      //               "https://docs.google.com/viewer?url=" +
                      //                   notes[index]['url']
                      //                       .toString()
                      //                       .replaceAll("\"", ""))));
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No notes in this chapter.'),
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
