import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/ChangePasswordOTP.dart';
import 'package:student_app/screens/HomeScreen.dart';
import 'package:student_app/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        ClipPath(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Student App",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                // Image(
                //     height: 100,
                //     width: 100,
                //     image: AssetImage("asstes/flutter.png")),
                Padding(
                  padding: const EdgeInsets.only(left: 250, top: 50),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ),
            height: 350,
            width: double.infinity,
            color: Colors.orange,
          ),
          clipper: MyClipper(),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 350,
                child: TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "Phone Number",
                        prefixIcon: Icon(Icons.person),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)))),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Container(
                width: 350,
                child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        hintText: "Password",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)))),
              ),
              Container(
                  // color: Colors.red,
                  margin: EdgeInsets.only(left: 220),
                  child: FlatButton(
                      onPressed: null, child: Text("Forgot Pasword ?"))),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              Container(
                child: MaterialButton(
                    height: 50,
                    minWidth: 350,
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () async {
                      print('in on pressed');
                      String username = usernameController.text;
                      String password = passwordController.text;
                      StudentUser studentUser =
                          await studentLogin(username.toString().replaceAll("\ ", ''),password.toString().replaceAll("\ ", ""));
                      //user,studentsprint('teacher key ${teacheruser.key}');
                      //print('teacher name ${teacheruser.name}');
                      if (studentUser == null) {
                        Fluttertoast.showToast(
                            msg: "invalid user name and password",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 2,
                            textColor: Colors.red,
                            fontSize: 20.0);
                      }
                              else if (usernameController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              Fluttertoast.showToast(
                                 msg: "all fields are required",
                                toastLength: Toast.LENGTH_LONG,
                               gravity: ToastGravity.CENTER,
                              timeInSecForIos: 2,
                             textColor: Colors.red,
                            fontSize: 20.0);
                      }
                      else {
                        print('login pressed');
                            SharedPreferences prefs = await preferences;
                          prefs.setString('userkey',studentUser.key);
                           prefs.setString('institute',studentUser.institute);
                           prefs.setString('username',studentUser.username);
                          prefs.setString('name',studentUser.name);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(studentUser)));
                      }

                      // print(respone);
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 100),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text('Forgot Password? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordOTP()));
                      },
                      child: Text(
                        'Change Password',
                        style: TextStyle(color: Colors.orange),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text('Are you member ? If not '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()));
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.orange),
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        )
      ],
    ));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var controllpoint = Offset(50, size.height);
    var endpoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controllpoint.dx, controllpoint.dy, endpoint.dx, endpoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
