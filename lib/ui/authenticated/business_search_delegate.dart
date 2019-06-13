import 'package:carl/blocs/search_businesses/search_businesses_bloc.dart';
import 'package:carl/blocs/search_businesses/search_businesses_event.dart';
import 'package:carl/blocs/search_businesses/search_businesses_state.dart';
import 'package:carl/models/navigation_arguments/card_detail_arguments.dart';
import 'package:carl/ui/authenticated/pages/card_detail.dart';
import 'package:carl/ui/authenticated/tag_item.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme.dart';

class BusinessSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Icon(
        Icons.arrow_back,
        size: 25,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final _searchBloc = BlocProvider.of<SearchBusinessesBloc>(context);
    final List<Color> tagsColors = CarlTheme.of(context).tagsColors;
    _searchBloc.dispatch(SearchBusinessesByNameEvent(query));
    return BlocBuilder(
      bloc: _searchBloc,
      builder: (BuildContext context, SearchBusinessesState state) {
        if (state is SearchBusinessesLoading) {
          return Center(
            child: Loader(),
          );
        } else if (state is SearchBusinessesLoadingSuccess) {
          final results = state.businesses;
          return ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                final business = results[index];

                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, CardDetail.routeName,
                        arguments: CardDetailArguments(results[index].id));
                  },
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
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
                                color: tagsColors[index % tagsColors.length],
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
                );
              });
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
