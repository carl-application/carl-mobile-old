import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  static const String routeName = "/searchPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Color.fromRGBO(0, 0, 0, .05),
            filled: true,
            hintStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            hintText: "Recherche ...",
          ),
        ),
        backgroundColor: CarlTheme.of(context).background,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            size: 25,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.black,
            onPressed: () {
              showSearch(
                context: context,
                delegate: BusinessSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: CarlTheme.of(context).background,
        child: SafeArea(child: Padding(padding: CarlTheme.of(context).pagePadding)),
      ),
    );
  }
}

class BusinessSearchDelegate extends SearchDelegate {
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
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
