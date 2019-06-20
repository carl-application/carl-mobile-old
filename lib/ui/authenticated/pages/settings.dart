import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/authentication/authentication_event.dart';
import 'package:carl/translations.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:package_info/package_info.dart';

class Settings extends StatelessWidget {
  static const String routeName = "/settingsPage";

  _logOut(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedOut());
  }

  _showLogoutDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: Translations.of(context).text("log_out_confirmation_title"),
            description: Translations.of(context).text("log_out_confirmation_description"),
            yesButtonText: Translations.of(context).text("validate"),
            noButtonText: Translations.of(context).text("cancel"),
            onYesClicked: () => _logOut(context),
            onNoClicked: () => Navigator.of(context).pop(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: CarlTheme.of(context).background,
      child: SafeArea(
        child: Padding(
          padding: CarlTheme.of(context).pagePadding,
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  Translations.of(context).text("settings_title"),
                  style: CarlTheme.of(context).blackTitle,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    SettingsItem(
                      label: Translations.of(context).text('settings_logout_label'),
                      onCLick: () => _showLogoutDialog(context),
                    )
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                      print("snap = $snapshot");
                      if (snapshot.hasData) {
                        return Text(
                          "v.${snapshot.data.version}",
                          style: CarlTheme.of(context).greyLittleLabel,
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    child: CircleImageInkWell(
                      onPressed: () => Navigator.of(context).pop(),
                      size: 50,
                      image: AssetImage('assets/ic_close.png'),
                      splashColor: Colors.black26,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class SettingsItem extends StatelessWidget {
  final String label;
  final VoidCallback onCLick;

  const SettingsItem({Key key, this.label, this.onCLick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            label,
                            style: CarlTheme.of(context).blackMediumBoldLabel,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/ic_arrow_right.png",
                      height: 50,
                      width: 50,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned.fill(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Material(
            child: InkWell(
              onTap: () {
                if (onCLick != null) {
                  onCLick();
                }
              },
            ),
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(20.0),
            clipBehavior: Clip.antiAlias,
          ),
        ),
      ),
    ]);
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String yesButtonText;
  final String noButtonText;
  final VoidCallback onYesClicked;
  final VoidCallback onNoClicked;

  ConfirmationDialog({
    @required this.title,
    @required this.description,
    @required this.yesButtonText,
    @required this.noButtonText,
    @required this.onYesClicked,
    @required this.onNoClicked,
  });

  @override
  Widget build(BuildContext context) {
    final dialogSize = MediaQuery.of(context).size.width * .7;
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: 200,
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        title,
                        style: CarlTheme.of(context).blackTitle,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        description,
                        style: CarlTheme.of(context).greyMediumLabel,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      colorBrightness: Theme.of(context).brightness,
                      color: Colors.grey,
                      elevation: 2,
                      padding: EdgeInsets.only(top: 15, right: 30, bottom: 15, left: 30),
                      shape:
                          new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: onNoClicked,
                      child: Text(
                        noButtonText,
                        style: CarlTheme.of(context).whiteMediumLabel,
                      ),
                    ),
                    RaisedButton(
                      colorBrightness: Theme.of(context).brightness,
                      color: CarlTheme.of(context).primaryColor,
                      elevation: 2,
                      padding: EdgeInsets.only(top: 15, right: 30, bottom: 15, left: 30),
                      shape:
                          new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: onYesClicked,
                      child: Text(
                        yesButtonText,
                        style: CarlTheme.of(context).whiteMediumLabel,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
