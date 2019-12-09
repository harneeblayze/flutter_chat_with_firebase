import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chatlist.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
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
            _buildEmailField(),
            _buildSizedBoxWidget(),
            _buildPasswordField(),
            _buildSizedBoxWidget(),
            _buildLoginButton()
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

  Widget _buildLoginButton() {
    return Center(
      child: Stack(
        children: <Widget>[
          (!_isloading)
              ? RaisedButton(
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  onPressed: _performSignUp,
                  child: Text(
                    'Login',
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
        _passwordController.text.isNotEmpty) {
      //create user

      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

        if (user != null) {
          //navigate to chatlist after successful login
          _navigateToChatList();
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
