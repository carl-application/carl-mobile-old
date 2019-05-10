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
  LoginBloc _loginBloc;

  @override
  initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  dispose() {
    _loginBloc.dispose();
    super.dispose();
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
    dispose();
  }

  Widget _renderErrorByState(LoginState loginState) {
    var widget = Container();
    if(loginState is LoginCredentialsFailure) {
      widget = Container(
        child: Text("Bad credentials"),
      );
    } else if (loginState is LoginFailure){
      Container(
        child: Text("Server error"),
      );
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CarlTheme.of(context).mainGradient),
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
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
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    CarlTextField(
                      hintText: "Email",
                      controller: _usernameController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CarlTextField(
                      hintText: "Password",
                      obscureText: true,
                      controller: _passwordController,
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
              ),
            ],
          ),
        )),
      ),
    );
  }
}
