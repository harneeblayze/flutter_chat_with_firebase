import 'package:flutter/material.dart';
import 'package:flutter_chat/login.dart';
import 'package:flutter_chat/signup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/flutter.png', width: 100, height: 100),
            SizedBox(height: 40),
            Text(
              'Flutter chat',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _navigateToLoginScreen,
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(width: 20),
                RaisedButton(
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  onPressed: _navigateToSignUp,
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLoginScreen() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Login()));
  }

  void _navigateToSignUp() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => SignUp()));
  }
}
