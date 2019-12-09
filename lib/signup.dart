import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chatlist.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: <Widget>[
            _buildSizedBoxWidget(),
            _buildImage(),
            _buildSizedBoxWidget(),
            _buildUserNameField(),
            _buildSizedBoxWidget(),
            _buildEmailField(),
            _buildSizedBoxWidget(),
            _buildPasswordField(),
            _buildSizedBoxWidget(),
            _buildSignUpButton()
          ],
        ),
      ),
    );
  }

  Widget _buildSizedBoxWidget() {
    return SizedBox(height: 30);
  }

  Widget _buildImage() {
    return Image.asset('assets/flutter.png', width: 60, height: 60);
  }

  Widget _buildUserNameField() {
    return TextField(
      controller: _usernameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hasFloatingPlaceholder: true,
        labelText: 'Username',
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hasFloatingPlaceholder: true,
        labelText: 'Email Address',
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        hasFloatingPlaceholder: true,
        labelText: 'Password',
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Center(
      child: Stack(
        children: <Widget>[
          (!_isloading)
              ? RaisedButton(
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  onPressed: _performSignUp,
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              : SizedBox(),
          (_isloading)
              ? Container(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Future _performSignUp() async {
    setState(() {
      _isloading = true;
    });

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty) {
      //create user

      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

        if (user != null) {
          //store user's data to firebase

          Map<String, String> map = new Map();
          map['email'] = _emailController.text;
          map['username'] = _usernameController.text;

          Firestore.instance
              .collection('Users')
              .document(user.uid)
              .setData(map)
              .then((data) {
            //navigate to home screen
            setState(() {
              _isloading = false;
            });

            _navigateToChatList();
          });
        } else {
          Fluttertoast.showToast(
              msg: "An error occured",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.black,
              fontSize: 14.0);
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          _isloading = false;
        });

        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 14.0);
      }
    } else {
      setState(() {
        _isloading = false;
      });
      Fluttertoast.showToast(
          msg: "Fields must not be empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 14.0);
    }
  }

  void _navigateToChatList() {
    Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(builder: (context) => ChatList()),
        (Route<dynamic> route) => false);
  }
}
