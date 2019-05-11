import 'package:carl/blocs/login/login_bloc.dart';
import 'package:carl/blocs/login/login_event.dart';
import 'package:carl/blocs/login/login_state.dart';
import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/shared/carl_textfield.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/loginPage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  LoginBloc _loginBloc;

  @override
  initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  _login() {
    print("Logging with credentitals :");
    print("userName : ${_usernameController.text}");
    print("password : ${_passwordController.text}");

    _loginBloc.dispatch(
        LoginButtonPressed(username: _usernameController.text, password: _passwordController.text));
  }

  _navigateBack(BuildContext context) async {
    Navigator.pop(context);
  }

  Widget _renderErrorByState(LoginState loginState) {
    var widget = Container();
    if (loginState is LoginCredentialsFailure) {
      widget = Container(
        child: Text("Bad credentials"),
      );
    } else if (loginState is LoginFailure) {
      Container(
        child: Text("Server error"),
      );
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(gradient: CarlTheme.of(context).mainGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Hero(
                            tag: "loginCarlFace",
                            child: Container(
                              height: 150,
                              width: 150,
                              child: Image.asset(
                                "assets/ic_carl.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      CarlTextField(
                        hintText: "Email",
                        controller: _usernameController,
                        textInputAction: TextInputAction.next,
                        focusNode: _userNameFocusNode,
                        onSubmitted: (text) {
                          _userNameFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(_passwordFocusNode);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CarlTextField(
                        hintText: "Password",
                        obscureText: true,
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        focusNode: _passwordFocusNode,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<LoginEvent, LoginState>(
                        bloc: _loginBloc,
                        builder: (BuildContext context, LoginState loginState) {
                          if (loginState is LoginSuccess) {
                            _navigateBack(context);
                          }
                          return Column(
                            children: <Widget>[
                              CarlButton(
                                text: "Valider",
                                width: MediaQuery.of(context).size.width * 0.8,
                                onPressed: () {
                                  _login();
                                },
                                textStyle: CarlTheme.of(context).bigButtonLabelStyle,
                                isLoading: loginState is LoginLoading,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _renderErrorByState(loginState)
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
