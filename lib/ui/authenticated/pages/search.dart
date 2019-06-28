import 'package:carl/blocs/search_businesses/search_businesses_bloc.dart';
import 'package:carl/blocs/search_businesses/search_businesses_event.dart';
import 'package:carl/blocs/search_businesses/search_businesses_state.dart';
import 'package:carl/models/navigation_arguments/card_detail_arguments.dart';
import 'package:carl/translations.dart';
import 'package:carl/ui/authenticated/pages/card_detail.dart';
import 'package:carl/ui/authenticated/tag_item.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:carl/ui/shared/rounded_icon.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Search extends StatefulWidget {
  static const routeName = "/Search";

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _controller = TextEditingController();
  SearchBusinessesBloc _searchBloc;

  _onTextChanged(String newText) {
    if (newText.length >= 3) {
      _searchBloc.dispatch(SearchBusinessesByNameEvent(newText));
    }
  }

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBusinessesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: CarlTheme.of(context).background,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        RoundedIcon(
                          assetIcon: "assets/back.png",
                          onClick: () => Navigator.pop(context),
                          iconSize: 10,
                          padding: 10,
                          backgroundColor: CarlTheme.of(context).searchGreyColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  color: CarlTheme.of(context).searchGreyColor),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Theme(
                                  child: TextField(
                                    autofocus: true,
                                    controller: _controller,
                                    onChanged: (newText) => _onTextChanged(newText),
                                    style: CarlTheme.of(context).blackMediumLabel,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.search),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          _searchBloc.dispatch(SearchBusinessesClear());
                                          _controller.clear();
                                        },
                                      ),
                                      border: InputBorder.none,
                                      filled: false,
                                      hintText: Translations.of(context).text("search_label"),
                                      hintStyle: TextStyle(
                                        color: Color.fromRGBO(142, 142, 147, 1),
                                      ),
                                    ),
                                  ),
                                  data: Theme.of(context).copyWith(
                                      primaryColor: Colors.black, cursorColor: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                BlocBuilder(
                  bloc: _searchBloc,
                  builder: (BuildContext context, SearchBusinessesState state) {
                    if (state is SearchBusinessesInitialState) {
                      return Container();
                    } else if (state is SearchBusinessesLoading) {
                      return Expanded(
                        child: Center(
                          child: Loader(),
                        ),
                      );
                    } else if (state is SearchBusinessesLoadingSuccess) {
                      final results = state.businesses;
                      return Expanded(
                        child: ListView.builder(
                            itemCount: results.length,
                            itemBuilder: (BuildContext context, int index) {
                              final business = results[index];
                              return Material(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context, CardDetail.routeName,
                                        arguments: CardDetailArguments(results[index].id));
                                  },
                                  leading: Container(
                                    decoration:
                                        BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: new BorderRadius.circular(20.0),
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.network(
                                          business.logo.url,
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    business.businessName,
                                    style: CarlTheme.of(context).blackMediumBoldLabel,
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                    child: Container(
                                      height: 25,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: business.tags.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Row(
                                            children: <Widget>[
                                              TagItem(
                                                color: CarlTheme.of(context).tagsColors[
                                                    index % CarlTheme.of(context).tagsColors.length],
                                                name: business.tags[index].name,
                                                textStyle: CarlTheme.of(context).whiteMediumLabel,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                  dense: true,
                                ),
                              );
                            }),
                      );
                    }
                  },
                )
              ],
            ),
          )),
    );
  }
}
