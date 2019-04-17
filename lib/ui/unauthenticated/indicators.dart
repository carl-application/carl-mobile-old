import 'package:carl/blocs/user_registration/user_registration_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Indicators extends StatelessWidget {
  Indicators({@required this.topEnable, @required this.bottomEnable});

  final bool topEnable;
  final bool bottomEnable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            if (topEnable) {
              final bloc = BlocProvider.of<UserRegistrationBloc>(context);
              bloc.dispatch(BackEvent());
            }
          },
          child: Icon(
            Icons.expand_less,
            size: 40,
            color: this.topEnable ? Colors.white : Colors.white30,
          ),
        ),
        InkWell(
          onTap: () {
            if (bottomEnable) {
              final bloc = BlocProvider.of<UserRegistrationBloc>(context);
              bloc.dispatch(NextEvent());
            }
          },
          child: Icon(
            Icons.expand_more,
            size: 40,
            color: this.bottomEnable ? Colors.white : Colors.white30,
          ),
        ),
      ],
    );
  }
}
