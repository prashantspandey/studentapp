import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/Login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String instituteCode = 'ou';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        ClipPath(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/logo.png",height: MediaQuery.of(context).size.height*0.2,),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            color: Colors.orange,
          ),
          clipper: MyClipper(),
        ),
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.height * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: "FullName",
                        prefixIcon: Icon(Icons.person),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)))),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.010)),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: "Phone Number",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)))),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.010)),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.vpn_key),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)))),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.010)),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: Icon(Icons.vpn_key),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)))),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.025)),
              Container(
                child: MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.06,
                    minWidth: MediaQuery.of(context).size.width * 0.85,
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.height * 0.022),
                    ),
                    onPressed: () async {
                      String username = usernameController.text;
                      String password = passwordController.text;
                      String confirmPassword = confirmPasswordController.text;
                      String name = nameController.text;
                      if (password == confirmPassword) {
                        var response = await studentRegister(
                            name, username, password, instituteCode);
                        if (response['status'] == 'Success') {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));

                          Fluttertoast.showToast(
                              msg:
                                  'Successfully Registered !! Now login using your phone and password.');
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'Error in registration - ${response['message']}');
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Your passwords don\'t match.');
                      }

                      //Studentpage(studentUser);
                    }),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already a member ?"),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.022),
                      ))
                ],
              )
            ],
          ),
        )
      ],
    )));
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
